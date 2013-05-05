#!/bin/bash
#------------------------------------------------------------------------------
#
# Copyright (C) 2001-12 Olivier Girard <olgirard@gmail.com>
# Copyright (C) 2001-12 Mihai M. <mmihai@delajii.net>
# Copyright (C) 2013 Joel Holdsworth <joel@airwebreathe.org.uk>
#
# This source file may be used and distributed without restriction provided
# that this copyright statement is not removed from the file and that any
# derivative work contains the original copyright notice and the associated
# disclaimer.
#
# This source file is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.
#
# This source is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
# License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this source; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
#------------------------------------------------------------------------------

###############################################################################
#                            Parameter Check                                  #
###############################################################################
EXPECTED_ARGS=2
if [ $# -ne $EXPECTED_ARGS ]; then
	echo "ERROR    : wrong number of arguments"
	echo "USAGE    : rtlsim.sh <verilog stimulus file> <submit file>"
	echo "Example  : rtlsim.sh ./stimulus.v            ../src/submit.f"
	echo "FPGALA_SIMULATOR env keeps simulator name iverilog/cver/verilog/ncverilog/vsim/vcs"
	exit 1
fi
 
 
###############################################################################
#                     Check if the required files exist                       #
###############################################################################
 
if [ ! -e $1 ]; then
	echo "Verilog stimulus file $1 doesn't exist"
	exit 1
fi
if [ ! -e $2 ]; then
	echo "Verilog submit file $2 doesn't exist"
	exit 1
fi
 
 
###############################################################################
#                         Start verilog simulation                            #
###############################################################################
 
if [ "${FPGALA_SIMULATOR:-iverilog}" = iverilog ]; then
 
	rm -rf simv
 
	NODUMP=${FPGALA_NODUMP-0}
	if [ $NODUMP -eq 1 ]
	then
		iverilog -o simv -c $2 -D NODUMP
	else
		iverilog -o simv -c $2
	fi

	if [ `uname -o` = "Cygwin" ]
	then
		vvp.exe ./simv
	else
		./simv
	fi

else

	NODUMP=${FPGALA_NODUMP-0}
	if [ $NODUMP -eq 1 ] ; then
		vargs="+define+NODUMP"
	else
		vargs=""
	fi

	case $FPGALA_SIMULATOR in
		cver* )
			vargs="$vargs +define+VXL +define+CVER" ;;
		verilog* )
			vargs="$vargs +define+VXL" ;;
		ncverilog* )
			rm -rf INCA_libs
			vargs="$vargs +access+r +nclicq +ncinput+../bin/cov_ncverilog.tcl -covdut openMSP430 -covfile ../bin/cov_ncverilog.ccf -coverage all +define+TRN_FILE" ;;
		vcs* )
			rm -rf csrc simv*
			vargs="$vargs -R -debug_pp +vcs+lic+wait +v2k +define+VPD_FILE" ;;
		vsim* )
			# Modelsim
			if [ -d work ]; then  vdel -all; fi
				vlib work
				exec vlog +acc=prn -f $2 $vargs -R -c -do "run -all" ;;
		isim )
			# Xilinx simulator
			rm -rf fuse* isim*
			fuse tb_openMSP430 -prj $2 -o isim.exe -i ../../../bench/verilog/ -i ../../../rtl/verilog/ -i ../../../rtl/verilog/periph/
			echo "run all" > isim.tcl
			./isim.exe -tclbatch isim.tcl
			exit
	esac
 
	echo "Running: $FPGALA_SIMULATOR -f $2 $vargs"
	exec $FPGALA_SIMULATOR -f $2 $vargs
fi

