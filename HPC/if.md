Optimizing branches
===================

IRPF90 tries to provide the entities as soon as possible to avoid
putting unnecessary ``if`` statements inside the loops. 

When a branch occurs with an ``if`` condition,
if an entity is needed in *all* the branches it can safely be provided
before the ``if`` statement.
This IRPF90 code

``` fortran
if (condition) then
  print *, 'True', A
else
  print *, 'False', A
endif
```

generates the Fortran code

``` fortran
if (.not. a_is_built) then
  call provide_a
endif
...
if (condition) then
  print *, 'True', A
else
  print *, 'False', A
endif
```

If the IRP entity is not needed in all branches, it will be provided only inside
those branches. The IRPF90 code
``` fortran
if (condition) then
  print *, 'True'
else
  print *, 'False', A
endif
```

generates the Fortran code

``` fortran

if (condition) then
  print *, 'True'
else
  if (.not. a_is_built) then
    call provide_a
  endif
  print *, 'False', A
endif
```

This can be avoided by using the ``PROVIDE`` statement before entering in the ``if`` statement.
``` fortran
PROVIDE A
if (condition) then
  print *, 'True'
else
  print *, 'False', A
endif
```

generates the Fortran code

``` fortran
if (.not. a_is_built) then
  call provide_a
endif
...
! PROVIDE A
if (condition) then
  print *, 'True'
else
  print *, 'False', A
endif
```

This behavior can generate inefficient code if there is an ``if`` statement
inside a loop with some entities provided not in all the branches. A command-line
option ``--checkopt`` will check where there are entities provided inside loops,
and print messages as:

```
Optimization: test.irp.f line 16
  PROVIDE a
```


