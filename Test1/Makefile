%.o: %.f90
	gfortran -c $*.f90

test: nodes.o test.o builders.o providers.o
	gfortran $^ -o test

