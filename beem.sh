#!/bin/bash
mqtt_host="${MQTT_HOST:-192.168.0.100}"
mqtt_topic="${MQTT_TOPIC:-beem/status}"

token=`curl https://api-x.beem.energy/beemapp/user/login -X POST -H "Content-Type: application/json" --data-raw "{\"email\":\"${LOGIN}\",\"password\":\"${PASSWORD}\"}" | jq .accessToken`

year=$(date +%Y) 
month=$(date +%m)
data='{"month":'${month//0}',"year":'${year}'}'
auth='authorization: Bearer '"${token//\"}"

result=`curl https://api-x.beem.energy/beemapp/box/summary -X POST -H "Content-Type: application/json" -H "${auth}" --data-raw "${data}" | tr -d []`

echo $result

mosquitto_pub -r -h $mqtt_host -t homeassistant/sensor/beem/totalMonth/config -m '{"name": "totalMonth", "device_class": "energy", "unit_of_measurement": "Wh", state_topic": "general/beem", "value_template": "{{ value_json.totalMonth}}", "unique_id": "mqtt.beem.totalMonth", "device": {"model": "Beem", "identifiers": ["mqtt-beem"], "name": "Beem", "manufacturer": "Beem"}}'
mosquitto_pub -r -h $mqtt_host -t homeassistant/sensor/beem/wattHour/config -m '{"name": "wattHour", "device_class": "energy", "unit_of_measurement": "Wh", state_topic": "general/beem", "value_template": "{{ value_json.wattHour}}", "unique_id": "mqtt.beem.wattHour", "device": {"model": "Beem", "identifiers": ["mqtt-beem"], "name": "Beem", "manufacturer": "Beem"}}'
mosquitto_pub -r -h $mqtt_host -t homeassistant/sensor/beem/totalDay/config -m '{"name": "totalDay", "device_class": "energy", "unit_of_measurement": "Wh", state_topic": "general/beem", "value_template": "{{ value_json.totalDay}}", "unique_id": "mqtt.beem.totalDay", "device": {"model": "Beem", "identifiers": ["mqtt-beem"], "name": "Beem", "manufacturer": "Beem"}}'

mosquitto_pub -r -h $mqtt_host -t $mqtt_topic -m '$result'
