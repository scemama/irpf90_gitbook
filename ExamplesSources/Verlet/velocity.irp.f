BEGIN_PROVIDER [ double precision, T ]
  implicit none
  BEGIN_DOC
  ! Kinetic energy per atom
  END_DOC
  T = 0.d0
  integer                        :: i
  do i=1,Natoms
    T += mass(i) * velocity2(i)
  enddo
  T *= 0.5d0
END_PROVIDER

BEGIN_PROVIDER [ double precision, velocity2, (Natoms) ]
  implicit none
  BEGIN_DOC
  ! Square of the norm of the velocity per atom
  END_DOC
  integer                        :: i, k
  do i=1,Natoms
    velocity2(i) = 0.d0
    do k=1,3
      velocity2(i) += velocity(k,i)*velocity(k,i)
    enddo
  enddo
END_PROVIDER

BEGIN_PROVIDER [ double precision, velocity, (3,Natoms) ]
  implicit none
  BEGIN_DOC
  ! Velocity vector per atom
  END_DOC
  integer                        :: i, k
  do i=1,Natoms
    do k=1,3
      velocity(k,i) = 0.d0
    enddo
  enddo
END_PROVIDER

