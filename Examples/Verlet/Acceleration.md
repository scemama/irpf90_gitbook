Computing the acceleration
--------------------------

### Exercise

The acceleration vector is given by

![](EqAcceleration.svg)

where *x_i* is the *x* coordinate of atom *i* (an element of the ``coord`` array).
Write the provider for ``V_grad_numeric``, the finite-difference approximation of
the derivative of the potential with respect to the coordinates:

![](EqDerivV.svg)

It will be necessary to use the ``TOUCH`` keyword.

The computation of the acceleration should not depend directly on the method
used to compute the gradient, so we will use ``V_grad`` in the provider for the
``acceleration``. ``V_grad`` will be a simple copy of ``V_grad_numeric``.

### Expected output

``` text
$ ./test4 
           0 : -> provide_acceleration
           0 :  -> provide_natoms
           0 :   -> natoms
 Number of atoms?
3
           0 :   <- natoms  1.68999999999999879E-004
           0 :  <- provide_natoms  3.50999999999999750E-004
           0 :  -> provide_coord
           0 :   -> coord
 For each atom: x, y, z, mass?
0 0 0 10
0 0 .3 20
.1 .2 -.3 15
           0 :   <- coord  2.26999999999999771E-004
           0 :  <- provide_coord  3.32000000000000264E-004
           0 :  -> provide_v_grad
           0 :   -> provide_v_grad_numeric
           0 :    -> provide_v
           0 :     -> provide_v_lj
           0 :      -> provide_epsilon_lj
           0 :       -> epsilon_lj
 Epsilon?
0.0661
 Sigma?
.3345
           0 :       <- epsilon_lj  1.60999999999999685E-004
           0 :      <- provide_epsilon_lj  2.52000000000000054E-004
           0 :      -> provide_distance
           0 :       -> distance
           0 :       <- distance  2.00000000000026545E-006
           0 :      <- provide_distance  4.30000000000000694E-005
           0 :      -> v_lj
           0 :      <- v_lj  2.00000000000026545E-006
           0 :     <- provide_v_lj  4.05999999999999677E-004
           0 :     -> v
           0 :     <- v  1.00000000000013273E-006
           0 :    <- provide_v  4.78999999999999825E-004
           0 :    -> provide_dstep
           0 :     -> dstep
           0 :     <- dstep  9.99999999999699046E-007
           0 :    <- provide_dstep  2.59999999999999815E-005
           0 :    -> v_grad_numeric
           0 :     -> touch_coord
           0 :     <- touch_coord  1.00000000000013273E-006
           0 :     -> provide_v
           0 :      -> provide_v_lj
           0 :       -> provide_distance
           0 :        -> distance
           0 :        <- distance  1.00000000000013273E-006
           0 :       <- provide_distance  2.20000000000003179E-005
           0 :       -> v_lj
           0 :       <- v_lj  9.99999999999265365E-007
           0 :      <- provide_v_lj  6.70000000000002191E-005
           0 :      -> v
           0 :      <- v  9.99999999999265365E-007
           0 :     <- provide_v  1.10999999999999988E-004
           0 :     -> touch_coord
           0 :     <- touch_coord  1.00000000000013273E-006
           0 :     -> provide_v
           0 :      -> provide_v_lj
           0 :       -> provide_distance
           0 :        -> distance
           0 :        <- distance  1.00000000000013273E-006
           0 :       <- provide_distance  2.20000000000003179E-005
           0 :       -> v_lj
           0 :       <- v_lj  1.00000000000013273E-006
           0 :      <- provide_v_lj  6.29999999999996882E-005
           0 :      -> v
           0 :      <- v  1.00000000000013273E-006
           0 :     <- provide_v  1.06000000000000191E-004
           0 :     -> touch_coord
----8<--------------------------------------------------------------------
           0 :     <- touch_coord  1.00000000000013273E-006
           0 :     -> provide_v
           0 :      -> provide_v_lj
           0 :       -> provide_distance
           0 :        -> distance
           0 :        <- distance  1.00000000000013273E-006
           0 :       <- provide_distance  2.20000000000003179E-005
           0 :       -> v_lj
           0 :       <- v_lj  1.00000000000013273E-006
           0 :      <- provide_v_lj  6.39999999999998209E-005
           0 :      -> v
           0 :      <- v  1.00000000000013273E-006
           0 :     <- provide_v  1.05000000000000059E-004
           0 :     -> touch_coord
           0 :     <- touch_coord  1.00000000000013273E-006
           0 :    <- v_grad_numeric  2.71300000000000013E-003
           0 :   <- provide_v_grad_numeric  3.29999999999999955E-003
           0 :   -> v_grad
           0 :   <- v_grad  1.00000000000013273E-006
           0 :  <- provide_v_grad  3.35400000000000021E-003
           0 :  -> acceleration
           0 :  <- acceleration  1.00000000000013273E-006
           0 : <- provide_acceleration  4.20500000000000040E-003
           0 : -> test4
 -1.21434697006317371E-003 -2.42873782740904431E-003  -2.8852483886706581     
  3.77225707531847476E-004  7.54451431647651383E-004   1.4421824477394567     
  3.06597036647815457E-004  6.13223309409161033E-004  5.88995461163014712E-004
           0 : <- test4  8.89999999999996697E-005
```

