subroutine provide_t
  use nodes
  implicit none
  if (.not.t_is_built) then
    call provide_u1
    call provide_v
    call build_t(u1,v,t)
    t_is_built = .True.
  endif
end subroutine provide_t

subroutine provide_w
  use nodes
  implicit none
  if (.not. w_is_built) then
    call provide_d
    call build_w(d5,w)
    w_is_built = .True.
  endif
end subroutine provide_w

subroutine provide_v
  use nodes
  implicit none
  if (.not. v_is_built) then
    call provide_u2
    call provide_w
    call build_v(u2,w,v)
    v_is_built = .True.
  endif
end subroutine provide_v

subroutine provide_u1
  use nodes
  implicit none
  if (.not. u1_is_built) then
    call provide_d
    call build_u(d1,d2,u1)
    u1_is_built = .True.
  endif
end subroutine provide_u1

subroutine provide_u2
  use nodes
  implicit none
  if (.not. u2_is_built) then
    call provide_d
    call build_u(d3,d4,u2)
  endif
end subroutine provide_u2

subroutine provide_d
  use nodes
  implicit none
  if (.not. d_is_built) then
    call build_d(d1,d2,d3,d4,d5)
    d_is_built = .True.
  endif
end

