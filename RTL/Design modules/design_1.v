//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Wed Jul 10 12:00:25 2024
//Host        : SachinsLatitude running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,da_board_cnt=2,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk,
    decryption_done,
    encryption_done,
    message_authenticated,
    rst);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN design_1_clk_in1_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clk;
  output decryption_done;
  output encryption_done;
  output message_authenticated;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input rst;

  wire Ascon_Top_0_decryption_done;
  wire Ascon_Top_0_encryption_done;
  wire Ascon_Top_0_message_authenticated;
  wire clk_in1_0_1;
  wire clk_wiz_0_clk_out1;
  wire reset_0_1;
  wire [0:0]vio_0_probe_out0;

  assign clk_in1_0_1 = clk;
  assign decryption_done = Ascon_Top_0_decryption_done;
  assign encryption_done = Ascon_Top_0_encryption_done;
  assign message_authenticated = Ascon_Top_0_message_authenticated;
  assign reset_0_1 = rst;
  design_1_Ascon_Top_0_0 Ascon_Top_0
       (.clk(clk_wiz_0_clk_out1),
        .decryption_done(Ascon_Top_0_decryption_done),
        .encryption_done(Ascon_Top_0_encryption_done),
        .message_authenticated(Ascon_Top_0_message_authenticated),
        .rst(reset_0_1),
        .start(vio_0_probe_out0));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .reset(reset_0_1));
  design_1_ila_0_0 ila_0
       (.clk(clk_wiz_0_clk_out1),
        .probe0(vio_0_probe_out0),
        .probe1(Ascon_Top_0_encryption_done),
        .probe2(Ascon_Top_0_decryption_done),
        .probe3(Ascon_Top_0_message_authenticated));
  design_1_vio_0_0 vio_0
       (.clk(clk_wiz_0_clk_out1),
        .probe_in0(Ascon_Top_0_encryption_done),
        .probe_in1(Ascon_Top_0_decryption_done),
        .probe_in2(Ascon_Top_0_message_authenticated),
        .probe_out0(vio_0_probe_out0));
endmodule
