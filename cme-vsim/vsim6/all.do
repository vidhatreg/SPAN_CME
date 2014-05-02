onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic :test_bench:span_cme1:clk
add wave -noupdate -format Logic :test_bench:span_cme1:reset
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:writeData
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:offset
add wave -noupdate -format Logic -radix decimal :test_bench:span_cme1:write
add wave -noupdate -format Logic -radix decimal :test_bench:span_cme1:chipselect
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:readData
add wave -noupdate -format Logic -radix decimal :test_bench:span_cme1:read
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:initialMargin
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:tierMax
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:maturity
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:position
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanningRisk
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:priceScanRange
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:TSC
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:spreadCharge
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:outright
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossCommCharge
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:outrightRate
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:ratio
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interRate
add wave -noupdate -format Logic :test_bench:span_cme1:startScanRisk
add wave -noupdate -format Logic :test_bench:span_cme1:startInterMonth
add wave -noupdate -format Logic :test_bench:span_cme1:startCross
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:clk
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:reset
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tierMax
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:position
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:maturity
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:spreadCharge
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:outright
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tier1Short
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tier1Long
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tier2Short
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tier2Long
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tier3Short
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:tier3Long
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:short
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:long
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:magTier1ShortFinal
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:magTier2ShortFinal
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:magTier3ShortFinal
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc123Start
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc1Done
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc2Done
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc3Done
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc4Done
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc5Done
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc6Done
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC1
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC2
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC3
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC4
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC5
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:TSC6
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:out1
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:out2
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:interMonthSpread0:out3
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:i
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:j
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:k
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:l
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:tier1ShortFinal
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:tier1LongFinal
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:tier2ShortFinal
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:tier2LongFinal
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:tier3ShortFinal
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:tier3LongFinal
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC1Long
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC1Short
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC2Long
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC2Short
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC3Long
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC3Short
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC4Long
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC4Short
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC5Long
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC5Short
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC6Long
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:TSC6Short
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc123Done
add wave -noupdate -format Literal :test_bench:span_cme1:interMonthSpread0:statusFor123
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:positionsAccumulated
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:tsc456Done
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:statusForTSC4
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:statusForTSC5
add wave -noupdate -format Logic :test_bench:span_cme1:interMonthSpread0:statusForTSC6
add wave -noupdate -format Logic :test_bench:span_cme1:crossComm0:clk
add wave -noupdate -format Logic :test_bench:span_cme1:crossComm0:reset
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossComm0:outrightRate
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossComm0:ratio
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossComm0:interRate
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossComm0:crossCommCharge
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossComm0:outrightMargin
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:crossComm0:crossCommCharge100
add wave -noupdate -format Logic :test_bench:span_cme1:scanRisk0:clk
add wave -noupdate -format Logic :test_bench:span_cme1:scanRisk0:reset
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:priceScanRange
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:position
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:scanningRisk
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:netPos
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:priceChange
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:rowLoss
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:level1
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:level2
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:level3
add wave -noupdate -format Literal -radix decimal :test_bench:span_cme1:scanRisk0:scanningRisk100
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:i
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:j
add wave -noupdate -format Literal :test_bench:span_cme1:scanRisk0:k
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {77 fs} 0}
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
