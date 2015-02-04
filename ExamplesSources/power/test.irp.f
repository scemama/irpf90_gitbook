program test
  integer :: i
  do i=1,20
    print *,  i, x_p(i), x_p_fast(i)
  enddo
end

