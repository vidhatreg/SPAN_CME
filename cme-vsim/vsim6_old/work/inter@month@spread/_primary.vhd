library verilog;
use verilog.vl_types.all;
entity interMonthSpread is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        Tier_max        : in     vl_logic_vector;
        position        : in     vl_logic_vector;
        maturity        : in     vl_logic_vector;
        SpreadCharge    : in     vl_logic_vector;
        Outright        : in     vl_logic_vector;
        TSC             : out    vl_logic_vector(15 downto 0)
    );
end interMonthSpread;
