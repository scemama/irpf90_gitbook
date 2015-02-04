Automatic documentation
-----------------------

Inside each provider, subroutine and function it is recommended to write a few
lines to explain what it does. The documentation is written inside a
``BEGIN_DOC ... END_DOC`` block.

``` irpf90
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
input.irp.f   : integer                        :: d1                              input.irp.f   : integer                        :: d2
input.irp.f   : integer                        :: d3                              input.irp.f   : integer                        :: d4
input.irp.f   : integer                        :: d5                              fact.irp.f    : double precision, allocatable  :: fact      (0:fact_max)
fact.irp.f    : integer                        :: fact_max
uvwt.irp.f    : integer                        :: t                         
uvwt.irp.f    : integer                        :: u1
uvwt.irp.f    : integer                        :: u2                              uvwt.irp.f    : integer                        :: v
uvwt.irp.f    : integer                        :: w      
```

This file is very useful for scripting. For instance, 

``` bash
$ # Get the file in which fact_max is defined
$ awk '/:: fact_max/ { print $1 }' irpf90_entities
fact.irp.f

$ # Get the names of all double precision IRP entities
$ INTS=$(awk '/integer  / { print $5 }' irpf90_entities)
$ echo $INTS
d1 d2 d3 d4 d5 fact_max t u1 u2 v w
```


Another very useful tool is the ``irpman`` command:

``` bash
$ irpman <irp_entity>
```

This opens a man page for the desired IRP entity containing its description
(given in the ``BEGIN_DOC ... END_DOC`` blocks), the file in which it is defined,
which other entities are needed to build it, and which other entities need the
current entity. It also gives an *Instability factor*, which is an estimate
measure of how dangerous it can be to modify the IRP entity.

Here is the man page displayed for the ``v`` entity:

``` man
IRPF90 entities(l)         v        IRPF90 entities(l)

Declaration
       integer   :: v

Description
       v(x) = x+y+2

File
       uvwt.irp.f

Needs
       u2
       w

Needed by
       t

Instability factor
       25.0 %

IRPF90 entities            v        IRPF90 entities(l)
```


To activate tab completion in Bash, you can source the ``irpman`` exectuable
itself

``` bash
$ source $(which irpman)
```

Now, pressing tab on the command line after irpman gives the list of all IRP
entities:

``` bash
$ irpman <TAB><TAB>
d1            d4            fact_max      irp_example2  u2
d2            d5            fu            t             v
d3            fact          irp_example1  u1            w

$ irpman fa<TAB>
$ irpman fact<TAB><TAB>
fact      fact_max  

```



