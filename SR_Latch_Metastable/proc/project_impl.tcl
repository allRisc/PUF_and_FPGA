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

proc proj_impl {} {
  reset_run impl_1
  launch_runs impl_1 -to_step write_bitstream -jobs 6
  wait_on_run impl_1

  open_run impl_1
  file mkdir ./run/reports
  report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose \
    -max_paths 10 -input_pins -file ./run/reports/impl_timing.rpt
}