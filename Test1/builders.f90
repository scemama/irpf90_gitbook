subroutine build_t
  use nodes
  implicit none
  t = u1 + v + 4
end subroutine build_t

subroutine build_w
  use nodes
  implicit none
  w = d5+3
end subroutine build_w

subroutine build_v
  use nodes
  implicit none
  v = u2+w+2
end subroutine build_v

subroutine build_u1
  use nodes
  implicit none
  integer, external :: f_u
  u1 = f_u(d1,d2)
end subroutine build_u1

subroutine build_u2
  use nodes
  implicit none
  integer, external :: f_u
  u2 = f_u(d3,d4)
end subroutine build_u2

integer function f_u(x,y)
  implicit none
  integer, intent(in)  :: x,y
  f_u = x+y+1
end

subroutine build_d
  use nodes
  implicit none
  read(*,*) d1, d2, d3, d4, d5
end subroutine build_d
