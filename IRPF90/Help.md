
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

Integration in Vim
------------------

* ctags
* vim plugin
* irpf90_indent.py

Conditional compilation
-----------------------

Debugging
---------

* irp_here
* debug
* memory management
* preprocess
* touch
* unused
