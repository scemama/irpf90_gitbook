program test_mono
  implicit none
  BEGIN_DOC
! Test the single core program
  END_DOC
  integer          :: i
  double precision :: pi_sum, pi_sum2, n
  double precision :: pi_average, pi_variance, pi_error

  call init_seed(1)

  pi_sum  = 0.d0
  pi_sum2 = 0.d0
  n = 0.d0
  do i=1,N_blocks
    PROVIDE pi_block
    n += 1.d0
    pi_sum  += pi_block
    pi_sum2 += pi_block*pi_block
    pi_average = pi_sum / n
    pi_variance = pi_sum2/n - pi_average**2 
    pi_error = sqrt(pi_variance/(n-1.d0))
    print *,  pi_average, '+/-', pi_error
    FREE pi_block
  enddo
end
