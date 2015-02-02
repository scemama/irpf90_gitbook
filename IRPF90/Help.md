Helping features
================

Assertions
----------

Assertions are boolean expressions that must be true, to check the runtime behavior of the program.
Assertions can be introduced with ``ASSERT`` keyword:

```fortran

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


```fortran
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


Embedded shell scripts
----------------------

TODO


Conditional compilation
-----------------------

In IRPF90, the C preprocessor can't really be used, as the produced Fortran
files may not have everything in the same order as the ``*.irp.f`` files.
Instead, IRPF90 provides the ``IRP_IF ... IRP_ELSE ... IRP_ENDIF`` keywords to
enable [conditional
compilation](http://en.wikipedia.org/wiki/Conditional_compilation).

``` fortran
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

