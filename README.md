IRPF90
======

Today, large scientific codes in Fortran are difficult to maintain. The complexity of the programs comes from the dependencies between the different entities of the code.
As the entities become more and more coupled, the program becomes
more and more difficult to maintain and to debug.

If the programmer wants to keep the code under control, he has to be aware of all the consequences of a modification of the source code on all possible execution paths.
When the code was written by multiple developers and when the code is large (hundred thousands of lines), this becomes extremely difficult for the programmer. However, the machine can
handle easily such a complexity by handling all the dependencies
between the variables, as in a Makefile.

IRPF90 is a Fortran code generator. Schematically, the programmer
only writes computation kernels, and IRPF90 generates the "glue code" that will link all these kernels together to produce the expected result, handling all the relationships between the variables. In this way, even large codes can still be under control.