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

##################################################
# Handle Input Arguments
##################################################
proc handle_arguments {} {
  global script_file
  global origin_dir proj_name top_module default_lib run_synth run_sim run_impl force_project_gen
  if { $::argc > 0 } {
    for {set i 0} {$i < $::argc} {incr i} {
      set option [string trim [lindex $::argv $i]]
      switch -regexp -- $option {
        "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
        "--project_name" { incr i; set proj_name [lindex $::argv $i] }
        "--top_module"   { incr i; set top_module [lindex $::argv $i] }
        "--default_lib"  { incr i; set default_lib [lindex $::argv $i] }
        "--force_proj"   { set force_project_gen 1}
        "--run_synth"    { set run_synth 1 }
        "--run_sim"      { set run_sim   1 }
        "--run_impl"     { set run_impl  1 }
        "--help"         { print_help }
        default {
          if { [regexp {^-} $option] } {
            puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
            return 1
          }
        }
      }
    }
  }
}

##################################################
# Help information for this script
##################################################
proc print_help {} {
  global script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}