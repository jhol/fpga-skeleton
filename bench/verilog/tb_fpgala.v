//------------------------------------------------------------------------------
//
// Copyright (C) 2013 Joel Holdsworth
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
//
//------------------------------------------------------------------------------

`include "timescale.v"

module tb_fpgala;
reg clk, reset;
wire [15:0] sample;
reg [15:0] pins;

buffer frontend (
	.clk (clk),
	.rst (reset),
	.in (pins),
	.out (sample)
);

initial begin
	clk = 0;
	reset = 0;
	pins = 0;
end

always begin
	#1 pins = pins + 1;
	clk = !clk;
end

initial begin
	$dumpfile ("test.vcd");
	$dumpvars;
end

initial
	#100 $finish;

endmodule
