# Trilby HAT ECP5 45k FPGA

This is my attempt at using open source tools to generate bitstream

Run `make prog` to load the example to the board.

## read HAT ID eeprom

Add to config.txt:

dtoverlay=i2c-gpio,i2c_gpio_sda=0,i2c_gpio_scl=1,bus=4
