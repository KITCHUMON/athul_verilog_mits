/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_ha (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

 // Assign the output enable signals
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Selecting the operation based on ui_in[6:7]
  wire [1:0] sel = ui_in[6:7];
  wire [2:0] A = ui_in[2:0];
  wire [2:0] B = ui_in[5:3];

  reg [7:0] alu_result;

  always @(*) begin
    case (sel)
      2'b00: alu_result = A + B;        // Addition
      2'b01: alu_result = A - B;        // Subtraction
      2'b10: alu_result = A * B;        // Multiplication
      2'b11: alu_result = (B != 0) ? (A / B) : 8'hFF; // Division with check for division by zero
      default: alu_result = 8'h00;      // Default case (shouldn't happen)
    endcase
  end

  // Assign the ALU result to the output
  assign uo_out = alu_result;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
