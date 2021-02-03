export BL60X_SDK_PATH=${PWD}/bl_iot_sdk
export CONFIG_CHIP_NAME=BL602
export DEFAULT_HOST_IP="192.168.2.9"
export EXTRA_CFLAGS=-DBAUDRATE=115200

all:
	cd ${BL60X_SDK_PATH}; make

clean:
	cd ${BL60X_SDK_PATH}; make clean

# make one at a time
bl602_demo_at sdk_app_audio_udp bl602_boot2_mini sdk_app_pwm sdk_app_dac sdk_app_hbnram bl602_demo_event bl602_demo_noconnectivity sdk_app_mdns sdk_app_timer sdk_app_gpio sdk_app_blog sdk_app_romfs sdk_app_helloworld benchmark_security_aes sdk_app_spi sdk_app_cli sdk_app_ir sdk_app_easyflash sdk_app_ble_sync sdk_app_cronalarm sdk_app_event sdk_app_uart_echo sdk_app_fdt sdk_app_i2c bl602_demo_nano bl602_demo_wifi sdk_app_bledemo sdk_app_uart_ctl sdk_app_http_client_socket sdk_app_heap bl602_huawei_cloud sdk_app_http_client_tcp bl602_boot2:
	cd ${BL60X_SDK_PATH}/customer_app/$@; ./genromap

misc:
#	cd ${BL60X_SDK_PATH}/customer_app/bl602_demo_at; ./gensimpleble errors
	cd ${BL60X_SDK_PATH}/customer_app/bl602_demo_event; ./genblemesh
	cd ${BL60X_SDK_PATH}/customer_app/bl602_demo_event; ./gensimpleble
	cd ${BL60X_SDK_PATH}/customer_app/bl602_demo_event; ./genblemeshmodel
	cd ${BL60X_SDK_PATH}/customer_app/sdk_app_cronalarm; ./gensimpleble
	cd ${BL60X_SDK_PATH}/customer_app/bl602_demo_nano; ./gensimpleble

# clean one at a time
bl602_demo_at-clean sdk_app_audio_udp-clean bl602_boot2_mini-clean sdk_app_pwm-clean sdk_app_dac-clean sdk_app_hbnram-clean bl602_demo_event-clean bl602_demo_noconnectivity-clean sdk_app_mdns-clean sdk_app_timer-clean sdk_app_gpio-clean sdk_app_blog-clean sdk_app_romfs-clean sdk_app_helloworld-clean benchmark_security_aes-clean sdk_app_spi-clean sdk_app_cli-clean sdk_app_ir-clean sdk_app_easyflash-clean sdk_app_ble_sync-clean sdk_app_cronalarm-clean sdk_app_event-clean sdk_app_uart_echo-clean sdk_app_fdt-clean sdk_app_i2c-clean bl602_demo_nano-clean bl602_demo_wifi-clean sdk_app_bledemo-clean sdk_app_uart_ctl-clean sdk_app_http_client_socket-clean sdk_app_heap-clean bl602_huawei_cloud-clean sdk_app_http_client_tcp-clean bl602_boot2-clean:
	cd ${BL60X_SDK_PATH}/customer_app/`echo $@ | sed -e "s/-clean//"`; make clean

# flash one
bl602_demo_at-flash sdk_app_audio_udp-flash bl602_boot2_mini-flash sdk_app_pwm-flash sdk_app_dac-flash sdk_app_hbnram-flash bl602_demo_event-flash bl602_demo_noconnectivity-flash sdk_app_mdns-flash sdk_app_timer-flash sdk_app_gpio-flash sdk_app_blog-flash sdk_app_romfs-flash sdk_app_helloworld-flash benchmark_security_aes-flash sdk_app_spi-flash sdk_app_cli-flash sdk_app_ir-flash sdk_app_easyflash-flash sdk_app_ble_sync-flash sdk_app_cronalarm-flash sdk_app_event-flash sdk_app_uart_echo-flash sdk_app_fdt-flash sdk_app_i2c-flash bl602_demo_nano-flash bl602_demo_wifi-flash sdk_app_bledemo-flash sdk_app_uart_ctl-flash sdk_app_http_client_socket-flash sdk_app_heap-flash bl602_huawei_cloud-flash sdk_app_http_client_tcp-flash bl602_boot2-flash:
	cd ${BL60X_SDK_PATH}/customer_app; python3 ${BL60X_SDK_PATH}/image_conf/flash_build.py `echo $@ | sed -e "s/-flash//"` bl602
	cd bl602tool; python3 bltool.py --baudrate 1000000 --write 0 ${BL60X_SDK_PATH}/customer_app/`echo $@ | sed -e "s/-flash//"`/build_out/whole_*c84015.bin

info:
	cd bl602tool; python3 bltool.py --baudrate 1000000 --info

erase:
	cd bl602tool; python3 bltool.py --baudrate 1000000 --erase

read:
	cd bl602tool; python3 bltool.py --baudrate 1000000 --read 0 131072 ../read.bin

orig:
	cd bl602tool; python3 bltool.py --baudrate 1000000 --write 0 ../read.bin

github-init:
	rm -rf .git
	git init
	git add Makefile docs ./README.md
	git commit -m "first commit"
	git remote add origin https://github.com/rickbronson/Bouffalo-bl602-on-Debian.git
#	git push -u origin master

github-update:
	git commit -a -m 'update README'
	git push -u origin master
