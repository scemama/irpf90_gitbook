Profiling
=========

IRPF90 includes a profiler that will measure the number of CPU cycles
spent in all the providers. At the end of the run, it will display for
each entity the total number of cycles, the average number of cycles
(with an error bar), the total time and the average time for each entity.

Here is an example taken from a real application:


```
                         N.Calls       Tot Cycles          Avg Cycles     Tot Secs            Avg Secs
------------------------------------------------------------------------------------------------------
...
ci_energy                     6.     1662765.      277127.+/-  59043.   0.00072451  0.00012+/- 0.00003
coef_hf_selector              7.    13009101.     1858443.+/- 605660.   0.00566841  0.00081+/- 0.00026
davidson_criterion            1.        1736.        1736.+/-      0.   0.00000076  0.00000+/- 0.00000
davidson_sze_max              1.          18.          18.+/-      0.   0.00000001  0.00000+/- 0.00000
det_connections               1.     6945057.     6945057.+/-      0.   0.00302614  0.00303+/- 0.00000
diag_algorithm                6.       15253.        2542.+/-    246.   0.00000665  0.00000+/- 0.00000
do_pt2_end                    1.      233928.      233928.+/-      0.   0.00010193  0.00010+/- 0.00000
elec_alpha_num                1.      751170.      751170.+/-      0.   0.00032730  0.00033+/- 0.00000
exc_degree_per_selectors      7.      209402.       29915.+/-  10827.   0.00009124  0.00001+/- 0.00000
expected_s2                   1.      240961.      240961.+/-      0.   0.00010499  0.00010+/- 0.00000
ezfio_filename                1.      386883.      386883.+/-      0.   0.00016858  0.00017+/- 0.00000
...
```
