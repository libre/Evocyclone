#!/bin/bash
#
#    Program : Motor Drive Service
#            : RESISTANCECOVID.COM 
#            : https://github.com/libre/resistancecovid/evocyclo/
#     Author : Deraoui Said     <said.deraoui@gmail.com>
#    Purpose :
# Parameters : --help
#            : --version
#         
#      Notes : See --help for details
#============:==============================================================

if [ -z $1 ] ; then
	echo "ERROR:IP"
	exit 1
fi 

if [ -z $2 ] ; then
	echo "ERROR:PORT"
	exit 1
fi 
sleep 1 ; echo R | nc $1 $2
exit 0