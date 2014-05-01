onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic :test_bench:span_cme1:clk
add wave -noupdate -format Logic :test_bench:span_cme1:reset
add wave -noupdate -format Literal :test_bench:span_cme1:writeData
add wave -noupdate -format Literal :test_bench:span_cme1:offset
add wave -noupdate -format Logic :test_bench:span_cme1:write
add wave -noupdate -format Logic :test_bench:span_cme1:chipselect
add wave -noupdate -format Literal :test_bench:span_cme1:readData
add wave -noupdate -format Logic :test_bench:span_cme1:read
add wave -noupdate -format Literal :test_bench:span_cme1:initialMargin
add wave -noupdate -format Literal :test_bench:span_cme1:Tier_max
add wave -noupdate -format Literal :test_bench:span_cme1:maturity
add wave -noupdate -format Literal :test_bench:span_cme1:position
add wave -noupdate -format Literal :test_bench:span_cme1:scanningRisk
add wave -noupdate -format Literal :test_bench:span_cme1:Trash
add wave -noupdate -format Literal :test_bench:span_cme1:PriceScanRange
add wave -noupdate -format Literal :test_bench:span_cme1:TSC
add wave -noupdate -format Literal :test_bench:span_cme1:SpreadCharge
add wave -noupdate -format Literal :test_bench:span_cme1:Outright
add wave -noupdate -format Logic :test_bench:span_cme1:startScanRisk
add wave -noupdate -format Logic :test_bench:span_cme1:startInterMonth
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
configure wave -namecolwidth 385
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 fs} {1092 fs}
