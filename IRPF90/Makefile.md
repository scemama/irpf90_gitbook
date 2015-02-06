Makefile configuration
======================

User configuration
------------------

When ``irpf90 --init`` is run, a standard Makefile is created:

``` makefile
IRPF90 = irpf90  #-a -d
FC     = gfortran -ffree-line-length-none
FCFLAGS= -O2

SRC=
OBJ=
LIB=

include irpf90.make

irpf90.make: $(filter-out IRPF90_temp/%, $(wildcard */*.irp.f)) \
             $(wildcard *.irp.f) $(wildcard *.inc.f) Makefile
        $(IRPF90)
```

The ``IRPF90`` variable contains the IRPF90 invocation. All the
options of IRPF90 should be given in this line.

``FC`` describes the Fortran compiler to use. As IRPF90 adds comments at
the end of the lines to express the correspondence between the Fortran
generated files and the IRPF90 source files, the lines are too long for
the default options of ``gfortran``. This explains why the
``-ffree-line-length-none`` is inserted by default. If the Intel Fortran
compiler is used, this option is not necessary. The ``FC`` variable should
contain the invocation of the Fortran compiler which is common to compiling
Fortran files and to link the project. For example, the ``-openmp`` option
of ``ifort`` should be placed on this line as it should be mentioned to
compile the Fortran files, but it is also required at the link stage.

``FCFLAGS`` contains the flags that should be present at compile time but
not at link time. The code optimization options should appear here.

It is possible to add some files to the project that will not be seen by
IRPF90, but that need to be compiled and linked to the project. For example,
a Fortran file containing a "black box" subroutine could be taken from another
project, and your IRPF90 could call this subroutine. To to that, you should
add the name of these Fortran source files to the ``SRC`` variable, and the
name of the corresponding object files to the ``OBJ`` variable. Note that you
can also add some C source files and objects, but then you should add rules
to compile your C files as you would do in any other ``Makefile``.

External libraries may be added to the ``LIB`` variable.

* -I include
* Parallel build

Auto-generated configuration
----------------------------

* library

