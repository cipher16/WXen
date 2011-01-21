#!/usr/bin/python
import libvirt
import sys

conn = libvirt.openReadOnly(None)
if conn == None:
    print 'Failed to open connection to the hypervisor'
    sys.exit(1)


#get active machine
listVM = conn.listDomainsID()
for id in listVM:
	vm=conn.lookupByID(id)	
	print vm.name()+" "+str(id)+" "+str(vm.info()[0])

#get Inactive machine
listINVM = conn.listDefinedDomains()
for name in listINVM:
	vm=conn.lookupByName(name)
	print name+" "+str(vm.ID())+" "+str(vm.info()[0])
sys.exit(0)
