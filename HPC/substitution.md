Variable substitution
---------------------

It is possible to create a binary executable specifically tuned for one input
file.  The option ``--substitute`` replaces the variables present in loop
ranges and ``if`` conditions by those given in the command line. Doing this
gives much more information to the Fortran compiler and typically up 5-10% of
performance can be gained with such a strategy.

For example, consider this piece of code:

``` irpf90
if (choice1) then
  !DIR$ VECTOR ALIGNED
  do i=1,lmax
    call do_stuff
  enddo
else
  !DIR$ VECTOR ALIGNED
  do i=1,nmax
    call do_something_else
  enddo
endif
```

We can replace the variables ``lmax``, ``nmax`` and ``choice1`` by their input
value using

``` shell
$ irpf90 -s lmax:100 -s nmax:48 -s choice1:.True.
```

This will generate the following fortran code:

``` fortran
if (.True.) then
  !DIR$ VECTOR ALIGNED
  do i=1,100
    call do_stuff
  enddo
else
  !DIR$ VECTOR ALIGNED
  do i=1,48
    call do_something_else
  enddo
endif
```

The ``if (.True.)`` statement can be interperted by the Fortran compiler. It will
then remove the ``else`` branch that will never be taken, and remove the ``if``
test. For the loop which will run, the compiler knows exactly how many loop cycles
will be performed, and it can take the right decisions for loop unrolling and
vectorization strategies.

