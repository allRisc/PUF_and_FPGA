#################################################################################
#===============================================================================#
# Simple SR-Latch Metastability PUF/TRNG
# Copyright (C) 2021  Benjamin Davis
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#===============================================================================#
#################################################################################

#################################################
# Create project
#################################################
proc gen_project {proj_name default_lib force} {
  if {[file exists ./run/$proj_name/$proj_name.xpr] && !$force} {
    puts "Project ${proj_name} already exists. Opening..."
    open_project ./run/$proj_name/$proj_name.xpr
  } else {
    puts "Generating new project..."
    create_project ${proj_name} ./run/${proj_name} -part xc7a100tcsg324-1 -force

    # Set the directory path for the new project
    set proj_dir [get_property directory [current_project]]

    # Set project properties
    set obj [current_project]
    set_property -name "board_part" -value "digilentinc.com:nexys-a7-100t:part0:1.0" -objects $obj
    set_property -name "default_lib" -value $default_lib -objects $obj
    set_property -name "enable_vhdl_2008" -value "1" -objects $obj
    set_property -name "ip_cache_permissions" -value "read write" -objects $obj
    set_property -name "ip_output_repo" -value "$proj_dir/${proj_name}.cache/ip" -objects $obj
    set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
    set_property -name "platform.board_id" -value "nexys-a7-100t" -objects $obj
    set_property -name "sim.central_dir" -value "$proj_dir/${proj_name}.ip_user_files" -objects $obj
    set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
    set_property -name "simulator_language" -value "Mixed" -objects $obj
  }
}

#################################################
# Handle Sources Files
#################################################
proc add_src_files {top_module} {
  # Set Files to be used
  set src_files ""
  if {![catch {glob src/*.sv}  file_list]} { append src_files $file_list } else { puts "INFO: No *.sv  files" }
  if {![catch {glob src/*.v}   file_list]} { append src_files $file_list } else { puts "INFO: No *.v   files" }
  if {![catch {glob src/*.vhd} file_list]} { append src_files $file_list } else { puts "INFO: No *.vhd files" }

  # Create 'sources_1' fileset (if not found)
  if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
  }

  # Set 'sources_1' fileset object
  set obj [get_filesets sources_1]
  add_files -norecurse -fileset $obj $src_files

  # Set 'sources_1' file filetypes
  foreach file_name $src_files {
    set file_name [file normalize $file_name]
    set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file_name"]]
    set file_extension [file extension $file_name]

    if {[string equal $file_extension ".sv"]} {
      set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
    } elseif {[string equal $file_extension ".v"]} {
      set_property -name "file_type" -value "Verilog" -objects $file_obj
    } elseif {[string equal $file_extension ".vhd"]} {
      set_property -name "file_type" -value "VHDL" -objects $file_obj
    } else {
      error "Invalid file extension" "Invalid file extension ($file_extension) for $file_name"
    }
  }

  # Set top-level module for sources
  set obj [get_filesets sources_1]
  set_property -name "top" -value $top_module -objects $obj
}

#################################################
# Handle Constraint Files
#################################################
proc add_constr_files {} {
  # Set Files to be used
  set constr_files ""
  if {![catch {glob constr/*.xdc} file_list]} { append constr_files $file_list } else { puts "INFO: No *.xdc files" }
  if {![catch {glob constr/*.tcl} file_list]} { append constr_files $file_list } else { puts "INFO: No *.tcl files" }


  # Create 'constrs_1' fileset (if not found)
  if {[string equal [get_filesets -quiet constrs_1] ""]} {
    create_fileset -constrset constrs_1
  }

  # Set 'constrs_1' fileset object
  set obj [get_filesets constrs_1]
  add_files -norecurse -fileset $obj $constr_files

  # Set 'constrs_1' file filetypes
  foreach file_name $constr_files {
    set file_name [file normalize $file_name]
    set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file_name"]]
    set file_extension [file extension $file_name]

    if {[string equal $file_extension ".xdc"]} {
      set_property -name "file_type" -value "XDC" -objects $file_obj
    } elseif {[string equal $file_extension ".tcl"]} {
      set_property -name "file_type" -value "TCL" -objects $file_obj
    } else {
      error "Invalid file extension" "Invalid file extension ($file_extension) for $file_name"
    }
  }
}

#################################################
# Handle SIM Files
#################################################
proc add_sim_files {top_sim_module default_lib} {
  # Set Files to be used
  set sim_files ""
  if {![catch {glob sim/*.sv}  file_list]} { append sim_files $file_list } else { puts "INFO: No *.sv  files" }
  if {![catch {glob sim/*.v}   file_list]} { append sim_files $file_list } else { puts "INFO: No *.v   files" }
  if {![catch {glob sim/*.vhd} file_list]} { append sim_files $file_list } else { puts "INFO: No *.vhd files" }

  # Create 'sim_1' fileset (if not found)
  if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
  }

  # Set 'sim_1' fileset object
  set obj [get_filesets sim_1]
  add_files -norecurse -fileset $obj $sim_files

  # Set 'sim_1' file filetypes
  foreach file_name $sim_files {
    set file_name [file normalize $file_name]
    set file_obj [get_files -of_objects [get_filesets sim_1] [list "*$file_name"]]
    set file_extension [file extension $file_name]

    if {[string equal $file_extension ".sv"]} {
      set_property -name "file_type" -value "SystemVerilog" -objects $file_obj
    } elseif {[string equal $file_extension ".v"]} {
      set_property -name "file_type" -value "Verilog" -objects $file_obj
    } else {
      error "Invalid file extension" "Invalid file extension ($file_extension) for $file_name"
    }
  }

  # Set 'sim_1' properties
  set obj [get_filesets sim_1]
  set_property -name "hbs.configure_design_for_hier_access" -value "1" -objects $obj
  set_property -name "top" -value $top_sim_module -objects $obj
  set_property -name "top_lib" -value $default_lib -objects $obj
}

#################################################
# Setup synth_1
#################################################
proc setup_synth {} {
  # Create 'synth_1' run (if not found)
  if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7a100tcsg324-1 -flow {Vivado Synthesis 2020} -strategy "Vivado Synthesis Defaults" -report_strategy {ivado Synthesis Default Reports} -constrset constrs_1
  }

  # set the current synth run
  current_run -synthesis [get_runs synth_1]
}

#################################################
# Setup impl_1
#################################################
proc setup_impl {} {
  # Create 'impl_1' run (if not found)
  if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7a100tcsg324-1 -flow {Vivado Implementation 2020} -strategy "Vivado Implementation Defaults" -report_strategy {Vivado Implementation Default Reports} -constrset constrs_1 -parent_run synth_1
  }

  # set the current impl run
  current_run -implementation [get_runs impl_1]
}