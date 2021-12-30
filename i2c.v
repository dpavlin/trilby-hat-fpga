`include "i2c_bridge.v"

module top(
	input clk,

	inout rtc_sda,
	inout rtc_scl,

	inout tuner_sda,
	inout tuner_scl,

	output green_led_d7,
	output orange_led_d8,
	output red_led_d5,
	output yellow_led_d6
);

	assign green_led_d7  = 1;
	assign orange_led_d8 = 1;
	assign red_led_d5    = 1;
	assign yellow_led_d6 = 1;

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
