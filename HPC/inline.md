Inlining providers
------------------

For each IRP entity, a provider and a builder function are created.
The provider always calls the builder. The ``--inline builders``
forces to inline the builders in the providers.

When an IRP entity ``A`` is used, the following code is generated

``` fortran
  if (.not.a_is_built) then
    call provide_a
  endif
```

If the ``--inline providers`` option is present, there will be a directive
in the generated Fortran code to force the inlining of the ``call provide``
statement.

To inline both providers and builders, use ``ifpr90 --inline all``.

