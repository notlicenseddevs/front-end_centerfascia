import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:centerfascia_application/variables.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as encr;

import 'dart:math';
import 'dart:typed_data';

import "package:pointycastle/export.dart";

import 'package:pointycastle/asymmetric/api.dart';
import 'package:centerfascia_application/crypto.dart';

class mqttConnection {
  //static final MqttServerClient client =
  //    MqttServerClient.withPort('34.64.86.97', '', 1883);
  static final MqttServerClient client =
      MqttServerClient.withPort('43.201.126.212', '', 1883);
  //    MqttServerClient.withPort('43.201.126.212', '', 1883);
  static late final String clientToServerTopic;
  static late final String serverToClientTopic;
  static late StreamController<bool> _loginCheckStream;
  static late dynamic _playlistFunction;
  static late StreamController<dynamic> _placeDataStream;
  static late StreamController<bool> _cameraCheckStream;
  static late StreamController<dynamic> _hwDataStream;
  static late StreamController<bool> _pinCheckStream;
  cryptoService _crypto = cryptoService();
  /////////
  ///   1. 먼저 streamcontroller을 설정한다. 아마 json형식으로 받을경우가 많으니
  ///      StreamController<dynamic> 으로 한 뒤에 변수명 선언한다.
  /// ////////

  ////나중에 logout할때 싹 초기화 시키고 나갈것/////
  static bool faceauthdone = false;
  static bool faceautprocessing = false;


