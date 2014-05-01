library verilog;
use verilog.vl_types.all;
entity span_cme is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        writeData       : in     vl_logic_vector(15 downto 0);
        offset          : in     vl_logic_vector(4 downto 0);
        write           : in     vl_logic;
        chipselect      : in     vl_logic;
        readData        : out    vl_logic_vector(15 downto 0);
        read            : in     vl_logic
    );
end span_cme;
