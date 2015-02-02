BEGIN_PROVIDER [ integer, n_images ]
 implicit none
 BEGIN_DOC
 ! Number of co-array images
 END_DOC
 n_images = num_images()
END_PROVIDER

BEGIN_PROVIDER [ integer, image_id ]
 implicit none
 BEGIN_DOC
 ! ID of the current image
 END_DOC
 image_id = this_image()
END_PROVIDER

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

