OpenMP
======

OpenMP is straightforward to use with IRPF90 for simple loops. Trouble may
arrive when entities are provided in OpenMP blocks such that two threads may be
providing the same entities simultaneously.

To avoid such situations, an error message is displayed if an entity is not
provided by thread zero. A common solution to this problem is to explicitly
provide the needed entities before entering in the OpenMP section.

Another possibility is to use ``irpf90 --openmp``. In that case, all the
providers become automatically thread-safe using one OpenMP lock per IRP entity.

