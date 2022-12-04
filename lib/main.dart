import 'dart:convert';

import 'package:centerfascia_application/pages/camera.dart';
import 'package:flutter/material.dart';
import 'package:centerfascia_application/pages/home.dart';
import 'package:centerfascia_application/pages/hw_control.dart';
import 'package:centerfascia_application/pages/google_maps.dart';
import 'package:centerfascia_application/pages/youtube_playlist.dart';
import 'package:centerfascia_application/pages/logo.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';

final client = MqttServerClient('43.201.126.212', '');
Future<void> main() async {
  client.setProtocolV311();
  client.onDisconnected = onDisconnected;
  client.onConnected = onConnected;
  client.onSubscribed = onSubscribed;
  //client.onUnsubscribed = onUnsubscribed;

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

  const topic2 = 'connect/request';
  final builder = MqttClientPayloadBuilder();
  builder.addString(
      '{"dev_type":0,"device_id":"XDDDDDDD","timestamp":55555,"public_key":"deez_nutz"}');
  client.publishMessage(topic2, MqttQos.exactlyOnce, builder.payload!);

  const topic1 = 'connect/reply';
  client.subscribe(topic1, MqttQos.atMostOnce);

  const waitforfacerepy = 't/reply';
  client.subscribe(waitforfacerepy, MqttQos.atMostOnce);

  /*const topicsendface = 'user_topic/Face recognition request';
  final facebuilder = MqttClientPayloadBuilder();
  facebuilder
      .addString('{"cmd_type": 2, "user_id": "user1","password":"1234"}');
  client.publishMessage(
      topicsendface, MqttQos.exactlyOnce, facebuilder.payload!);*/

  /*const topicfacerep = 't/reply';
  client.subscribe(topicfacerep, MqttQos.atMostOnce);*/

  const topichw = 't/hw_configs';
  final hwbuilder = MqttClientPayloadBuilder();
  client.subscribe(topichw, MqttQos.atMostOnce);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    ////
    var data = jsonDecode(pt);
    /////
    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });

  const topicfacerep = 't/reply';
  client.subscribe(topicfacerep, MqttQos.atMostOnce);
  const topicsendface = 'user_topic/Face recognition request';
  final facebuilder = MqttClientPayloadBuilder();
  facebuilder
      .addString('{"cmd_type": 2, "user_id": "user1","password":"1234"}');
  client.publishMessage(
      topicsendface, MqttQos.exactlyOnce, facebuilder.payload!);

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    ////
    var data = jsonDecode(pt);
    /////
    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });

  /// If needed you can listen for published messages that have completed the publishing
  /// handshake which is Qos dependant. Any message received on this stream has completed its
  /// publishing handshake with the broker.
  client.published!.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  //hwbuilder.addString(
  //'{"sidemirror_ver":55555,"sidemirror_hor":33333,"seat_depth":1241,"seat_angle",7777,"handle_height",123123,"moodlight_color":2412}');
  //client.publishMessage(topichw, MqttQos.exactlyOnce, hwbuilder.payload!);
  /*WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', //test
      routes: {
        '/home': (context) => Home(),
        '/youtube_playlist': (context) => YoutubePlaylist(),
        '/hw_control': (context) => HW_Control(),
        '/google_maps': (context) => GoogleMaps(),
        '/logo': (context) => Logo(),
        '/camera': (context) => CameraAuth(),
      }));*/
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

// unsubscribe succeeded
void onUnsubscribed(String topic) {
  print('Unsubscribed topic: $topic');
}
