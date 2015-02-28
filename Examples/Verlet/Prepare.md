Prepare the working environment
-------------------------------

Create a new directory for the project. Inside this directory, initialize the
IRPF90 environment using:

``` shell
$ irpf90 --init
```

Two directories were created

``` shell
$ ls
IRPF90_man  IRPF90_temp  Makefile
```

and a Makefile containing default parameters for the gfortran compiler

``` makefile
IRPF90 = irpf90  #-a -d
FC     = gfortran
FCFLAGS= -O2 -ffree-line-length-none

SRC=
OBJ=
LIB=

include irpf90.make

irpf90.make: $(filter-out IRPF90_temp/%, $(wildcard */*.irp.f)) $(wildcard *.irp.f) $(wildcard *.inc.f) Makefile
        $(IRPF90)
```

In the Makefile, activate the asserts and the debug options by uncommenting ``-a``
and ``-d`` in the definition of the ``IRPF90`` variable.


