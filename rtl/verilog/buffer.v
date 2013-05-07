//------------------------------------------------------------------------------
//
// Copyright (C) 2013 Joel Holdsworth
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or (at
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

module buffer(clk, rst, in, out);
parameter width=16;
input clk, rst;
input [width-1:0] in;
output [width-1:0] out;
reg [width-1:0] out;

always @ (posedge clk)
	if(!rst)
		out <= {(width-1){1'b0}};
	else
		out <= in;

endmodule
