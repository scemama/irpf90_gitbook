IRPF90 Basics
-------------

Let us rewrite the same code as in the previous section, but in the IRPF90
framework.

First, we create a file named ``uvwt.irp.f``:

``` irpf90
BEGIN_PROVIDER [ integer, t ]
  t = u1+v+4
END_PROVIDER

BEGIN_PROVIDER [integer,w]
  w = d5+3
END_PROVIDER

BEGIN_PROVIDER [ integer, v ]
  v = u2+w+2
END_PROVIDER

BEGIN_PROVIDER [ integer, u1 ]
  integer :: fu
  u1 = fu(d1,d2)
END_PROVIDER

BEGIN_PROVIDER [ integer, u2 ]
  integer :: fu
  u2 = fu(d3,d4)
END_PROVIDER

integer function fu(x,y)
  integer :: x,y
  fu = x+y+1
end function
```

This file contains usual Fortran statements, as well as new keywords. In Fortran
there are subroutines and functions, and IRPF90 introduces *Providers*. If an
entity is declared with a ``BEGIN_PROVIDER ... END_PROVIDER`` block, then it
is an IRP entity and it will behave as a global variable in the whole program.
All the provided entities are not supposed to be modified outside of their
providers.
The main point is that the provider will always be called automatically before
the variable is used. The programmer doesn't know when and where the provider
will be called.

Let us now introduce a provider for coupled data. Here, the input data will
be read from the standard input in a given order, so it is convenient to
provide them all at once in file ``input.irp.f``:

``` irpf90
 BEGIN_PROVIDER [ integer, d1 ]
&BEGIN_PROVIDER [ integer, d2 ]
&BEGIN_PROVIDER [ integer, d3 ]
&BEGIN_PROVIDER [ integer, d4 ]
&BEGIN_PROVIDER [ integer, d5 ]

  print *,  'd1, d2, d3, d4, d5?'
  read(*,*) d1, d2, d3, d4, d5

END_PROVIDER
```

Now, we can write the main function in the ``irp_example1.irp.f`` file:

``` irpf90
program irp_example1
  implicit none
  print *, 't = ', t
end
```

To compile the program, we will have to set up the IRPF90 environment:

``` bash
$ ls
input.irp.f  irp_example1.irp.f  uvwt.irp.f

$ irpf90 --init
$ ls
input.irp.f  irp_example1.irp.f  IRPF90_man  IRPF90_temp  Makefile  uvwt.irp.f
```

The created ``IRPF90_temp`` directory contains temporary files for the
compiling step: the generated Fortran files, as well as the corresponding
``.mod`` and ``.o`` files. ``IRPF90_man`` contains the generated man pages that
document the code, and a ``Makefile`` was created :

``` makefile
IRPF90 = irpf90  #-a -d
FC     = gfortran -ffree-line-length-none
FCFLAGS= -O2

SRC=
OBJ=
LIB=

include irpf90.make

irpf90.make: $(filter-out IRPF90_temp/%, $(wildcard */*.irp.f)) \
             $(wildcard *.irp.f) $(wildcard *.inc.f) Makefile
        $(IRPF90)
```

To build the test program, simply run ``make``. The ``Makefile`` includes the
``irpf90.make`` file which does not exist, but there is a rule to create it by
calling IRPF90.
IRPF90 analyzes the code present in all the ``*.irp.f`` files of the current
directory.  The list of IRP entities is created in a first pass, then a second
pass analyzes the dependencies between the entities. From all this information,
it creates the Fortran code that will call the providers of each entity before
it is used.
As the dependencies between the entities are known the ``irpf90.make`` file,
containing all the dependencies between the files, can be written.

Once IRPF90 has created the ``irpf90.make`` file, it can be included and the
Fortran files can be compiled. As the ``irpf90.make`` file depends on all the
``*.irp.f`` files of the current directory, each modification or creation of an
``*.irp.f`` file will force IRPF90 to run before compiling. To summarize, you
almost never need to write anything in the Makefiles. You just need to write
``*.irp.f`` files and run ``make``.

``` 
$ make
Makefile:9: irpf90.make: No such file or directory
irpf90  
IRPF90_temp/irp_example1.irp.module.F90
IRPF90_temp/irp_example1.irp.F90
IRPF90_temp/uvwt.irp.module.F90
IRPF90_temp/uvwt.irp.F90
IRPF90_temp/input.irp.module.F90
IRPF90_temp/input.irp.F90
Warning: Variable u1 is not documented
Warning: Variable u2 is not documented
Warning: Variable t is not documented
Warning: Variable w is not documented
Warning: Variable v is not documented
Warning: Variable d1 is not documented
Warning: Subroutine irp_example1 is not documented
Warning: Subroutine fu is not documented
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/irp_example1.irp.module.F90 -o IRPF90_temp/irp_example1.irp.module.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/uvwt.irp.module.F90 -o IRPF90_temp/uvwt.irp.module.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/irp_example1.irp.F90 -o IRPF90_temp/irp_example1.irp.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/irp_stack.irp.F90 -o IRPF90_temp/irp_stack.irp.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/input.irp.module.F90 -o IRPF90_temp/input.irp.module.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/uvwt.irp.F90 -o IRPF90_temp/uvwt.irp.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/input.irp.F90 -o IRPF90_temp/input.irp.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -O2 -c IRPF90_temp/irp_touches.irp.F90 -o IRPF90_temp/irp_touches.irp.o
gfortran -ffree-line-length-none -I IRPF90_temp/  -o irp_example1 IRPF90_temp/irp_example1.irp.o IRPF90_temp/irp_example1.irp.module.o IRPF90_temp/irp_stack.irp.o  IRPF90_temp/uvwt.irp.o IRPF90_temp/uvwt.irp.module.o IRPF90_temp/input.irp.o IRPF90_temp/input.irp.module.o  IRPF90_temp/irp_touches.irp.o  
```

### Array entities

An array is considered *valid* when all of its values are valid. The dimensions
of an array entity can be IRP entities, constants or intervals.

``` irpf90
BEGIN_PROVIDER [ integer, fact_max ]
  fact_max = 10
END_PROVIDER

BEGIN_PROVIDER [ double precision, fact, (0:fact_max) ]
  implicit none
  integer :: i
  fact(0) = 1.d0
  do i=1,fact_max
    fact(i) = fact(i-1)*dble(i)
  end do
END_PROVIDER
```

In this example, as the array ``fact`` depends on its dimensioning variable
``fact_max``, ``fact_max`` is provided first. Then, the ``fact`` array is
allocated with the required dimensions, and then the code inside the provider
is executed. Note that if the ``fact`` array is not used in the program, it
will never be allocated.

### Freeing entities

It is possible to free memory by using the ``FREE`` keyword.

``` irpf90
BEGIN_PROVIDER [ double precision, table2, (size(table1,1)) ]
  implicit none
  table2(:) = 2.d0 * table1(:)
  FREE table1
END_PROVIDER
```

When ``table1`` is freed, the entity ``table1`` is marked as *non-valid*, such
that if it is needed again, it will be reallocated and rebuilt.

When applying the ``FREE`` keyword to scalar entities, those are just marked
as non-built.

### Forcing to provide entities

The ``PROVIDE`` keyword forces to provide an entity, even if it is not 
needed. 

In this example,

``` irpf90
subroutine s()
  implicit none
  PROVIDE u v
end
```

``u`` and ``v`` will be provided before entering in the scope of subroutine
``s``.

This second example forces to re-provide the ``random_x`` entity at every loop
cycle (version >= 1.5.0):

```
do i=1,N
  PROVIDE random_x
  print *, random_x
  FREE random_x
end do
```


