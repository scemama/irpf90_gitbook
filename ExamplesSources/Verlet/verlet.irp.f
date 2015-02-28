BEGIN_PROVIDER [ integer, Nsteps ]
  implicit none
  BEGIN_DOC
  ! Number of steps for the dynamics
  END_DOC
  print *, 'Nsteps?'
  read(*,*) Nsteps
  ASSERT (Nsteps > 0)
END_PROVIDER

 BEGIN_PROVIDER [ double precision, tstep ]
&BEGIN_PROVIDER [ double precision, tstep2 ]
  implicit none
  BEGIN_DOC
  ! Time step for the dynamics
  END_DOC
  print *, 'Time step?'
  read(*,*) tstep
  ASSERT (tstep > 0.d0)
  tstep2 = tstep*tstep
END_PROVIDER

subroutine verlet
  implicit none
  integer                        :: is, i, k
  do is=1,Nsteps
    call print_data(is)     ! <--  Un-comment for the next exercise
    do i=1,Natoms
      do k=1,3
        coord(k,i) += tstep*velocity(k,i) + 0.5d0*tstep2*acceleration(k,i)
        velocity(k,i) += 0.5d0*tstep*acceleration(k,i)
      enddo
    enddo
    TOUCH coord mass velocity
    do i=1,Natoms
      do k=1,3
        velocity(k,i) += 0.5d0*tstep*acceleration(k,i)
      enddo
    enddo
    TOUCH velocity
  enddo
end subroutine

