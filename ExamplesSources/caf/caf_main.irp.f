program test
 implicit none
 PROVIDE X
 if (image_id /= 1) then
   return
 endif
 print *, 'This image:'
 print *, X
 print *, 'Image 2:'
 print *, X[2]
end
