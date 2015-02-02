Coarray Fortran support
=======================

When the ``--coarray`` option is given, all the entities are
co-arrays in the [CoArray Fortran (CAF)](http://www.co-array.org/)
language extension, defined as ``[*]``. Therefore, it is possible 
for any process image to access the IRP entities of all the other images.


Let us first create convenient providers to cache the values of the ``num_images``
and ``image_id`` functions that will be called very often.

``` fortran
 BEGIN_PROVIDER [ integer, n_images ]
&BEGIN_PROVIDER [ integer, image_id ]
 implicit none
 BEGIN_DOC
 ! CAF internals
 END_DOC
 n_images = num_images()
 image_id = this_image()
END_PROVIDER
```

Now, we create an array that will be different on each image:

``` fortran
BEGIN_PROVIDER [ real, X, (10) ]
 implicit none
 BEGIN_DOC
 ! X(i) = image_id x i
 END_DOC
 integer  :: i
 do i=1,size(X)
   X(i) = real(image_id * i) 
 enddo
END_PROVIDER
```

In the main program, you will want to print the value of ``X`` of images 1 and 2.
Only the first image will print, so this will imply an ``if`` statement as

``` fortran
if (this_image() == 1) then
  print *, X
endif
```

The problem is that ``X`` will need to be provided *only* if the ``image_id`` is
equal to one. Here, we will have to force to provide ``X``, whatever the value
of ``this_image``.

``` fortran
program caf_test
 implicit none

 PROVIDE X
 if (image_id == 1) then
   print *, 'This image:'
   print *, X
   print *, 'Image 2:'
   print *, X[2]
 endif
end
```


In the ``Makefile``, set

    IRPF90 = irpf90 --coarray 
    FC     = ifort -coarray


Build the program and the output will give:

```
$ ./caf_main 
 This image:
   1.000000       2.000000       3.000000       4.000000       5.000000    
   6.000000       7.000000       8.000000       9.000000       10.00000    
 Image 2:
   2.000000       4.000000       6.000000       8.000000       10.00000    
   12.00000       14.00000       16.00000       18.00000       20.00000   
```

