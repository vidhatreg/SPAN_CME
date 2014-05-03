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
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:initialMargin
add wave -noupdate -format Literal :test_bench:span_cme1:tierMax
add wave -noupdate -format Literal :test_bench:span_cme1:maturity
add wave -noupdate -format Literal :test_bench:span_cme1:position
add wave -noupdate -format Literal :test_bench:span_cme1:scanningRisk
add wave -noupdate -format Literal :test_bench:span_cme1:priceScanRange
add wave -noupdate -format Literal :test_bench:span_cme1:TSC
add wave -noupdate -format Literal :test_bench:span_cme1:spreadCharge
add wave -noupdate -format Literal :test_bench:span_cme1:outright
add wave -noupdate -format Literal :test_bench:span_cme1:crossCommCharge
add wave -noupdate -format Literal :test_bench:span_cme1:outrightRate
add wave -noupdate -format Literal :test_bench:span_cme1:ratio
add wave -noupdate -format Literal :test_bench:span_cme1:interRate
add wave -noupdate -format Logic :test_bench:span_cme1:startScanRisk
add wave -noupdate -format Logic :test_bench:span_cme1:startInterMonth
add wave -noupdate -format Logic :test_bench:span_cme1:startCross
add wave -noupdate -format Literal :test_bench:span_cme1:i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {413 fs} 0}
configure wave -namecolwidth 389
configure wave -valuecolwidth 146
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
WaveRestoreZoom {0 fs} {640 fs}
