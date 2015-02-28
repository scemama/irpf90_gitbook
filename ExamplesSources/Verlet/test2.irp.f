program test2
  implicit none
  BEGIN_DOC
  ! Second test : distance matrix
  END_DOC
  integer                        :: i
  do i=1,Natoms
    print *, distance(1:3,i)
  enddo
end program
