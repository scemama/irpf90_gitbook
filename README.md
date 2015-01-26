IRPF90
======

IRPF90 is a Fortran code generator. Schematically, the programmer only writes
computation kernels, and IRPF90 generates the "glue code" that will link all
these kernels together to produce the expected result, handling all the
relationships between the variables. In this way, even large codes can still be
under control.
