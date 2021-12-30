`include "i2c_bridge.v"
`include "ecp5pll.sv"

module top(
	input clk,

	inout rtc_sda,
	inout rtc_scl,

	inout tuner_sda,
	inout tuner_scl,

	output mhz_16,mhz_96,

	output exp_pin_3, exp_pin_4,
	output exp_pin_5, exp_pin_6,
	output exp_pin_7, exp_pin_8,

	output green_led_d7,
	output orange_led_d8,
	output red_led_d5,
	output yellow_led_d6
);

	wire [3:0] clocks;
	ecp5pll
	#(
		.in_hz(24000000),
		.out0_hz(16000000),.out0_tol_hz(0) ,
		.out1_hz(96000000), .out1_deg( 0), .out1_tol_hz(0)//,
		//.out2_hz(60000000), .out2_deg(180), .out2_tol_hz(0),
	)
	ecp5pll_inst
	(
		.clk_i(clk),
		.clk_o(clocks)
	);

	assign mhz_16 = clocks[0];
	assign mhz_96 = clocks[1];

/*
	assign exp_pin_4 = clocks[0];
	assign exp_pin_8 = clocks[1];
*/
	assign exp_pin_4 = rtc_scl;
	assign exp_pin_8 = rtc_sda;

	assign green_led_d7  = rtc_scl;
	assign orange_led_d8 = rtc_sda;
	assign red_led_d5    = tuner_scl;
	assign yellow_led_d6 = tuner_sda;


  localparam bridge_clk_div = 3; // div = 1+2^n, 24/(1+2^2)=4 MHz
  reg [bridge_clk_div:0] bridge_cnt;
  always @(posedge clk) // 24 MHz
  begin
    if(bridge_cnt[bridge_clk_div])
      bridge_cnt <= 0;
    else
      bridge_cnt <= bridge_cnt + 1;
  end
  wire clk_bridge_en = bridge_cnt[bridge_clk_div];

  wire [1:0] i2c_sda_i = {rtc_sda, tuner_sda};
  wire [1:0] i2c_sda_t;
  i2c_bridge i2c_sda_bridge_i
  (
    .clk(clk),
    .clk_en(clk_bridge_en),
    .i(i2c_sda_i),
    .t(i2c_sda_t)
  );
  assign rtc_sda = i2c_sda_t[1] ? 1'bz : 1'b0;
  assign tuner_sda = i2c_sda_t[0] ? 1'bz : 1'b0;

  wire [1:0] i2c_scl_i = {rtc_scl, tuner_scl};
  wire [1:0] i2c_scl_t;
  i2c_bridge i2c_scl_bridge_i
  (
    .clk(clk),
    .clk_en(clk_bridge_en),
    .i(i2c_scl_i),
    .t(i2c_scl_t)
  );
  assign rtc_scl = i2c_scl_t[1] ? 1'bz : 1'b0;
  assign tuner_scl = i2c_scl_t[0] ? 1'bz : 1'b0;

endmodule
