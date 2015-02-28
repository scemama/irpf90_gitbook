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
