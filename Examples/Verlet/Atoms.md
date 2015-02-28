Describing the atoms
--------------------

### Exercise

In the same directory, create a program which reads in the standard input:

- The number of atoms
- For each atom: the mass and the *x*, *y*, *z* coordinates

The program will the print the matrix of the distances between atom pairs.

You will have to create :

- A provider for ``Natoms``, the number of atoms
- A provider for ``coord`` and ``mass``, the atom coordinates and mass. These
  are arrays with dimensions ``(3,Natoms)`` and ``(Natoms)`` respectively.
- A provider for ``distance``, the distance matrix. Its dimension is
  ``(Natoms,Natoms)``.

You can check that your code is well documented using the ``irpman`` command:

``` text
$ irpman coord
IRPF90 entities(l)                   coord                   IRPF90 entities(l)

Declaration
       double precision, allocatable :: coord  (3,Natoms)
       double precision, allocatable :: mass   (Natoms)

Description
       Atomic data, input in atomic units.

File
       atoms.irp.f

Needs
       natoms

Needed by
       distance

Instability factor
        50.0 %

IRPF90 entities                      coord                   IRPF90 entities(l)
```

### Expected output

``` shell
$ ./test2 
           0 : -> provide_distance
           0 :  -> provide_natoms
           0 :   -> natoms
 Number of atoms?
3
           0 :   <- natoms  1.59999999999999986E-004
           0 :  <- provide_natoms  3.38000000000000193E-004
           0 :  -> provide_coord
           0 :   -> coord
 For each atom: x, y, z, mass?
0. 0. 0. 40.
1. 2. 3. 10.
-1. 0. 2. 20.
           0 :   <- coord  2.03999999999999754E-004
           0 :  <- provide_coord  3.09999999999999946E-004
           0 :  -> distance
           0 :  <- distance  1.99999999999983177E-006
           0 : <- provide_distance  7.83999999999999975E-004
           0 : -> test2
   0.0000000000000000        3.7416573867739413        2.2360679774997898     
   3.7416573867739413        0.0000000000000000        3.0000000000000000     
   2.2360679774997898        3.0000000000000000        0.0000000000000000     
           0 : <- test2  5.90000000000000246E-005
```

### Solution

File ``test2.irp.f``
``` irpf90
program test2
  implicit none
  BEGIN_DOC
  ! Second test : distance matrix
  END_DOC
  integer                        :: i
  do i=1,Natoms
    print *, distance(1:3,i)
  enddo
end program
```

File ``atoms.irp.f``
``` irpf90
BEGIN_PROVIDER [ integer, Natoms ]
  implicit none
  BEGIN_DOC
  ! Number of atoms
  END_DOC
  print *, 'Number of atoms?'
  read(*,*) Natoms
  ASSERT (Natoms > 0)
END_PROVIDER

 BEGIN_PROVIDER [ double precision, coord, (3,Natoms) ]
&BEGIN_PROVIDER [ double precision, mass , (Natoms)   ]
  implicit none
  BEGIN_DOC
  ! Atomic data, input in atomic units.
  END_DOC
  print *, 'For each atom: x, y, z, mass?'
  integer                        :: i,j  ! <-- Variables can be declared
                                         !     anywhere
  do i=1,Natoms
    read(*,*) (coord(j,i), j=1,3), mass(i)
    ASSERT (mass(i) > 0.d0)
  enddo
END_PROVIDER

BEGIN_PROVIDER [ double precision, distance, (Natoms,Natoms) ]
  implicit none
  BEGIN_DOC
  ! distance : Distance matrix 
  END_DOC
  integer                        :: i,j,k
  do i=1,Natoms
    do j=1,Natoms
      distance(j,i) = 0.d0
      do k=1,3
        distance(j,i) += (coord(k,i)-coord(k,j))**2  ! <-- Note the increment
                                                     !     operator +=
      enddo
      distance(j,i) = dsqrt(distance(j,i))
    enddo
  enddo
END_PROVIDER
```

