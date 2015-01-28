```

../bin/irpf90 - IRPF90 Fortran preprocessor.

Usage:
  ../bin/irpf90 [OPTION]

Options:

-C, --coarray             All providers are coarrays

-D, --define              Defines a variable identified by the 
                          IRP_IF statements.

-I, --include             Include directory

-a, --assert              Activates ASSERT statements. If absent, 
                          remove ASSERT statements.

-c, --codelet             entity:NMAX or entity:precondition:NMAX 
                           : Generate a codelet to profile a 
                          provider running NMAX times

-d, --debug               Activates debug. The name of the 
                          current subroutine/function/provider 
                          will be printed on the standard output 
                          when entering or exiting a routine, as 
                          well as the CPU time passed inside the 
                          routine.

-g, --profile             Activates profiling of the code.

-h, --help                Print this help

-i, --init                Initialize current directory. Creates a 
                          default Makefile and the temporary 
                          working directories.

-l, --align               Align arrays using compiler directives 
                          and sets the $IRP_ALIGN variable. For 
                          example, --align=32 aligns all arrays 
                          on a 32 byte boundary.

-m, --memory              Print memory allocations/deallocations.

-n, --inline              all|providers|builders : Force inlining 
                          of providers or builders

-o, --checkopt            Shows where optimization may be required

-p, --preprocess          Prints a preprocessed file to standard 
                          output. Useful for  debugging files 
                          containing shell scripts.

-r, --no_directives       Ignore all compiler directives !DEC$ 
                          and !DIR$

-s, --substitute          Substitute values in do loops for 
                          generating specific optimized code.

-t, --touch               Display which entities are touched when 
                          touching the variable given as an 
                          argument.

-u, --unused              Print unused providers

-v, --version             Prints version of irpf90

-z, --openmp              Activate for OpenMP code


Version :  1.4.3

```
