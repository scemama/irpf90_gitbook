BEGIN_PROVIDER [ double precision, x ]
  implicit none
  BEGIN_DOC
! Value of x
  END_DOC
  x = 1.2345d0
END_PROVIDER

BEGIN_PROVIDER [ double precision, x_p, (20) ]
  implicit none
  BEGIN_DOC
! array of x**p for 0 < p < 21 with the standard power functions
  END_DOC
  integer :: i
  do i=1,20
    x_p(i) = x**i
  enddo

END_PROVIDER

! Put the power.py script here for better inlining of the functions
BEGIN_SHELL [ /usr/bin/python ]
import power
END_SHELL

BEGIN_PROVIDER [ double precision, x_p_fast, (20) ]
  implicit none
  BEGIN_DOC
! array of x**p for 0 < p < 21 with the fast power functions
  END_DOC
  BEGIN_SHELL [ /bin/bash ]
  for i in {1..20}
  do
    echo "  double precision, external :: power_$i"
    echo "  !DIR$ FORCEINLINE"
    echo "  x_p_fast($i) = power_$i(x)"
  done
  END_SHELL

END_PROVIDER


