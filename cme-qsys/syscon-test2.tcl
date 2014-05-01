# A Tcl script for the Qsys system console

# Start Qsys, open your soc_system.qsys file, run File->System Console,
# then execute this script by selecting it with Ctrl-E

# The System Console is described in Chapter 10 of Volume III of
# the Quartus II Handbook

# Alternately,
# system-console --project_dir=. --script=syscon-test.tcl
#
# system-console --project_dir=. -cli
#   and then "source syscon-test.tcl"

# Base addresses of the peripherals: take from Qsys
set vga_led 0x0

puts "Started system-console-test-script"

# Using the JTAG chain, check the clock and reset"

set j [lindex [get_service_paths jtag_debug] 0]
open_service jtag_debug $j
puts "Opened jtag_debug"

puts "Checking the JTAG chain loopback: [jtag_debug_loop $j {1 2 3 4 5 6}]"
jtag_debug_reset_system $j

puts -nonewline "Sampling the clock: "
foreach i {1 1 1 1 1 1 1 1 1 1 1 1} {
    puts -nonewline [jtag_debug_sample_clock $j]
}
puts ""

puts "Checking reset state: [jtag_debug_sample_reset $j]"

close_service jtag_debug $j
puts "Closed jtag_debug"

# Perform bus reads and writes

set m [lindex [get_service_paths master] 0]
open_service master $m
puts "Opened master"

# Write a test pattern to the various registers
#foreach { r v } {0 0xff 1 0x1 2 0x2 3 0x4 4 0x8 5 0x10 6 0x20 7 0x40} {
foreach { r v } { 
0 96 
2 10 
4 15 
6 -5 
8 0 
10 0 
12 0 
14 0 
16 0 
18 3 
20 1 
22 5 
24 0 
26 0 
28 0 
30 0 
32 0 
34 2 
36 4 
38 6 
40 50 
42 60 
44 70 
46 80 
48 90 
50 100 
52 100 
54 110 
56 120} {
        master_write_16 $m [expr $vga_led + $r] $v
        puts $v 
}
puts "read finished -sleep start"
#after 5000
puts "woken up - read start"
foreach { i } { 0 } {
	puts $i
	puts [ master_read_16 $m [expr $vga_led + $i ] 1]
	
}

close_service master $m
puts "Closed master"




