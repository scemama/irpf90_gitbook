Introspection
=============

``` irpf90
program get_doc

 integer :: iargc
 character*(32) :: arg
 integer :: i, j

 !----------
 ! Command : ./get_doc
 ! Prints the list of IRP entites
 !----------
 if (iargc() == 0) then
  print *, 'List of IRP entities'
  do j=1,size(entities)
   print *, entities(j)
  enddo
  return
 endif

 !----------
 ! Command : ./get_doc  titi  toto  momo
 ! Prints the documentation of IRP entities titi, toto and momo
 !----------
 do i=1,iargc()
   call getarg(i,arg)

!----------
! Python script executed at compile time that will find the name of all the
! IRP entities of the current program. If the name of an entity is in the 
! command line, its documentation will be printed.
!----------

BEGIN_SHELL [ /usr/bin/python ]
import os
entities = []
for filename in os.listdir('.'):   # Loop over all file names
  if filename.endswith('.irp.f'):  #  If the name ends with .irp.f
    file = open(filename,'r')      #   we open it
    for line in file:              #   For each of its lines
      if line.strip().lower().startswith('begin_provider'):
                                   #    If the line starts with
                                   #     begin_provider (case insensitive)
        name = line.split(',')[1].split(']')[0].strip()
                                   #    The line is split to extract the name
                                   #     of the IRP entity
        entities.append(name)      #    And it is added to the 'entities' list
    file.close()                   #   We close the file

for e in entities:
  print "  if (arg == '%s') then"%(e,)
  print "    print *, %s_doc"%(e,)
  print "  endif"
END_SHELL
 enddo
end

!---------------
! Script that creates the providers.
!---------------

BEGIN_SHELL [ /usr/bin/python ]

import os
doc = {}
for filename in os.listdir('.'):   
  if filename.endswith('.irp.f'):  
    file = open(filename,'r')      
    inside_doc = False             
    for line in file:              
      if line.strip().lower().startswith('begin_provider'):

        name = line.split(',')[1].split(']')[0].strip()

        doc[name] = ""            
      elif line.strip().lower().startswith('begin_doc'):

        inside_doc = True      
      elif line.strip().lower().startswith('end_doc'):

        inside_doc = False       
      elif inside_doc:          
        doc[name] += line[1:].strip()+" "

    file.close()             

lenmax = 0
for e in doc.keys():
  lenmax = max(len(e),lenmax)

# We create here the provider of 'entities' which is the array of
# all the entities
# ----------------------------------------------------------------
print "BEGIN_PROVIDER [ character*(%d), entities, (%d) ]"%(lenmax,len(doc))
print " BEGIN_DOC"
print "! List of IRP entities"
print " END_DOC"
for i,e in enumerate(doc.keys()):
  print "entities(%d) = '%s'"%(i+1, e)
print "END_PROVIDER"

# We create the providers of each entity
# --------------------------------------
for e in doc.keys():
  print "BEGIN_PROVIDER [ character*(%d), %s_doc ]"%(len(doc[e]),e)
  print " BEGIN_DOC"
  print "! Documentation of variable %s"%(e,)
  print " END_DOC"
  print " %s_doc = '%s'"%(e,doc[e])
  print "END_PROVIDER"

END_SHELL
```