  mqttConnection() {
    client.setProtocolV311();
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    /////////////
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
    String jsonTopicName =
        _crypto.my_decrypt(convert.base64Decode(json['topic_name']));

    print("TOPIC : " + jsonTopicName);

    serverToClientTopic = '$jsonTopicName';
    clientToServerTopic = '$jsonTopicName/user_command';
    client.subscribe('${serverToClientTopic}/reply', MqttQos.atMostOnce);
    ////////////////////관우야 너꺼다
    client.subscribe('${serverToClientTopic}/sw_configs', MqttQos.atMostOnce);
    client.subscribe('${serverToClientTopic}/gps_configs', MqttQos.atMostOnce);
    ////////////////////관우야 너꺼다
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
  void PlaylistRequest(String msg, dynamic data) async {
    final builder = MqttClientPayloadBuilder();
    _playlistFunction = data;
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }
  //stream request for camera
  void cameraRequest(String msg, StreamController<bool> check) async {
    _cameraCheckStream = check;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void hwRequest(String msg, StreamController<dynamic> data) async {
    final builder = MqttClientPayloadBuilder();
    _hwDataStream = data;
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void pinRequest(String msg, StreamController<bool> check) async {
    _pinCheckStream = check;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void hwsendRequest() {
    final builder = MqttClientPayloadBuilder();
    //String hwobj =
    //    '{"seat_depth": ${appData.botdist},"seat_angle": ${appData.topang},"backmirror_angle": ${appData.glorearang},"handle_height": ${appData.glowheelheight},"sidemirror_left": ${appData.gloleftang},"sidemirror_right": ${appData.glorightang}}'; //create jsonfile of hw configs

    Map<String, Object> hwobj = {
      "seat_depth": appData.botdist,
      "seat_angle": appData.topang,
      "backmirror_angle": appData.glorearang,
      "handle_height": appData.glowheelheight,
      "moodlight_color": "${appData.glocol}",
      "sidemirror_left": appData.gloleftang,
      "sidemirror_right": appData.glorightang,
    };
    final hwjson = convert.jsonEncode(hwobj);
    //String spit = '{"cmd_type":10,"hw_configs",hwjson}';
    Map<String, Object> spit = {
      "cmd_type": 10,
      "hw_configs": hwobj,
    }; //create cmdtype 10 json file
    var spitjson = convert.jsonEncode(spit);
    builder.addString(spitjson);
    print("SENDING HARDWARE INFO");
    print(spitjson);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }
 // TODO make the data structure to receive json file : WIP




  void GoogleMapsSendRequest(){
    final builder = MqttClientPayloadBuilder();
    Map<String, Object> gmobj = {
      "" : "",

    };
    Map<String, Object> spit = {
      "cmd_type": "",
      "": gmobj,
    };
    var spitjson = convert.jsonEncode(spit);
    builder.addString(spitjson);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }
  void playlistSendRequest(){
    final builder = MqttClientPayloadBuilder();
    Map<String, Object> ytobj = {
      "" : "",
    };
    Map<String, Object> spit = {
      "cmd_type": "",
      "": ytobj,
    };
    var spitjson = convert.jsonEncode(spit);
    builder.addString(spitjson);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }
////// TODO /////////
  void turnoffRequest() {
    final builder = MqttClientPayloadBuilder();
    print("TURNING OFF");
    Map<String, Object> turnoff = {
      "cmd_type": 11,
    };
    final turnoffjson = convert.jsonEncode(turnoff);
    builder.addString(turnoffjson);
    client.publishMessage(
        clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }
  ////////////
  ////   2. 뭐시기Request를 만든다
  ///    함수명만 알아먹게 만들고 걍 위에꺼 베끼셈
  /// ///////

  void replyHandler(dynamic json) {
    int request_type = json['request_type'];
    if (request_type == 1) {
      bool isSucceed = json['succeed'];
      print(isSucceed);
      late final stopwatch;
      /////////

      ////////
      _loginCheckStream.add(isSucceed);
    }
    if (request_type == 0) {
      print("camera finished");
      print("I AM HERE ");
      print(json['succeed'].runtimeType);
      bool isSuceed = json['succeed'];
      if (isSuceed == true) {
        appData.user_id = json['user_id'];
      }
      _cameraCheckStream.add(isSuceed);
    }
    if (request_type == 2) {
      print('Pin auth');
      print(json['succeed'].runtimeType);
      bool isSuceed = json['succeed'];
      _pinCheckStream.add(isSuceed);
    }
    return;
    ////////////
    ///      3.request_type 따라 설정해주는거
    ///       따로 request_type 받는거 있으면 그거 하고 나머지는 베껴
    /// //////////
  }

  void hwHandler(dynamic json) {
    print(json);
    _hwDataStream.add(json);
  }

  void swHandler(dynamic json) {
    print(json);
    _playlistFunction(json);
  }

  void gpsHandler(dynamic json) {
    print(json);
    _placeDataStream.add(json);
  }
  void playlistHandler(dynamic json){
    print(json);
  }

  void faceauthHandler(dynamic json) {
    bool tf = json['succeed'];
    faceauthdone = tf;
    //return tf;
    /*if (tf == true) {
      faceauthcorrect();
    } else {
      faceauthincorrect();
    }*/
  }

  bool faceauthcorrect() {
    return true;
  }

  bool faceauthincorrect() {
    return false;
  }

  void messageHandler(String topic, String msg) {
    dynamic json = convert.jsonDecode(msg);
    print('MQTT messageHandler : $msg');
    if (topic == 'connect/reply' &&
        json['device_id'] == '${appData.androidID}') {
      initialConnectionHandler(json);
      return;
    }
    /*if (topic == '${serverToClientTopic}/reply' && json['request_type'] == 0) {
      //deals with face authentication
      appData.facejson = json;
      print("face auth started!\n");
      faceauthHandler(json);
      return;
    }*/ //나중에 필요하면 살려야할수도 있음
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

  ///////////////////////////encryption keygen/////////////////////
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    // Create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  ////////////////////////////////////////////////////////////
  Future<void> connect() async {
    WidgetsFlutterBinding.ensureInitialized();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    ////////////////////
    /////////////////////////////
    AndroidDeviceInfo androidtmp =
        await deviceInfo.androidInfo; //finds device info
    appData.androidID = androidtmp.id;
    await _crypto.initialize();
    try {
      //client.keepAlivePeriod = 10000;
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

    /*appData.serverpublickey = await parseKeyFromFile<RSAPublicKey>(
        '../keyfiles/public_key.pem');*/ //get server public key
    const topic1 = 'connect/reply';
    print("222222222222222");
    client.subscribe(topic1, MqttQos.atMostOnce);

    const topic2 = 'connect/request';
    final builder = MqttClientPayloadBuilder();
    print("33333333333333333333");
    //WidgetsFlutterBinding.ensureInitialized();
    print(appData.androidID);
    int timestamp = DateTime.now().millisecondsSinceEpoch; //gets timestamp
    print("timestamp: $timestamp");
    //appData.pair = generateRSAkeyPair(exampleSecureRandom());
    //appData.public = appData.pair.publicKey as RSAPublicKey;
    //appData.private = appData.pair.privateKey as RSAPrivateKey;
    Map<String, Object> jsonObj = {
      "dev_type": 0,
      "device_id": appData.androidID,
      "timestamp": timestamp,
      "public_key": _crypto.getMyPublicKey(),
    };
    final json = convert.jsonEncode(jsonObj);
    Uint8List list = _crypto.server_encrypt(json);
    String msg = convert.base64Encode(list);
    //String unencrypted_msg =
    //    '{"dev_type":0,"device_id":"${appData.androidID}","timestamp":${timestamp},"public_key":"${appData.public}"}'; //create unencrypted message

    //builder.addString(
    //    '{"dev_type":0,"device_id":"${appData.androidID}","timestamp":${timestamp},"public_key":"${appData.public}"}');
    builder.addString(msg);
    client.publishMessage(topic2, MqttQos.exactlyOnce, builder.payload!);
    print("published");
  }
}
