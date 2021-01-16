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

source proc/project_misc.tcl
source proc/project_init.tcl
source proc/project_synth.tcl
source proc/project_impl.tcl

##################################################
# Set Project Defaults
##################################################
set proj_name      "SR-Latch_Metastable"
set top_module     "sr_latch_metastable_wrapper"
set origin_dir     "."
set script_file    "project_bld.tcl"
set top_sim_module "sr_latch_metastable_sim"
set default_lib    "xil_defaultlib"

##################################################
# Set Command Settings
##################################################
set force_project_gen 0
set run_synth         0
set run_impl          0
set run_sim           0

handle_arguments

##################################################
# Set Default Command Settings
##################################################
gen_project $proj_name $default_lib $force_project_gen
add_src_files $top_module
add_constr_files
add_sim_files $top_sim_module $default_lib

setup_synth
setup_impl

##################################################
# Perform Sim if appropriate
##################################################
if {$run_sim} {
  puts "WARNING: Project Simulation Not Yet Implemented"
}

##################################################
# Perform Synthesis if appropriate
##################################################
if {$run_synth} {
  proj_synth
}

##################################################
# Perform Synthesis if appropriate
##################################################
if {$run_impl} {
  proj_impl
}