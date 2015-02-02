Debugging
=========

Displaying the exploration of the tree
--------------------------------------

New users of IRPF90 who are experienced Fortran programmers like to
display the exploration of the tree when they execute their first programs.
The ``-d`` option of ``irpf90`` prints a message when the program enters
or exits a function/provider/subroutine. 

In the ``uvwt`` example, the output is:

```
$ ./irp_example1 
 d1
1
 d2
2
 d3
3
 d4
4
 d5
5
 t =           26
```

Activating the ``-d`` option gives the following output:

```
$ ./irp_example1 
0 : -> provide_t
0 :  -> provide_u1
0 :   -> provide_d1
0 :    -> d1
 d1
1
 d2
2
 d3
3
 d4
4
 d5
5
0 :    <- d1  6.889999999999999E-004
0 :   <- provide_d1  8.070000000000000E-004
0 :   -> u1
0 :    -> fu
0 :    <- fu  9.999999999996990E-007
0 :   <- u1  2.900000000000038E-005
0 :  <- provide_u1  8.999999999999998E-004
0 :  -> provide_v
0 :   -> provide_w
0 :    -> w
0 :    <- w  1.000000000000133E-006
0 :   <- provide_w  2.700000000000011E-005
0 :   -> provide_u2
0 :    -> u2
0 :     -> fu
0 :     <- fu  1.000000000000133E-006
0 :    <- u2  2.015000000000000E-003
0 :   <- provide_u2  2.026000000000000E-003
0 :   -> v
0 :   <- v  0.000000000000000E+000
0 :  <- provide_v  2.089000000000000E-003
0 :  -> t
0 :  <- t  0.000000000000000E+000
0 : <- provide_t  3.033000000000000E-003
0 : -> irp_example1
 t =           26
0 : <- irp_example1  0.000000000000000E+000
```

The floating point numbers given in the output are the CPU times, and the
integer on the left of each line is the thread ID.

Compiler errors
---------------

When the Fortran compiler fails, it reports an error in the Fortran code.
This error is difficult for us to track because IRPF90 generated the Fortran
and we need to be able to do the mapping from the Fortran compiler's error
to the error in the ``*.irp.f`` file. To achieve this goal, the generated
Fortran code has comments at the end of the lines which correspond to the
file names and line numbers of the original ``*.irp.f`` file.

Let us introduce an error in the IRPF90 code (a missing closing parenthesis)

``` fortran
BEGIN_PROVIDER [ integer, u2 ]
  implicit none
  BEGIN_DOC
! This is u2 = u(d3,d4)
  END_DOC
  integer :: fu
  u2 = fu(d3,d4
END_PROVIDER
```

The generated Fortran code in the ``IRPF90_temp/uvwt.irp.F90`` file is 

``` fortran
subroutine bld_u2
  use uvwt_mod
  use input_mod
  implicit none                    ! uvwt.irp.f:  35
  character*(2) :: irp_here = 'u2' ! uvwt.irp.f:  34
  integer :: fu                    ! uvwt.irp.f:  39
  u2 = fu(d3,d4                    ! uvwt.irp.f:  40
end subroutine bld_u2
```

Running ``make`` produces this error (with the Intel Fortran compiler)

```
ifort -I IRPF90_temp/  -O2  -c IRPF90_temp/uvwt.irp.F90 -o IRPF90_temp/uvwt.irp.o
IRPF90_temp/uvwt.irp.F90(71): error #5082: Syntax error, found END-OF-STATEMENT when expecting one of: ( * ) :: , . % + - [ : . ** / // .LT. < .LE. <= .EQ. == ...
  u2 = fu(d3,d4                    ! uvwt.irp.f:  40
----------------------------------------------------^
compilation aborted for IRPF90_temp/uvwt.irp.F90 (code 1)
make: *** [IRPF90_temp/uvwt.irp.o] Error 1
```

IRP_here
--------

You can remark the presence of the ``irp_here`` variable in the generated
``bld_u2`` generated subroutine. Every subroutine, function or provider has
a string local variable named ``irp_here``, which contains the name of the
current context. This variable is very helpful for users to print debug/error
messages:

```
   print *, irp_here//' : a = ', a
```

Tracing memory allocations
--------------------------

When the memory used by a program becomes too large, one would like to
find the IRP entities that may be responsible. The ``-m`` option will
display a message in the standard output when an array for an IRP entity is
allocated or deallocated (using the ``FREE`` keyword).

Here is a real-world example (taken from the Quantum package IRPF90 code):

```
          10 Allocating ci_electronic_energy(N_states_diag)
          10 Allocating ci_eigenvectors(N_det,N_states_diag)
          10 Allocating ci_eigenvectors_s2(N_states_diag)
      128260 Allocating psi_det(N_int,2,psi_det_size)
...
 Deallocating ci_eigenvectors
       30600 Allocating ci_eigenvectors(N_det,N_states_diag)
        6120 Allocating det_connections(N_con_int,N_det)
```

The integer at the beginning of the line is the number of elements in the
array.

Debugging an embedded script
----------------------------

TODO


Debugging ``TOUCH`` statements
------------------------------

``TOUCH`` statements are particularly dangerous because they violate
the principle that one IRP entity can only be built by its builder, which
can only be called by its provider. To see what will be invalidated by a
``TOUCH`` statement can be useful to understand the consequences of a
dangerous modification. The ``-t`` option displays which IRP entities will
be invalidated :

```
$ irpf90 -t psi_coef
Touching psi_coef invalidates the following entities:
- ci_electronic_energy
- ci_energy
- coef_hf_selector
- exc_degree_per_selectors
- n_det_generators
- n_det_selectors
- one_body_dm_mo
- psi_average_norm_contrib
- psi_det_sorted
- psi_generators
- psi_selectors
- s2_values
```


