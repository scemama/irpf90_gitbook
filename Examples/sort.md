Templated sort routine
=======================

This example generates 4 routines with the exact same algorithm.

* ``insertion_sort`` for ``real`` arrays
* ``insertion_dsort`` for ``double precision`` arrays
* ``insertion_isort`` for ``integer`` arrays
* ``insertion_i8sort`` for ``integer*8`` arrays


``` irpf90
BEGIN_TEMPLATE

 subroutine insertion_$Xsort (x,iorder,isize)
  implicit none
  $type,intent(inout)    :: x(isize)
  integer,intent(inout)  :: iorder(isize)
  integer,intent(in)     :: isize
  $type                  :: xtmp
  integer                :: i, i0, j, jmax

  do i=1,isize
   xtmp = x(i)
   i0 = iorder(i)
   j = i-1
   do j=i-1,1,-1
    if ( x(j) > xtmp ) then
     x(j+1) = x(j)
     iorder(j+1) = iorder(j)
    else
     exit
    endif
   enddo
   x(j+1) = xtmp
   iorder(j+1) = i0
  enddo

 end

SUBST [ X, type ]

    ; real ;;
 d  ; double precision ;;
 i  ; integer ;;
 i8 ; integer*8 ;;
 i2 ; integer*2 ;;

END_TEMPLATE
```
