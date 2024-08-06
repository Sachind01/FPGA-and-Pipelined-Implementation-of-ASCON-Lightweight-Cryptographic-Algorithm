//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Wed Jul 10 12:00:25 2024
//Host        : SachinsLatitude running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk,
    decryption_done,
    encryption_done,
    message_authenticated,
    rst);
  input clk;
  output decryption_done;
  output encryption_done;
  output message_authenticated;
  input rst;

  wire clk;
  wire decryption_done;
  wire encryption_done;
  wire message_authenticated;
  wire rst;

  design_1 design_1_i
       (.clk(clk),
        .decryption_done(decryption_done),
        .encryption_done(encryption_done),
        .message_authenticated(message_authenticated),
        .rst(rst));
endmodule
