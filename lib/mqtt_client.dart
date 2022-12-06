import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class mqttConnection {
  static final MqttServerClient client = MqttServerClient('43.201.126.212', '');
  static late final String clientToServerTopic;
  static late final String serverToClientTopic;
  static late StreamController<bool> _loginCheckStream;
  static late StreamController<dynamic> _placeDataStream;
  ////나중에 logout할때 싹 초기화 시키고 나갈것/////
  static bool faceauthdone = false;
  static bool faceautprocessing = false;

  /////////
  mqttConnection() {
    client.setProtocolV311();
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
  }

  void onDisconnected() {
    print('MQTT:: OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
  }

  void onConnected() {
    print(
        'MQTT:: OnConnected client callback - Client connection was successful.');
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void initialConnectionHandler(dynamic json) {
    serverToClientTopic = '${json['topic_name']}';
    clientToServerTopic = '${json['topic_name']}/user_command';
    client.subscribe('${serverToClientTopic}/reply', MqttQos.atMostOnce);
    client.subscribe('${serverToClientTopic}/sw_configs', MqttQos.atMostOnce);
    client.subscribe('${serverToClientTopic}/gps_configs', MqttQos.atMostOnce);
    client.subscribe('${serverToClientTopic}/hw_configs', MqttQos.atMostOnce);
  }

  Future<void> requestToServer(String msg) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void loginRequest(String msg, StreamController<bool> check) async {
    _loginCheckStream = check;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void placeRequest(String msg, StreamController<dynamic> data) async {
    final builder = MqttClientPayloadBuilder();
    _placeDataStream = data;
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void replyHandler(dynamic json) {
    int request_type = json['request_type'];
    if (request_type == 1) {
      bool isSucceed = json['succeed'];
      print(isSucceed);
      _loginCheckStream.add(isSucceed);
    }
    return;
  }

  void hwHandler(dynamic json) {
    print(json);
  }

  void swHandler(dynamic json) {
    print(json);
  }

  void gpsHandler(dynamic json) {
    print(json);
    _placeDataStream.add(json);
  }

  void faceauthHandler(dynamic json) {
    bool tf = json['succeed'];
    faceauthdone = tf;
  }

  void messageHandler(String topic, String msg) {
    dynamic json = convert.jsonDecode(msg);
    print('MQTT messageHandler : $msg');
    if (topic == 'connect/reply' && json['device_id'] == 'adcc') {
      initialConnectionHandler(json);
      return;
    }
    if (topic == '${serverToClientTopic}/reply' && json['request_type'] == 0) {
      //deals with face authentication
      print("face auth started!\n");
      faceauthHandler(json);
      faceautprocessing = true;
      return;
    }
    if (topic == '${serverToClientTopic}/reply') {
      replyHandler(json);
      return;
    }
    if (topic == '${serverToClientTopic}/sw_configs') {
      swHandler(json);
      return;
    }
    if (topic == '${serverToClientTopic}/gps_configs') {
      gpsHandler(json);
    }
    if (topic == '${serverToClientTopic}/hw_configs') {
      hwHandler(json);
    }
  }

  Future<void> connect() async {
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
    client.published!.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
      messageHandler(c[0].topic, payload);
    });

    const topic1 = 'connect/reply';
    client.subscribe(topic1, MqttQos.atMostOnce);

    const topic2 = 'connect/request';
    final builder = MqttClientPayloadBuilder();
    builder.addString(
        '{"dev_type":0,"device_id":"adcc","timestamp":14141,"public_key":"3421a"}');
    client.publishMessage(topic2, MqttQos.exactlyOnce, builder.payload!);
    print("sssssssssssffffffffffffffffffffffff\n");
  }
}
