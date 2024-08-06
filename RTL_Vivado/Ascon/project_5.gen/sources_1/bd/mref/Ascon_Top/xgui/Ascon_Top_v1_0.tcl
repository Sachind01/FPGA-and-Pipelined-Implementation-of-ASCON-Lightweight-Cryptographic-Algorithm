# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "FP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "a" -parent ${Page_0}
  ipgui::add_param $IPINST -name "b" -parent ${Page_0}
  ipgui::add_param $IPINST -name "k" -parent ${Page_0}
  ipgui::add_param $IPINST -name "l" -parent ${Page_0}
  ipgui::add_param $IPINST -name "r" -parent ${Page_0}
  ipgui::add_param $IPINST -name "y" -parent ${Page_0}


}

proc update_PARAM_VALUE.FP { PARAM_VALUE.FP } {
	# Procedure called to update FP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FP { PARAM_VALUE.FP } {
	# Procedure called to validate FP
	return true
}

proc update_PARAM_VALUE.a { PARAM_VALUE.a } {
	# Procedure called to update a when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.a { PARAM_VALUE.a } {
	# Procedure called to validate a
	return true
}

proc update_PARAM_VALUE.b { PARAM_VALUE.b } {
	# Procedure called to update b when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.b { PARAM_VALUE.b } {
	# Procedure called to validate b
	return true
}

proc update_PARAM_VALUE.k { PARAM_VALUE.k } {
	# Procedure called to update k when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.k { PARAM_VALUE.k } {
	# Procedure called to validate k
	return true
}

proc update_PARAM_VALUE.l { PARAM_VALUE.l } {
	# Procedure called to update l when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.l { PARAM_VALUE.l } {
	# Procedure called to validate l
	return true
}

proc update_PARAM_VALUE.r { PARAM_VALUE.r } {
	# Procedure called to update r when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.r { PARAM_VALUE.r } {
	# Procedure called to validate r
	return true
}

proc update_PARAM_VALUE.y { PARAM_VALUE.y } {
	# Procedure called to update y when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.y { PARAM_VALUE.y } {
	# Procedure called to validate y
	return true
}


proc update_MODELPARAM_VALUE.k { MODELPARAM_VALUE.k PARAM_VALUE.k } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.k}] ${MODELPARAM_VALUE.k}
}

proc update_MODELPARAM_VALUE.r { MODELPARAM_VALUE.r PARAM_VALUE.r } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.r}] ${MODELPARAM_VALUE.r}
}

proc update_MODELPARAM_VALUE.a { MODELPARAM_VALUE.a PARAM_VALUE.a } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.a}] ${MODELPARAM_VALUE.a}
}

proc update_MODELPARAM_VALUE.b { MODELPARAM_VALUE.b PARAM_VALUE.b } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.b}] ${MODELPARAM_VALUE.b}
}

proc update_MODELPARAM_VALUE.l { MODELPARAM_VALUE.l PARAM_VALUE.l } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.l}] ${MODELPARAM_VALUE.l}
}

proc update_MODELPARAM_VALUE.y { MODELPARAM_VALUE.y PARAM_VALUE.y } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.y}] ${MODELPARAM_VALUE.y}
}

proc update_MODELPARAM_VALUE.FP { MODELPARAM_VALUE.FP PARAM_VALUE.FP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FP}] ${MODELPARAM_VALUE.FP}
}

