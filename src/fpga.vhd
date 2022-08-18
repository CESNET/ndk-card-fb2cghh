-- fpga.vhd: FB4CGG3 board top level entity and architecture
-- Copyright (C) 2022 CESNET z. s. p. o.
-- Author(s): David Beneš <benes.david2000@seznam.cz>
--
-- SPDX-License-Identifier: BSD-3-Clause

library ieee;
library unisim;
library xpm;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.combo_const.all;
use work.combo_user_const.all;

use work.math_pack.all;
use work.type_pack.all;
use work.dma_bus_pack.all;

use unisim.vcomponents.all;

entity FPGA is
port (
    -- PCIe
    PCIE_SYSCLK_P       : in    std_logic;
    PCIE_SYSCLK_N       : in    std_logic;
    PCIE_SYSRST_N       : in    std_logic;
    PCIE_RX_P           : in    std_logic_vector(16-1 downto 0);
    PCIE_RX_N           : in    std_logic_vector(16-1 downto 0);
    PCIE_TX_P           : out   std_logic_vector(16-1 downto 0);
    PCIE_TX_N           : out   std_logic_vector(16-1 downto 0);

    -- 50 MHz external clock 
    REFCLK              : in    std_logic;

    -- Pulse per second
    PPS_IN              : in    std_logic;
    PPS_OUT             : out   std_logic;
    PPS_OUT_EN          : out   std_logic;

    -- SF2 SPI interface
    SF2_CLK             : out   std_logic;
    SF2_NSS             : out   std_logic;
    SF2_MOSI            : out   std_logic;
    SF2_MISO            : in    std_logic;
    SF2_INT             : in    std_logic;

    -- QSFP control
    QSFP0_SCL           : inout std_logic;
    QSFP0_SDA           : inout std_logic;
    QSFP0_LPMODE        : out   std_logic;
    QSFP0_RESET_N       : out   std_logic;
    QSFP0_MODPRS_N      : in    std_logic;
    QSFP0_INT_N         : in    std_logic;

    QSFP1_SCL           : inout std_logic;
    QSFP1_SDA           : inout std_logic;
    QSFP1_LPMODE        : out   std_logic;
    QSFP1_RESET_N       : out   std_logic;
    QSFP1_MODPRS_N      : in    std_logic;
    QSFP1_INT_N         : in    std_logic;

    -- QSFP data
    QSFP0_REFCLK_P      : in    std_logic;
    QSFP0_REFCLK_N      : in    std_logic;
    QSFP0_RX_P          : in    std_logic_vector(3 downto 0);
    QSFP0_RX_N          : in    std_logic_vector(3 downto 0);
    QSFP0_TX_P          : out   std_logic_vector(3 downto 0);
    QSFP0_TX_N          : out   std_logic_vector(3 downto 0);

    QSFP1_REFCLK_P      : in    std_logic;
    QSFP1_REFCLK_N      : in    std_logic;
    QSFP1_RX_P          : in    std_logic_vector(3 downto 0);
    QSFP1_RX_N          : in    std_logic_vector(3 downto 0);
    QSFP1_TX_P          : out   std_logic_vector(3 downto 0);
    QSFP1_TX_N          : out   std_logic_vector(3 downto 0);

    -- Front (link status) LEDs SSR                     --TODO
    QLED_SDI            : out std_logic; -- Shift data
    QLED_LE             : out std_logic; -- Load
    QLED_CLK            : out std_logic;

    LED_STATUS          : out std_logic_vector(1 downto 0)

);
end entity;

