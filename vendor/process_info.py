# -*- coding: utf-8 -*- 
import argparse
from argparse import RawTextHelpFormatter
from subprocess import check_output, STDOUT, CalledProcessError
from subprocess import call
import sys
import json
import os

parser = argparse.ArgumentParser(description='Process information tool', formatter_class=RawTextHelpFormatter)
parser.add_argument('process', metavar='N', type=str,
                    help='a process name for the info')
parser.add_argument('port', metavar='N', type=str,
                    help='port for check')
parser.add_argument("-j", "--json", help="Redirect output to JSON",
                    action="store_true")

args = parser.parse_args()

class Process:
   'Common base class for all processes'
   def __init__(self, name, pid, path, cmd, cpuload, ramload, hostname, diskusage):
      self.name = name
      self.pid = pid
      self.path = path
      self.cmd = cmd
      self.cpuload = cpuload, '%'
      self.ramload = ramload
      self.hostname = hostname
      self.diskusage = diskusage

   def printProcess(self):
      print "Name: ", self.name,  "\nPID: ", self.pid, "\nPath: ", self.path, "\nCommand: ", self.cmd, "\n----------\nSystem Info\n", "\nCPU Load: ", self.cpuload, "\nRAM Load: ", self.ramload, "\nDisk usage: ", self.diskusage, "\nHostname: ", self.hostname, "\n"

   def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, 
            sort_keys=True, indent=4)
#using path variable as a output storage
p = Process(args.process, "undefined", "undefined", "undefined", "undefined", "undefined", "undefined", "undefined")

#get process name and path
try:
	call('whereis %s' %p.name, shell=True, stdout=open(os.devnull, 'wb'))
except OSError:
	print "There is no programm named %s" % p.name
	sys.exit()
except ValueError:
	print "Invalid arguments"
	sys.exit()

path = check_output('whereis %s' %p.name, shell=True).split()
if len(path) > 1:
	p.path = ' '.join([x for x in path[1:]])
else:
	p.path = "Can't find binary of %s" %p.name

if len(path) > 1:
	try:
		diskusage = 0;
		dirs = p.path.split(' ')
		for x in dirs:
			tmp = (check_output('du -s %s' % x, shell=True)).split()
			diskusage += int(tmp[0])
			p.diskusage = ' '.join((str(diskusage), 'MB'))
	except CalledProcessError as ex:
		o = ex.output
		print "\nSomething gone wrong when calculating disk space for %s\n" % p.name
		returncode = ex.returncode
		if returncode != 1:
			raise
		sys.exit()
	except OSError:
			print "No such file or directory"
			sys.exit()

#get process pid, command and hostname
try:
    path = check_output('ps -fC %s' %p.name, shell=True).split('\n')
    returncode = 0
except CalledProcessError as ex:
    o = ex.output
    print "\nThere is no process named %s\n" % p.name
    returncode = ex.returncode
    if returncode != 1:
        raise
    sys.exit()
path = path[1].split()
p.hostname = path[0]
p.pid = path[1]
p.cmd = ' '.join([x for x in path[7:]]).decode('utf-8')

#get process cpu and ram load
try:
	path = check_output('ps -p %s -o %%cpu,rss' % p.pid, shell=True).split('\n')
except CalledProcessError as ex:
	o = ex.output
	print "\nThere is no process named %s\n" % p.name
	returncode = ex.returncode
	if returncode != 1:
		raise
	sys.exit()

path = path[1].split()
p.cpuload = ' '.join((path[0], '%'))
p.ramload = ' '.join((path[1], 'MB'))

try:
    bin_path = sys.executable
    path = check_output('/usr/sbin/lsof -i :%s' % args.port, shell=True)
    if p.name in path: 
   		path = "\nPort %s is used by %s\n" % (args.port, p.name) 
    returncode = 0
except CalledProcessError as ex:
    o = ex.output
    path = "\nNo processes on %s port" % args.port
    returncode = ex.returncode
    if returncode != 1:
        raise
print path

if args.json:
	with open('process_%s.json' %p.name, 'w') as outfile:
		outfile.write(p.toJSON())
else:
	p.printProcess()
