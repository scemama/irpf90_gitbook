Array alignment
===============

Array alignment is necessary to get performance on x86 architectures.
Indeed, vector instructions (SSE,AVX,AVX-512) require the data to be
aligned on a 16-, 32- or 64-byte boundary. With the Intel compiler,
it is possible to give the compiler a directive to align an array on
a given boundary:

    !DIR$ ATTRIBUTES ALIGN : 32 :: X

Doing this will force the first element of array ``X`` to have an address
which is a multiple of 256 bits. Using aligned arrays for one-dimensional
array will remove the peeling loops produced by the compiler when
producing and auto-vectorized binary.

For two-dimensional arrays, it is possible to have all columns aligned
if the array is aligned and the length of a column is a multiple of the
alignment.

IRPF90 can set the alignment directive for all the IRP entities that are
arrays using a command-line argument:

    irpf90 --align=32

will use a 32 byte alignment for every array entity, but it will also
replace in the code all the ``$IRP_ALIGN`` patterns with ``32``.
In this way, it is possible to make a code which is valid for all
kind of array alignments.

Let's create a function that will calculate the length of the leading
dimension such that it is a multiple of the alignment:

``` fortran
integer function align_double(i)
  implicit none
  integer, intent(in) :: i
  integer             :: j
  j = mod(i,max($IRP_ALIGN,4)/4)
  if (j==0) then
    align_double = i
  else
    align_double = i+4-j
  endif
end
```

We can now create a matrix with all columns aligned, using the
``!DIR$ VECTOR ALIGNED`` directive safely.

``` fortran
 BEGIN_PROVIDER [ integer, n ]
&BEGIN_PROVIDER [ integer, n_aligned ]
  integer :: align_double
  n = 19
  n_aligned = align_double(19)
END_PROVIDER

BEGIN_PROVIDER [ double precision, Matrix, (n_aligned,n) ]
  implcit none
  integer :: i,j
  do j=1,n
   !DIR$ VECTOR ALIGNED
   do i=1,n_aligned
     ! do stuff to create Matrix(i,j)
   enddo  
  enddo  
END_PROVIDER
```