architecture FULL of FPGA is

    -- DMA debug parameters
    constant DMA_GEN_LOOP_EN     : boolean := true;

    constant PCIE_LANES          : integer := 16;
    constant PCIE_CLKS           : integer := 1;
    constant PCIE_CONS           : integer := 1;
    constant MISC_IN_WIDTH       : integer := 1+1+32+1+1+32;
    constant MISC_OUT_WIDTH      : integer := 1+1+1+1+1+4+8+32+1+1+4+8+32;
    constant ETH_LANES           : integer := 4;
    constant DMA_MODULES         : integer := PCIE_ENDPOINTS;
    constant DMA_ENDPOINTS       : integer := PCIE_ENDPOINTS;
    constant BOARD               : string  := "FB2CGHH";
    constant ETH_LANE_MAP        : integer_vector(2*ETH_LANES-1 downto 0) := (3, 2, 1, 0, 3, 2, 1, 0);
    constant ETH_LANE_RXPOLARITY : std_logic_vector(2*ETH_LANES-1 downto 0) := "00000000";
    constant ETH_LANE_TXPOLARITY : std_logic_vector(2*ETH_LANES-1 downto 0) := "00000000";
    constant DEVICE              : string  := "ULTRASCALE";

    signal sysclk_ibuf      : std_logic;
    signal sysclk_bufg      : std_logic;
    signal sysrst_cnt       : unsigned(4 downto 0) := (others => '0');
    signal sysrst           : std_logic := '1';

    signal eth_led_g        : std_logic_vector(2*4-1 downto 0);
    signal eth_led_r        : std_logic_vector(2*4-1 downto 0);
    
    signal eth_refclk_p     : std_logic_vector(2-1 downto 0);
    signal eth_refclk_n     : std_logic_vector(2-1 downto 0);
    signal eth_rx_p         : std_logic_vector(2*ETH_LANES-1 downto 0);
    signal eth_rx_n         : std_logic_vector(2*ETH_LANES-1 downto 0);
    signal eth_tx_p         : std_logic_vector(2*ETH_LANES-1 downto 0);
    signal eth_tx_n         : std_logic_vector(2*ETH_LANES-1 downto 0);

    signal qsfp_lpmode      : std_logic_vector(2-1 downto 0) := (others => '1');
    signal qsfp_reset_n     : std_logic_vector(2-1 downto 0) := (others => '0');
    signal qsfp_scl         : std_logic_vector(2-1 downto 0) := (others => 'Z');
    signal qsfp_sda         : std_logic_vector(2-1 downto 0) := (others => 'Z');
    signal qsfp_modprs_n    : std_logic_vector(2-1 downto 0);
    signal qsfp_int_n       : std_logic_vector(2-1 downto 0);
    
    signal misc_in          : std_logic_vector(MISC_IN_WIDTH-1 downto 0) := (others => '0');
    signal misc_out         : std_logic_vector(MISC_OUT_WIDTH-1 downto 0);

    signal pcie_clk         : std_logic;
    signal pcie_reset       : std_logic;

    signal boot_mi_clk      : std_logic;
    signal boot_mi_reset    : std_logic;
    signal boot_mi_dwr      : std_logic_vector(31 downto 0);
    signal boot_mi_addr     : std_logic_vector(31 downto 0);
    signal boot_mi_rd       : std_logic;
    signal boot_mi_wr       : std_logic;
    signal boot_mi_be       : std_logic_vector(3 downto 0);
    signal boot_mi_drd      : std_logic_vector(31 downto 0);
    signal boot_mi_ardy     : std_logic;
    signal boot_mi_drdy     : std_logic;

    -- Quad SPI controller
    signal axi_spi_clk      : std_logic;
    signal boot_reset       : std_logic;
    signal boot_clk         : std_logic;

    -- AXI Flash Controller 
    signal axi_mi_addr_s    : std_logic_vector(8 - 1 downto 0);           
    signal axi_mi_dwr_s     : std_logic_vector(32 - 1 downto 0);         
    signal axi_mi_wr_s      : std_logic;        
    signal axi_mi_rd_s      : std_logic;        
    signal axi_mi_be_s      : std_logic_vector((32/8)-1 downto 0);        
    signal axi_mi_ardy_s    : std_logic;          
    signal axi_mi_drd_s     : std_logic_vector(32 - 1 downto 0);         
    signal axi_mi_drdy_s    : std_logic;

    --BMC controller 
    signal bmc_mi_addr_s    : std_logic_vector(8 - 1 downto 0);
    signal bmc_mi_dwr_s     : std_logic_vector(32 - 1 downto 0);
    signal bmc_mi_wr_s      : std_logic;
    signal bmc_mi_rd_s      : std_logic;
    signal bmc_mi_be_s      : std_logic_vector(3 downto 0);
    signal bmc_mi_ardy_s    : std_logic;
    signal bmc_mi_drd_s     : std_logic_vector(32 - 1 downto 0);
    signal bmc_mi_drdy_s    : std_logic;

