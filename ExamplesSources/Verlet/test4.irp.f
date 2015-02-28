program test4
  implicit none
  BEGIN_DOC
  ! Program testing the acceleration
  END_DOC
  integer                        :: i
  do i=1,Natoms
    print *, acceleration(:,i)
  enddo
end program
