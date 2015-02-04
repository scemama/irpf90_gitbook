Using scripts to generate specialized functions
===============================================

In this example we write a Python script ``power.py`` that will generate
specialized functions to calculate the `n`-th power of `x`.

``` python
#!/usr/bin/python

POWER_MAX = 20

def compute_x_prod(n,d):
  if n == 0:
    d[0] = None
    return d
  if n == 1:
    d[1] = None
    return d
  if n in d:
    return d
  m = n/2
  d = compute_x_prod(m,d)
  d[n] = None
  d[2*m] = None
  return d

def print_subroutine(n):
  keys = compute_x_prod(n,{}).keys()
  keys.sort()
  output = []
  print "double precision function power_%d(x1)"%n
  print " double precision, intent(in) :: x1"
  print " BEGIN_DOC"
  print "!  Fast computation of x**%d"%(n)
  print " END_DOC"
  for i in range(1,len(keys)):
     output.append( "x%d"%keys[i] )
  if output != []:
    print " double precision :: "+', '.join(output)
  for i in range(1,len(keys)):
   ki = keys[i]
   ki1 = keys[i-1]
   if ki == 2*ki1:
     print " x%d"%ki + " = x%d * x%d"%(ki1,ki1)
   else:
     print " x%d"%ki + " = x%d * x1"%(ki1)
  print " power_%d = x%d"%(n,n)
  print "end"

for i in range(POWER_MAX):
  print_subroutine (i+1)
  print ''

```

Executing this script gives
``` irpf90
double precision function power_1(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**1
 END_DOC
 power_1 = x1
end

double precision function power_2(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**2
 END_DOC
 double precision :: x2
 x2 = x1 * x1
 power_2 = x2
end

double precision function power_3(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**3
 END_DOC
 double precision :: x2, x3
 x2 = x1 * x1
 x3 = x2 * x1
 power_3 = x3
end

...


double precision function power_17(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**17
 END_DOC
 double precision :: x2, x4, x8, x16, x17
 x2 = x1 * x1
 x4 = x2 * x2
 x8 = x4 * x4
 x16 = x8 * x8
 x17 = x16 * x1
 power_17 = x17
end

double precision function power_18(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**18
 END_DOC
 double precision :: x2, x4, x8, x9, x18
 x2 = x1 * x1
 x4 = x2 * x2
 x8 = x4 * x4
 x9 = x8 * x1
 x18 = x9 * x9
 power_18 = x18
end

double precision function power_19(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**19
 END_DOC
 double precision :: x2, x4, x8, x9, x18, x19
 x2 = x1 * x1
 x4 = x2 * x2
 x8 = x4 * x4
 x9 = x8 * x1
 x18 = x9 * x9
 x19 = x18 * x1
 power_19 = x19
end

double precision function power_20(x1)
 double precision, intent(in) :: x1
 BEGIN_DOC
!  Fast computation of x**20
 END_DOC
 double precision :: x2, x4, x5, x10, x20
 x2 = x1 * x1
 x4 = x2 * x2
 x5 = x4 * x1
 x10 = x5 * x5
 x20 = x10 * x10
 power_20 = x20
end
```

Then, we create a ``benchmark.irp.f`` file that contains provider to compute
the 20 first `n`-th power of `x` using the traditional ``x**n``, and another
provider that will use our specialized functions

``` irpf90
BEGIN_PROVIDER [ double precision, x ]
  implicit none
  BEGIN_DOC
! Value of x
  END_DOC
  x = 1.2345d0
END_PROVIDER

BEGIN_PROVIDER [ double precision, x_p, (20) ]
  implicit none
  BEGIN_DOC
! array of x**p for 0 < p < 21 with the standard power functions
  END_DOC
  integer :: i
  do i=1,20
    x_p(i) = x**i
  enddo

END_PROVIDER

! Put the power.py script here for better inlining of the functions
BEGIN_SHELL [ /usr/bin/python ]
import power
END_SHELL

BEGIN_PROVIDER [ double precision, x_p_fast, (20) ]
  implicit none
  BEGIN_DOC
! array of x**p for 0 < p < 21 with the fast power functions
  END_DOC
  BEGIN_SHELL [ /bin/bash ]
  for i in {1..20}
  do
    echo "  double precision, external :: power_$i"
    echo "  !DIR$ FORCEINLINE"
    echo "  x_p_fast($i) = power_$i(x)"
  done
  END_SHELL

END_PROVIDER
```

We now Create a codelet for the ``x_p`` and the ``x_p_fast`` providers using

``` bash
$ irpf90 -c      x_p:100000000
$ irpf90 -c x_p_fast:100000000
$ make
```

We easily see that we get a speedup of 12x with the specialized power routines:

``` bash
$ ./codelet_x_p
 x_p
 -----------
 Cycles:
   261.97605379999999     
 Seconds:
  1.13999589999999997E-007

$ ./codelet_x_p_fast 
 x_p_fast
 -----------
 Cycles:
   21.707082620000001     
 Seconds:
  9.47659000000000108E-009
```

