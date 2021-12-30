# Trilby HAT ECP5 45k FPGA

http://www.kinetic.co.uk/Trilby.php

This is my attempt at using open source tools to generate bitstream

Run `make prog` to load the example to the board.


## enable RTC

Add to config.txt:

```
dtoverlay=i2c-rtc,ds1307
```

or execute in shell:

```
echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
```


## read HAT ID eeprom

Add to config.txt:

```
dtoverlay=i2c-gpio,i2c_gpio_sda=0,i2c_gpio_scl=1,bus=4
```
