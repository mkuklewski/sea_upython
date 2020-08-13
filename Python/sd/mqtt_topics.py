#!/usr/bin/python3
import config
 
ERROR_TOO_SHORT_CNT=("v1/%s/things/%s/data/1" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
ERROR_TOO_LONG_CNT=("v1/%s/things/%s/data/2" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
ERROR_NEGATIVE_VALUE_CNT=("v1/%s/things/%s/data/3" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
ERROR_HIST_BIN_OVER_CNT=("v1/%s/things/%s/data/4" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
ERROR_OVERLAPPING_CNT=("v1/%s/things/%s/data/5" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
LOW_ENERGY=("v1/%s/things/%s/data/6" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
MEDIUM_ENERGY=("v1/%s/things/%s/data/7" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))
HIGH_ENERGY=("v1/%s/things/%s/data/8" % (config.MQTT_USERNAME, config.MQTT_CLIENT_ID))