### Solution

File ``test4.irp.f``
``` irpf90
ratiot4
  implicit none
  BEGIN_DOC
  ! Program testing the acceleration
  END_DOC
  integer                        :: i
  do i=1,Natoms
    print *, acceleration(:,i)
  enddo
end program
```

File ``potential.irp.f``, add
``` irpf90
BEGIN_PROVIDER [ double precision, dstep ]
  implicit none
  BEGIN_DOC
  ! Finite difference step
  END_DOC
  dstep = 1.d-4
END_PROVIDER

BEGIN_PROVIDER [ double precision, V_grad_numeric, (3,Natoms) ]
  implicit none
  BEGIN_DOC
  ! Numerical gradient of the potential
  END_DOC
  integer                        :: i, k
  do i=1,Natoms
    do k=1,3
      coord(k,i) += dstep   ! Move coordinate x_i to x_i + delta 
      TOUCH coord mass      ! Tell IRPF90 that coord has been changed
      V_grad_numeric(k,i) = V      ! V is here V(x_i + delta)
      coord(k,i) -= 2.d0*dstep     ! Move coordinate x_i to x_i - delta
      TOUCH coord mass      ! Tell IRPF90 that coord has been changed
      V_grad_numeric(k,i) -= V      ! V is here V(x_i - delta)
      V_grad_numeric(k,i) *= .5d0/dstep
      coord(k,i) += dstep   ! Put back x_i to its initial position
                            ! It is not necessary to re-touch coord since
                            ! - at the next loop iteration it will be touched
                            ! - out of the loop, it is soft-touched
    enddo
  enddo
  SOFT_TOUCH coord mass ! Does not re-provide the current entities. Here, V will
                        ! not be re-computed. This reduced the CPU time, but is
                        ! dangerous.
END_PROVIDER

BEGIN_PROVIDER [ double precision, V_grad, (3,Natoms) ]
  implicit none
  BEGIN_DOC
  ! Gradient of the potential
  END_DOC
  integer                        :: i,k
  do i=1,Natoms
    do k=1,3
      V_grad(k,i) = V_grad_numeric(k,i)
    enddo
  enddo
END_PROVIDER

BEGIN_PROVIDER [ double precision, acceleration, (3,Natoms) ]
  implicit none
  BEGIN_DOC
  ! Acceleration = - grad(V)/m
  END_DOC
  integer                        :: i, k
  do i=1,Natoms
    do k=1,3
      acceleration(k,i) = -V_grad(k,i)/mass(i)
    enddo
  enddo
END_PROVIDER
```

