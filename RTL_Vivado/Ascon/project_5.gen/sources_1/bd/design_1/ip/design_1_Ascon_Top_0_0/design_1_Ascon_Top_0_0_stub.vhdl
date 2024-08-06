-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Tue Jul  9 22:28:40 2024
-- Host        : SachinsLatitude running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top design_1_Ascon_Top_0_0 -prefix
--               design_1_Ascon_Top_0_0_ design_1_Ascon_Top_0_0_stub.vhdl
-- Design      : design_1_Ascon_Top_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100ticsg324-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_Ascon_Top_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    start : in STD_LOGIC;
    encryption_done : out STD_LOGIC;
    decryption_done : out STD_LOGIC;
    message_authenticated : out STD_LOGIC
  );

end design_1_Ascon_Top_0_0;

architecture stub of design_1_Ascon_Top_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst,start,encryption_done,decryption_done,message_authenticated";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "Ascon_Top,Vivado 2023.2";
begin
end;
