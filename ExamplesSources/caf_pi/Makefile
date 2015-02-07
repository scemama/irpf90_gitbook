IRPF90 = irpf90 --coarray 
FC     = ifort  -coarray
FCFLAGS= -O2 -xHost

SRC=
OBJ=
LIB=

include irpf90.make

irpf90.make: $(filter-out IRPF90_temp/%, $(wildcard */*.irp.f)) $(wildcard *.irp.f) $(wildcard *.inc.f) Makefile 
	$(IRPF90)
