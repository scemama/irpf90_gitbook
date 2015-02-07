program test_caf
  implicit none
  BEGIN_DOC
! Test the single core program
  END_DOC

  integer          :: i,j
  double precision :: pi_sum, pi_sum2, n
  double precision :: pi_average, pi_variance, pi_error
  double precision, allocatable :: pi_block_local(:)

  allocate (pi_block_local(num_images()))

  call init_seed(11*this_image())

  pi_sum  = 0.d0
  pi_sum2 = 0.d0
  n = 0.d0
  do i=1,N_blocks
    PROVIDE pi_block
    do j=1,num_images()
      pi_block_local(j) = pi_block[j]
    enddo
    SYNC ALL
    if (this_image() == 1) then
      do j=1,num_images()
        n += 1.d0
        pi_sum  += pi_block_local(j)
        pi_sum2 += pi_block_local(j)*pi_block_local(j)
      enddo
      pi_average = pi_sum / n
      pi_variance = pi_sum2/n - pi_average**2
      pi_error = sqrt(pi_variance/(n-1.d0))
      print *,  pi_average, '+/-', pi_error
    endif
    FREE pi_block
  enddo

  deallocate(pi_block_local)
end
