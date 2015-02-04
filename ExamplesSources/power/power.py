#!/usr/bin/python

POWER_MAX = 20

def compute_x_prod(n,d):
  if n == 0:
    d[0] = None
    return d
  if n == 1:
    d[1] = None
    return d
  if n in d:
    return d
  m = n/2
  d = compute_x_prod(m,d) 
  d[n] = None
  d[2*m] = None
  return d

def print_subroutine(n):
  keys = compute_x_prod(n,{}).keys()
  keys.sort()
  output = []
  print "double precision function power_%d(x1)"%n
  print " double precision, intent(in) :: x1"
  print " BEGIN_DOC"
  print "!  Fast computation of x**%d"%(n)
  print " END_DOC"
  for i in range(1,len(keys)):
     output.append( "x%d"%keys[i] )
  if output != []:
    print " double precision :: "+', '.join(output)
  for i in range(1,len(keys)):
   ki = keys[i]
   ki1 = keys[i-1]
   if ki == 2*ki1:
     print " x%d"%ki + " = x%d * x%d"%(ki1,ki1) 
   else:
     print " x%d"%ki + " = x%d * x1"%(ki1) 
  print " power_%d = x%d"%(n,n)
  print "end"

for i in range(POWER_MAX):
  print_subroutine (i+1)
  print ''


