Helping features
================

Assertions
----------

Assertions are boolean expressions that must be true, to check the runtime behavior of the program.
Assertions can be introduced with ``ASSERT`` keyword:

``` irpf90

BEGIN_PROVIDER [ integer, u2 ]
  call compute_u(d3,d4,u2)
  ASSERT (u2 < d3)
END_PROVIDER
```

In this particular example, if ``u2 < u3`` nothing happens. If ``u2 >= u3``, then the program
fails:

```
Stack trace:            0
-------------------------
provide_t
provide_v
provide_u2
u2
-------------------------
u2: Assert failed:
 file: uvwt.irp.f, line: 23
(u2 < d3)
u2 =            8
d3 =            3

STOP 1
```

Assertions are activated by using ``irpf90 -a``. If the ``-a`` option is not present, all the
assertions are discarded.

Templates
---------

Templates is a very useful feature of many languages. IRPF90 provides a simple way
to write templates to generate similar providers and functions.
The template is defined in the ``BEGIN_TEMPLATE ... END_TEMPLATE`` block.
The first section of the block contains the template code, in which *template variables*
are used prefixed with a dollar sign. 
Then the ``SUBST`` keyword defines the template variables to substitute, and
multiple *substitution definition* lines are given. The substitution definitions
are separated by two semi-colons (``;;``), and within a substitution definition the variable
substitutions are separated by one semi-colon (``;``).


``` irpf90
BEGIN_TEMPLATE

  BEGIN_PROVIDER [ $type , $name ]
   call find_in_input('$name', $name)
  END_PROVIDER 

  logical function $name_is_zero()
    $name_is_zero = ($name == 0)
  end function

SUBST [ type, name ]

  integer    ;   size_tab1 ;;
  integer    ;   size_tab2 ;;
  real       ;   distance  ;;
  real       ;   x         ;;
  real       ;   y         ;;
  real       ;   z         ;;

END_TEMPLATE

```

In this example, ``type`` and ``name`` are the template variables, referenced
as ``$type`` and ``$name`` in the first block. Six providers and functions will
be generated : 

* replacing ``$type`` with ``integer`` and ``name`` with ``size_tab1``
* replacing ``$type`` with ``integer`` and ``name`` with ``size_tab2``
* replacing ``$type`` with ``real`` and ``name`` with ``distance``
* replacing ``$type`` with ``real`` and ``name`` with ``x``
* replacing ``$type`` with ``real`` and ``name`` with ``y``
* replacing ``$type`` with ``real`` and ``name`` with ``z``

Augmented assignment operators
------------------------------

These patterns are very frequent in scientific applications:

* ``a = a + b``
* ``a = a * b``

If ``a`` has a very explicit name, this pattern can give:
``` fortran
my_very_explicit_name(dim1,dim2,dim3) =  my_very_explicit_name(dim1,dim2,dim3) & 
  + b*c - d
```

Such constructs are not optimal:

* The name of the variable is long, so the line has to be split and the code is
  less readable
* The programmer is likely to make a typo by typing twice a very long variable name. This
  is likely to be caught by the compiler.
* When the programmer modifies a dimension in the left member, he has to modify it
  accordingly in the right member. Such errors will not be caught by the compiler.

Augmented assignment operators cure these problems by allowing the programmer to write:

```irpf90
my_very_explicit_name(dim1,dim2,dim3) +=  b*c - d
```

IRPF90 introduces three operators: ``+=``, ``-=``, and ``*=``. Divisions could not be
added since ``/=`` already means "not equal". To divide using an augmented
assignment operator, ``*= 1. /`` can be used to multiply by the inverse.

Embedded shell scripts
----------------------

When a programmer writes code, the input comes from the keyboard. With IRPF90
it is possible to define sections where the input is not the keyboard but it
comes from the output of script that will be executed at compile time. This
is achieved with ``BEGIN_SHELL ... END_SHELL`` blocks. Any scripting language
can be used.

This example will use Bash to generate code that will print the date
when the program was compiled:

``` irpf90
program test
  BEGIN_SHELL [ /bin/bash ]
cat << EOF | sed 's/\(.*\)/echo "\1\"/g'
    print *, 'Compiled by `whoami` on `date`'
    print *, '$PWD'
    print *, '$(hostname)'
EOF
  END_SHELL
end
```

```
$ ./test
 Compiled by scemama on Wed Feb 4 22:27:46 CET 2015
 /tmp/irpf90_test
 laptop
```

Another example generates 100 functions with Python:

``` python
BEGIN_SHELL [ /usr/bin/python ]
for i in range(100):
    print """
       double precision function times_%d(x)
         double precision, intent(in) :: x
         times_%d = x*%d
       end
    """%locals()
END_SHELL
```

Conditional compilation
-----------------------

In IRPF90, the C preprocessor can't really be used, as the produced Fortran
files may not have everything in the same order as the ``*.irp.f`` files.
Instead, IRPF90 provides the ``IRP_IF ... IRP_ELSE ... IRP_ENDIF`` keywords to
enable [conditional
compilation](http://en.wikipedia.org/wiki/Conditional_compilation).

``` irpf90
IRP_IF new_feature

  print *, 'New feature'
  call new_feature()

IRP_ELSE

  print *, 'Old feature'
  call old_feature()

IRP_ENDIF
```

To generate the program with the old feature, just run ``irpf90`` as usual.
If you want to activate the new feature instead, use ``irpf90 -Dnew_feature``.
Multiple ``-D`` options can be given in the command line


Integration in Vim
------------------

When running ``irpf90``, two files are created for the interaction with
``vim``:

* the ``$HOME/.vim/syntax/irpf90.vim`` file
* a ``tags`` file in the current directory

The first file is a syntax file for syntax highlighting. It extends the 
standard Fortran file to color the additional keywords of IRPF90.
It also adds two features : hitting ``K`` when the cursor is on the
name of an IRP entity displays its man page, and hitting ``=`` on
a group lines selected with ``<Shift>-V`` auto-indents the code.
However, auto-indentation is to be used outside of ``BEGIN_SHELL ... END_SHELL``
blocks, especially for embedded Python scripts.

The ``tags`` file is similar to the file created with the ``ctags`` utility
when programming in C. The presence of this file allows ``vim`` to jump
automatically on the definitions of providers, functions and subroutines.
For instance, inside ``vim``, ``:tag u1`` jumps to the provider of ``u1``.
Another option is to place your cursor on an IRP entity somewhere where it
is used and hit ``<CTRL>-]`` to jump on its definition. To come back where
you were, hit ``<CTRL>-T``.

