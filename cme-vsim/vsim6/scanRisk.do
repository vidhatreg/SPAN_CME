onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic :test_bench:span_cme1:scanRisk0:clk
add wave -noupdate -format Logic :test_bench:span_cme1:scanRisk0:reset
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:PriceScanRange
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:position
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:scanningRisk
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:netPos
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:priceChange
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:rowLoss
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:level1
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:level2
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:level3
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:scanningRisk100
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:i
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:j
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:k
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
