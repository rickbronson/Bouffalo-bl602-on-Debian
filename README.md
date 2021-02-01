  Developing for a Bouffalo bl602 under Debian
==========================================

  With the success of the ESP8266, it was only a matter of time before someone came out with a similar part.  It's a little more expensive than the ESP8266 but it's got BLE and seems to have a real I2C peripheral instead of a software implemented one.

  Below is what I needed to do to get it all working on Debian.

  I first tried each of these:

https://github.com/SmartArduino/Doiting_BL.git
https://github.com/bouffalolab/bl_iot_sdk.git

  but found they did not completely build.

 - Get this repository

```
mkdir <somewhere>
cd <somewhere>
git clone https://github.com/rickbonron/Bouffalo-bl602-on-Debian.git
```

 - Get the SDK and the flasher

```
cd Bouffalo-bl602-on-Debian
git clone https://github.com/pine64/bl_iot_sdk
git clone https://github.com/renzenicolai/bl602tool.git
pip3 install serial pyserial
```

 - I had a lot of trouble with the baud rate set at 2000000.  Many characters never seem to make it to my screen.  So I switched the baud rate to 115200:

```
for file in `find bl_iot_sdk -name "*.c"`; do if grep bl_uart_init $file; then \
sed -i -e "s/bl_uart_init(0, 16, 7, 255, 255, 2 \* 1000 \* 1000)/bl_uart_init(0, 16, 7, 255, 255, BAUDRATE)/" $file; fi; done

for file in `find bl_iot_sdk -name "*.c"`; do if grep bflb_platform_init $file; then \
sed -i -e "s/bflb_platform_init(2000000)/bflb_platform_init(BAUDRATE)/" $file; fi; done

for file in `find bl_iot_sdk \( -name "*.dts" \)`; do if grep "\b2000000\b" $file; then \
sed -i -e "s/baudrate = <2000000>/baudrate = <115200>/" $file; fi; done

for file in `find bl_iot_sdk \( -name platform_device.c \)`; do if grep "\b2000000\b" $file; then \
sed -i -e "s/2000000/BAUDRATE/" $file; fi; done
```

 - Add in httpd so we can browse to the board

```
sed -i -e "s|apps/altcp_tls|apps/altcp_tls src/apps/http|" bl_iot_sdk/components/network/lwip/bouffalo.mk
for file in `find bl_iot_sdk/customer_app \( -name "*.c" \)`; do if grep "tcpip_init(NULL, NULL);" $file; then \
sed -i -e "s/tcpip_init(NULL, NULL);/tcpip_init(NULL, NULL);\n\nhttpd_init();\n/" $file; \
sed -i -e "s|#include <lwip/err.h>|#include <lwip/err.h>\n#include <lwip/apps/httpd.h>|" $file; fi; done
```

 - Build everything
 
```
 make
```

 - Build one app
```
 make bl602_demo_event
```

 - Erase.  Before you do this, you need to hold down the "D8" button and press the RESET button, then relase them both.
```
 make erase
```

- Flash one app.  Before you do this you need to "erase" above, Also, before you do this, you need to hold down the "D8" button and press the RESET button, then relase them both.
```
 make bl602_demo_event
```
 - Use a terminal program to get to the command line
 
```
minicom -b 115200 -w -D /dev/ttyUSB0 -C ~/minicom.USB0-bl602.cap
```

 - Try some things:
```
help
stack_wifi
wifi_sta_connect <Your router SSID> <Your router passcode>
wifi_state
```

 - Once you've connect to your router you should be able to browse to the IP address that the bl602 got from your router and see a web page.

![Joystick mod](https://github.com/rickbronson/RC-Car-Camera/blob/master/docs/hardware/joystick-mod1.png "Joystick mod")

 - Comments/suggestions

  Please contact me at rick AT efn DOT org
