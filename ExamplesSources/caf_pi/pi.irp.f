BEGIN_PROVIDER [ integer*8, N_steps ]
 implicit none
 BEGIN_DOC
 ! Total number of MC steps 
 END_DOC
 N_steps = 10000000_8
END_PROVIDER

BEGIN_PROVIDER [ integer, N_blocks ]
 implicit none
 BEGIN_DOC
 ! Total number of blocks, each containing N_steps steps.
 END_DOC
 N_blocks = 100
END_PROVIDER

subroutine init_seed(i)
  implicit none
  integer, intent(in) :: i
  BEGIN_DOC
! Initializes the random seed with the current this_image()
  END_DOC
  integer :: seed(12)
  seed(:) = i
  call random_seed(put=seed)
end

BEGIN_PROVIDER [ double precision, pi_block ]
 implicit none
 BEGIN_DOC
 ! Value of pi computed over N_steps
 END_DOC

 integer                        :: i_step
 integer*8                      :: count_in
 double precision               :: x,y

 count_in = 0_8

 do i_step=1,N_steps
   call random_number(x)
   call random_number(y)
   if ( (x*x + y*y) <= 1.d0) then
     count_in += 1_8
   endif
 enddo
 pi_block = 4.d0*dble(count_in)/dble(N_steps)

END_PROVIDER


