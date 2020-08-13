#!/usr/bin/python3
import config
import network
import time

def do_connect():
    sta_if = network.WLAN(network.STA_IF)
    if not sta_if.isconnected():
        print('connecting to network...')
        sta_if.active(True)
        sta_if.disconnect()
        sta_if.connect(config.WIFI_ESSID, config.WIFI_PASSWORD)
        while not sta_if.isconnected():
            time.sleep(1)
    print('network config:', sta_if.ifconfig())