begin

    sysclk_ibuf_i : IBUFG
    port map (
        I  => REFCLK,
        O  => sysclk_ibuf
    );

    sysclk_bufg_i : BUFG
    port map (
        I => sysclk_ibuf,
        O => sysclk_bufg
    );

    -- reset after power up
    process(sysclk_bufg)
    begin
        if rising_edge(sysclk_bufg) then
            if (sysrst_cnt(sysrst_cnt'high) = '0') then
                sysrst_cnt <= sysrst_cnt + 1;
            end if;
            sysrst <= not sysrst_cnt(sysrst_cnt'high);
        end if;
    end process;

    PPS_OUT <= PPS_IN;

    -- QSFP MAPPING ------------------------------------------------------------
    eth_refclk_p <= QSFP1_REFCLK_P & QSFP0_REFCLK_P; 
    eth_refclk_n <= QSFP1_REFCLK_N & QSFP0_REFCLK_N;

    eth_rx_p <= QSFP1_RX_P & QSFP0_RX_P;
    eth_rx_n <= QSFP1_RX_N & QSFP0_RX_N;


    QSFP1_TX_P <= eth_tx_p(2*ETH_LANES-1 downto 1*ETH_LANES);
    QSFP1_TX_N <= eth_tx_n(2*ETH_LANES-1 downto 1*ETH_LANES);
    QSFP0_TX_P <= eth_tx_p(1*ETH_LANES-1 downto 0*ETH_LANES);
    QSFP0_TX_N <= eth_tx_n(1*ETH_LANES-1 downto 0*ETH_LANES);


    QSFP1_LPMODE  <= qsfp_lpmode(1);
    QSFP1_RESET_N <= qsfp_reset_n(1);
    QSFP1_SCL     <= qsfp_scl(1);
    QSFP1_SDA     <= qsfp_sda(1);
    QSFP0_LPMODE  <= qsfp_lpmode(0);
    QSFP0_RESET_N <= qsfp_reset_n(0);
    QSFP0_SCL     <= qsfp_scl(0);
    QSFP0_SDA     <= qsfp_sda(0);

    qsfp_modprs_n <= QSFP1_MODPRS_N & QSFP0_MODPRS_N;
    qsfp_int_n    <= QSFP1_INT_N & QSFP0_INT_N;

    axi_spi_clk     <= misc_out(0); -- usr_x1 = 100MHz
    boot_clk        <= misc_out(2); -- usr_x2 = 200MHz
    boot_reset      <= misc_out(3);

    boot_ctrl_i : entity work.BOOT_CTRL
    generic map(
        DEVICE      => DEVICE,
        BOOT_TYPE   => 3
    )
    port map(
        MI_CLK        => boot_mi_clk,
        MI_RESET      => boot_mi_reset,
        MI_DWR        => boot_mi_dwr,
        MI_ADDR       => boot_mi_addr,
        MI_BE         => boot_mi_be,
        MI_RD         => boot_mi_rd,
        MI_WR         => boot_mi_wr,
        MI_ARDY       => boot_mi_ardy,
        MI_DRD        => boot_mi_drd,
        MI_DRDY       => boot_mi_drdy,

        BOOT_CLK      => boot_clk,
        BOOT_RESET    => boot_reset,

        BOOT_REQUEST  => open,
        BOOT_IMAGE    => open,

        BMC_MI_ADDR   => bmc_mi_addr_s,
        BMC_MI_DWR    => bmc_mi_dwr_s, 
        BMC_MI_WR     => bmc_mi_wr_s,
        BMC_MI_RD     => bmc_mi_rd_s,
        BMC_MI_BE     => bmc_mi_be_s,
        BMC_MI_ARDY   => bmc_mi_ardy_s,
        BMC_MI_DRD    => bmc_mi_drd_s,
        BMC_MI_DRDY   => bmc_mi_drdy_s,
        
        AXI_MI_ADDR   => axi_mi_addr_s,
        AXI_MI_DWR    => axi_mi_dwr_s, 
        AXI_MI_WR     => axi_mi_wr_s,
        AXI_MI_RD     => axi_mi_rd_s,
        AXI_MI_BE     => axi_mi_be_s,
        AXI_MI_ARDY   => axi_mi_ardy_s,
        AXI_MI_DRD    => axi_mi_drd_s,
        AXI_MI_DRDY   => axi_mi_drdy_s
    );

    bmc_ctrl_i: entity work.bmc_driver
    port map(
        CLK            => boot_clk,
        RST            => boot_reset,

        SPI_CLK        => SF2_CLK,
        SPI_NSS        => SF2_NSS,
        SPI_MOSI       => SF2_MOSI,
        SPI_MISO       => SF2_MISO,
        SPI_INT        => SF2_INT,

        -- MI32 protocol signals 
        BMC_MI_ADDR    => bmc_mi_addr_s,
        BMC_MI_DWR     => bmc_mi_dwr_s,
        BMC_MI_WR      => bmc_mi_wr_s,
        BMC_MI_RD      => bmc_mi_rd_s,
        BMC_MI_BE      => bmc_mi_be_s,
        BMC_MI_ARDY    => bmc_mi_ardy_s,
        BMC_MI_DRD     => bmc_mi_drd_s,
        BMC_MI_DRDY    => bmc_mi_drdy_s
    );

    axi_flash: entity work.axi_quad_flash_controller
    port map(
        -- clock and reset
        CLK          => boot_clk,
        SPI_CLK      => axi_spi_clk,
        RST          => boot_reset,

        -- MI32 protocol 
        AXI_MI_ADDR => axi_mi_addr_s, 
        AXI_MI_DWR  => axi_mi_dwr_s,
        AXI_MI_WR   => axi_mi_wr_s,
        AXI_MI_RD   => axi_mi_rd_s,
        AXI_MI_BE   => axi_mi_be_s,
        AXI_MI_ARDY => axi_mi_ardy_s,
        AXI_MI_DRD  => axi_mi_drd_s,
        AXI_MI_DRDY => axi_mi_drdy_s,

        -- STARTUP I/O signals
        CFGCLK      => open,
        CFGMCLK     => open,
        EOS         => open,
        PREQ        => open
    );

    led_driver_i: entity work.led_serial_ctrl
    generic map(
        LED_W          => 8,
        FREQ_DIV       => 10,
        LED_POLARITY   => '1',
        CNT_TIMEOUT    => (others => '1')
    )
    port map(
        CLK             => sysclk_bufg,
        RST             => sysrst,
        RED_LED         => eth_led_r,
        GREEN_LED       => eth_led_g,
        LED_SDI         => QLED_SDI,
        LED_CLK         => QLED_CLK,
        LED_LE          => QLED_LE
    );
 
    -- FPGA COMMON -------------------------------------------------------------
    usp_i : entity work.FPGA_COMMON
    generic map (
        SYSCLK_FREQ             => 250,
        USE_PCIE_CLK            => true,
        
        PCIE_LANES              => PCIE_LANES,
        PCIE_CLKS               => PCIE_CLKS,
        PCIE_CONS               => PCIE_CONS,

        ETH_CORE_ARCH           => NET_MOD_ARCH,
        ETH_PORTS               => ETH_PORTS,
        ETH_PORT_SPEED          => ETH_PORT_SPEED,
        ETH_PORT_CHAN           => ETH_PORT_CHAN,
        ETH_LANES               => ETH_LANES,
        ETH_LANE_MAP            => ETH_LANE_MAP(ETH_PORTS*ETH_LANES-1 downto 0),
        ETH_LANE_RXPOLARITY     => ETH_LANE_RXPOLARITY(ETH_PORTS*ETH_LANES-1 downto 0),
        ETH_LANE_TXPOLARITY     => ETH_LANE_TXPOLARITY(ETH_PORTS*ETH_LANES-1 downto 0),

        QSFP_PORTS              => ETH_PORTS,
        QSFP_I2C_PORTS          => ETH_PORTS,
        ETH_PORT_LEDS           => 4,

        STATUS_LEDS             => 2,

        MISC_IN_WIDTH           => MISC_IN_WIDTH,
        MISC_OUT_WIDTH          => MISC_OUT_WIDTH,

        PCIE_ENDPOINTS          => PCIE_ENDPOINTS,
        PCIE_ENDPOINT_TYPE      => PCIE_MOD_ARCH,
        PCIE_ENDPOINT_MODE      => PCIE_ENDPOINT_MODE,

        DMA_ENDPOINTS           => DMA_ENDPOINTS,
        DMA_MODULES             => DMA_MODULES,

        DMA_RX_CHANNELS         => DMA_RX_CHANNELS/DMA_MODULES,
        DMA_TX_CHANNELS         => DMA_TX_CHANNELS/DMA_MODULES,

        BOARD                   => BOARD,
        DEVICE                  => DEVICE,

        DMA_GEN_LOOP_EN         => DMA_GEN_LOOP_EN
    )
    port map(
        SYSCLK                  => sysclk_bufg,
        SYSRST                  => sysrst,

        PCIE_SYSCLK_P(0)        => PCIE_SYSCLK_P,
        PCIE_SYSCLK_N(0)        => PCIE_SYSCLK_N,
        PCIE_SYSRST_N(0)        => PCIE_SYSRST_N,
        PCIE_RX_P               => PCIE_RX_P,
        PCIE_RX_N               => PCIE_RX_N,
        PCIE_TX_P               => PCIE_TX_P,
        PCIE_TX_N               => PCIE_TX_N,

        ETH_REFCLK_P            => eth_refclk_p(ETH_PORTS-1 downto 0),
        ETH_REFCLK_N            => eth_refclk_n(ETH_PORTS-1 downto 0),

        ETH_RX_P                => eth_rx_p(ETH_PORTS*ETH_LANES-1 downto 0),
        ETH_RX_N                => eth_rx_n(ETH_PORTS*ETH_LANES-1 downto 0),
        ETH_TX_P                => eth_tx_p(ETH_PORTS*ETH_LANES-1 downto 0),
        ETH_TX_N                => eth_tx_n(ETH_PORTS*ETH_LANES-1 downto 0),

        ETH_LED_R               => eth_led_r(ETH_PORTS*4-1 downto 0),
        ETH_LED_G               => eth_led_g(ETH_PORTS*4-1 downto 0),

        QSFP_I2C_SCL            => qsfp_scl(ETH_PORTS-1 downto 0),
        QSFP_I2C_SDA            => qsfp_sda(ETH_PORTS-1 downto 0),

        QSFP_MODSEL_N           => open,
        QSFP_LPMODE             => qsfp_lpmode(ETH_PORTS-1 downto 0),
        QSFP_RESET_N            => qsfp_reset_n(ETH_PORTS-1 downto 0),
        QSFP_MODPRS_N           => qsfp_modprs_n(ETH_PORTS-1 downto 0),
        QSFP_INT_N              => qsfp_int_n(ETH_PORTS-1 downto 0),

        STATUS_LED_G            => LED_STATUS,
        STATUS_LED_R            => open,

        PCIE_CLK                => pcie_clk,
        PCIE_RESET              => pcie_reset,
    
        BOOT_MI_CLK             => boot_mi_clk,
        BOOT_MI_RESET           => boot_mi_reset,
        BOOT_MI_DWR             => boot_mi_dwr,
        BOOT_MI_ADDR            => boot_mi_addr,
        BOOT_MI_RD              => boot_mi_rd,
        BOOT_MI_WR              => boot_mi_wr,
        BOOT_MI_BE              => boot_mi_be,
        BOOT_MI_DRD             => boot_mi_drd,
        BOOT_MI_ARDY            => boot_mi_ardy,
        BOOT_MI_DRDY            => boot_mi_drdy,

        MISC_IN                 => misc_in,
        MISC_OUT                => misc_out
    );

end architecture;
