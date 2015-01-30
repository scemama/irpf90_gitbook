Automatic documentation
-----------------------

Inside each provider, subroutine and function it is recommended to write a few
lines to explain what it does. The documentation is written inside a
``BEGIN_DOC ... END_DOC`` block.

```fortran
BEGIN_PROVIDER [ double precision, fact, (0:fact_max) ]
  implicit none

  BEGIN_DOC
!  Computes an array of fact(n)
  END_DOC

  integer :: i
  fact(0) = 1.d0
  do i=1,fact_max
    fact(i) = fact(i-1)*dble(i)
  end do
END_PROVIDER

```

When ``irpf90`` runs, a warning will be printed if the documentation block is
absent. A file named ``irpf90_entities`` is created, where each line corresponds
to one IRP entity and gives:

* the name of the file in which it is defined
* the Fortran type 
* the name of the IRP entity
* the dimensions if the entity is an array

```
...
SAMPLING/langevin_step.irp.f        : double precision               :: elec_mass
simulation.irp.f                    : real                           :: events_num
simulation.irp.f                    : character*(512)                :: ezfio_filename
TOOLS/quasiMC.irp.f                 : double precision, allocatable  :: halton_base               (3*elec_num)
TOOLS/quasiMC.irp.f                 : double precision, allocatable  :: halton_seed               (3*elec_num)
simulation.irp.f                    : character*(64)                 :: hostname
simulation.irp.f                    : character*(128)                :: http_server
JASTROW/jastrow_full.irp.f          : double precision               :: jast_value                
psi_guide.irp.f                     : double precision               :: psi_g_value_inv           
...
```

This file is very useful for scripting. For instance, 

```
$ # Get the file in which http_server is defined
$ awk '/http_server/ { print $1 }' irpf90_entities
simulation.irp.f
$
$ # Get the names of all double precision IRP entities
$ awk '/double precision  / { print $6 }' irpf90_entities
...
elec_mass
jast_value
psi_g_value_inv
...
```

<---
* irpman
* bash tab completion
--->


