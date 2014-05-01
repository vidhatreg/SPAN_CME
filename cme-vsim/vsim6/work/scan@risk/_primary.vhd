library verilog;
use verilog.vl_types.all;
entity scanRisk is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        PriceScanRange  : in     vl_logic_vector(15 downto 0);
        position        : in     vl_logic_vector;
        scanningRisk    : out    vl_logic_vector(15 downto 0)
    );
end scanRisk;
