BEGIN_PROVIDER [ double precision, V ]
  implicit none
  BEGIN_DOC
  ! Potential energy.
  END_DOC
  V = V_lj
END_PROVIDER

BEGIN_PROVIDER [ double precision, V_lj ]
  implicit none
  BEGIN_DOC
  ! Lennard Jones potential energy.
  END_DOC
  integer                        :: i,j
  double precision               :: sigma_over_r
  V_lj = 0.d0
  do i=1,Natoms
    do j=i+1,Natoms
      ASSERT (distance(j,i) > 0.d0)   ! <-- Avoid a possible division by zero
      sigma_over_r = sigma_lj / distance(j,i)
      V_lj += sigma_over_r**12 - sigma_over_r**6
    enddo
  enddo
  V_lj *= 4.d0 * epsilon_lj  ! <-- Note the *= operator
END_PROVIDER

 BEGIN_PROVIDER [ double precision, epsilon_lj ]
&BEGIN_PROVIDER [ double precision, sigma_lj   ]
  implicit none
  BEGIN_DOC
  ! Parameters of the Lennard-Jones potential
  END_DOC
  print *, 'Epsilon?'
  read(*,*) epsilon_lj
  ASSERT (epsilon_lj > 0.)
  
  print *, 'Sigma?'
  read(*,*) sigma_lj
  ASSERT (sigma_lj > 0.)
END_PROVIDER


! ------

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
      TOUCH coord           ! Tell IRPF90 that coord has been changed
      V_grad_numeric(k,i) = V      ! V is here V(x_i + delta)
      coord(k,i) -= 2.d0*dstep     ! Move coordinate x_i to x_i - delta
      TOUCH coord           ! Tell IRPF90 that coord has been changed
      V_grad_numeric(k,i) -= V      ! V is here V(x_i - delta)
      V_grad_numeric(k,i) *= .5d0/dstep
      coord(k,i) += dstep   ! Put back x_i to its initial position
                            ! It is not necessary to re-touch coord since
                            ! - at the next loop iteration it will be touched
                            ! - out of the loop, it is soft-touched
    enddo
  enddo
  SOFT_TOUCH coord   ! Does not re-provide the current entities. Here, V will
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

