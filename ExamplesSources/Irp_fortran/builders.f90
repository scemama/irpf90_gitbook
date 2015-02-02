subroutine build_t(x,y,result)
  implicit none
  integer, intent(in)  :: x, y
  integer, intent(out) :: result
  result = x + y + 4
end subroutine build_t

subroutine build_w(x,result)
  implicit none
  integer, intent(in)  :: x
  integer, intent(out) :: result
  result = x + 3
end subroutine build_w
   
subroutine build_v(x,y,result)
  implicit none
  integer, intent(in)  :: x, y
  integer, intent(out) :: result
  result = x + y + 2
end subroutine build_v
   
subroutine build_u(x,y,result)
  implicit none
  integer, intent(in)  :: x, y
  integer, intent(out) :: result
  result = x + y + 1
end subroutine build_u
   
subroutine build_d(d1,d2,d3,d4,d5)
  implicit none
  integer, intent(out) :: d1,d2,d3,d4,d5
  read(*,*) d1,d2,d3,d4,d5
end
