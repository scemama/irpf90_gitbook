* ctags
* vim plugin
* irpf90_indent.py
* irp_here
* Templates
* Embedded shell scripts
* Conditional compilation
* assert
* debug
* memory management
* preprocess
* touch
* unused

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

in this particular example, if ``u2 < u3`` nothing happens. If ``u2 >= u3``, then the program
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

