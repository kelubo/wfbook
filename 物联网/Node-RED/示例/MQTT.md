# Connect to an MQTT Broker

### Problem

You want to connect to an MQTT broker running locally.

### Solution

Use the `MQTT Input` input or `MQTT Output` node and an associated `MQTT Config` node to connect to an MQTT broker.

#### Example

![img](https://cookbook.nodered.org/images/mqtt/connect-to-broker.png)

### Discussion

Many users will run an MQTT broker such as [mosquitto](http://mosquitto.org) on the same Raspberry Pi or PC that Node-RED is running on.  Once you have an `MQTT` input or output node in your flow, you create an `MQTT Config` node by double clicking on the node, then clicking on the pencil button to the right of the `Add an MQTT broker...` dropdown.  Assuming your broker is open, set the server host to `localhost` and leave the port set to `1883`.

To connect to non-local, secured brokers, other `MQTT Config` node options will need to be set according to your broker’s connectivity requirements.