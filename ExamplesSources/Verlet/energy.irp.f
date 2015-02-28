BEGIN_PROVIDER [ double precision, E_tot ]
 implicit none
 BEGIN_DOC
! Total energy of the system
 END_DOC
 E_tot = T + V
END_PROVIDER

