Implementing the molecular dynamics
-----------------------------------

### Exercise

The Verlet algorithm is the following

![Verlet algorithm](EqVerlet.svg)

where *n* is the index of the current step, **r** is the position vector, **v**
is the velocity vector, **a** is the acceleration vector and 
![delta_t](EqDeltaT.svg) is the time step.

Write a subroutine which implements the Verlet algorithm. To do this,
at each iteration :
- Compute the coordinates at step *n*+1
- Compute the component of the velocity which depends on the position at step
  *n*
- ``TOUCH`` the coordinates and the velocities
- Add to the velocities the part which depends on step *n*+1
- ``TOUCH`` the velocities

For this exercise, remove the debug option in the ``Makefile``.

### Expected output

``` text
$ ./test5 
 Number of atoms?
3
 For each atom: x, y, z, mass?
0 0 0 40
0 0 .5 40
.1 .2 -.5 40
   0.0000000000000000        0.0000000000000000        0.0000000000000000     
   0.0000000000000000        0.0000000000000000       0.50000000000000000     
  0.10000000000000001       0.20000000000000001      -0.50000000000000000     
 Epsilon?
0.0661
 Sigma?
0.3345
 Nsteps?
1000
 Time step?
0.2
 -4.85173622655117529E-002 -9.70435723126635286E-002  0.18819318396255702     
 -1.11022166416810172E-002 -2.22085304763539326E-002  0.62064345108566521     
  0.15961957890929021       0.31925210279233324      -0.80883663504845249 
```

### Solution

File ``test5.irp.f``

``` irpf90
program test5
  implicit none
  BEGIN_DOC
  ! Program testing the verlet algorithm
  END_DOC
  integer                        :: i
  do i=1,Natoms
    print *,  coord(1:3,i)
  enddo
  call verlet
  do i=1,Natoms
    print *,  coord(1:3,i)
  enddo
end 
```

File ``verlet.irp.f``

``` irpf90
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
  coord(k,i) += tstep*velocity(k,i) + 0.5d0*tstep2*acceleration(k,i)
        velocity(k,i) += 0.5d0*tstep*acceleration(k,i)
      enddo
    enddo
    ! (Touch also mass because it is provided with coord)
    TOUCH coord mass velocity
    do i=1,Natoms
      do k=1,3
        velocity(k,i) += 0.5d0*tstep*acceleration(k,i)
      enddo
    enddo
    TOUCH velocity
  enddo
end subroutine
```

8. Handling files
-----------------

### Exercise

Add a call to a printing subroutine at each step of the dynamics. The printing
subroutine will print th coordinates of the atoms in a file. To do this,
uncomment the call statement in the previous exercise and write the
``print_data`` subroutine as well as the associated providers.

### Solution

File ``files.irp.f``
``` irpf90
integer function getUnitAndOpen(f,mode)
  implicit none
  BEGIN_DOC
  ! Finds an available unit number and opens the file
  END_DOC
  character*(*)                  :: f
  character*(128)                :: new_f
  integer                        :: iunit
  logical                        :: is_open, exists
  character                      :: mode

  is_open = .True.
  iunit = 10
  new_f = f
  do while (is_open)
    inquire(unit=iunit,opened=is_open)
    if (.not.is_open) then
      getUnitAndOpen = iunit
    endif
    iunit = iunit+1
  enddo
  if (mode.eq.'r') then
    inquire(file=f,exist=exists)
    if (.not.exists) then
      open(unit=getUnitAndOpen,file=f,status='NEW',action='WRITE')
      close(unit=getUnitAndOpen)
    endif
    open(unit=getUnitAndOpen,file=f,status='OLD',action='READ')
  else if (mode.eq.'w') then
    open(unit=getUnitAndOpen,file=new_f,status='UNKNOWN',action='WRITE')
  else if (mode.eq.'a') then
    open(unit=getUnitAndOpen,file=new_f,status='UNKNOWN',            &
        action='WRITE',position='APPEND')
  else if (mode.eq.'x') then
    open(unit=getUnitAndOpen,file=new_f)
  endif
end function getUnitAndOpen

BEGIN_PROVIDER [ integer, output ]
  implicit none
  BEGIN_DOC
  !  File unit corresponding to the output file.
  END_DOC
  integer                        :: getUnitAndOpen
  output = getUnitAndOpen('output','w')
END_PROVIDER

subroutine print_data(is)
  implicit none
  integer, intent(in)            :: is
  write(output,*) Natoms
  write(output,'(I8, 3(2X, E15.8))') is, V, T, E_tot
  integer                        :: i
  do i=1,Natoms
    write(output,'(A,3(2X,F15.8))') 'Ar', coord(:,i)
  enddo
end subroutine print_data
```

