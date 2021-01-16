/*********************************************************************************
 * Simple SR-Latch Metastability PUF/TRNG
 * Copyright (C) 2021  Benjamin Davis
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *********************************************************************************/

`timescale 1ns/10ps

module sr_latch_metastable_wrapper (
  input  wire       ref_clk_in,
  output wire [2:0] LED
);

  logic [2:0] cnt;

  assign LED = cnt;

  always_ff @(posedge ref_clk_in) begin
    cnt <= cnt + 1;
  end

endmodule