import 'dart:async';

import 'package:centerfascia_application/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:centerfascia_application/pages/youtube_playlist/youtube_playlist_selected.dart';
import 'package:centerfascia_application/variables.dart';

// todo 새로고침을 시키는 함수를 정의(MQTT와 별개 , json을 받으면 playlist를 새로 만들어주는)
class YoutubePlaylist extends StatefulWidget {
  const YoutubePlaylist({Key? key}) : super(key: key);

  @override
  State<YoutubePlaylist> createState() => _YoutubePlaylistState();
}

class _YoutubePlaylistState extends State<YoutubePlaylist> {
  mqttConnection mqtt = mqttConnection();
  final List<String> _videoUrlList = [
    'https://www.youtube.com/watch?v=ot_RXb9XJnU',
    'https://www.youtube.com/watch?v=668nUCeBHyY',
    'https://youtu.be/S3npWREXr8s',
    'https://www.youtube.com/watch?v=90huos_0lVw',
  ];
  bool _loaded = false;

  @override
  void initState()  {
    super.initState();
    loadPLData();
  }

  void loadPLData() async{
    String plrequest = '{"cmd_type":4, "refresh_target":1}';
    mqtt.PlaylistRequest(plrequest, getandfillData);

  }

  void getandfillData(Map<String, dynamic> dt){
    print("22222222222222");
    getStreamData(dt);
    getPlaylist();
    fillYTlists(_videoUrlList);
  }

  void getStreamData(Map<String, dynamic> v) {
    String id;
    String playlistName;
    String playlistUrl;
    appData.playlist.removeRange(2, appData.playlist.length);
    print('deleted the playlist');
    setState((){});
    print('Youtube Playlist listen Started');
    for(int k=0;k<v['playlist'].length;k++) {
      id = v['playlist'][k]['_id'];
      playlistName = v['playlist'][k]['name'];
      playlistUrl = v['playlist'][k]['url'];
      appData.playlist.add(
          {'_id': id, 'name': playlistName, 'url': playlistUrl});
    }
    setPlaylist(0);
    print(v);
    }

  void getPlaylist() async{
    await fetchVideos(appData.playlist[0]['url']?.substring(34), 20);
    print("#TEST : appData");
    print(appData.playlist);
    print("#TEST : _id");
    print(appData.playlist[0]['url']?.substring(34));
    print("#TEST : response");
    print(jsonResponse);
    for(int s = 0 ; s < 20 ; s ++){
      _videoUrlList.add("https://youtu.be/${jsonResponse['items'][s]['snippet']['resourceId']['videoId']}");
    }
  }
  void setPlaylist(int index) async{
    await fetchVideos(appData.playlist[index]['url']?.substring(34), 20);
    print("<<<< index : $index >>>>>>>");
    _videoUrlList.clear();
    for(int s = 0 ; s < 20 ; s ++){
      _videoUrlList.add("https://youtu.be/${jsonResponse['items'][s]['snippet']['resourceId']['videoId']}");
    }
    print(_videoUrlList[0]);
    print(YoutubePlayer.convertUrlToId(_videoUrlList[0]));
    fillYTlists(_videoUrlList);
    print(lYTC[0].initialVideoId);
    print('222222222222222');
    lYTC[0].load(YoutubePlayer.convertUrlToId(_videoUrlList[0])!, startAt: 0);
  }

  List<YoutubePlayerController> lYTC = [];

  Map<String, dynamic> cStates = {};

  fillYTlists(List<String> _videoUrlList) {
    lYTC.clear();
    cStates.clear();
    String _id = YoutubePlayer.convertUrlToId(_videoUrlList[0])!;
    YoutubePlayerController _ytController = YoutubePlayerController(
      initialVideoId: _id,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: true,
        captionLanguage: 'en',
      ),
    );

    _ytController.addListener(() {
      if (cStates[_id] != _ytController.value.isPlaying) {
      if (mounted) {
        setState(() {
          cStates[_id] = _ytController.value.isPlaying;
        });
      }
    }});
    lYTC.add(_ytController);
    _loaded = true;
  }
  late List<YoutubePlayer> YoutubePlayerList;
  @override
  void dispose() {
    for (var element in lYTC) {
      element.dispose();
    }
    super.dispose();
  }

  Widget MainPL(){
    return Scaffold(
      body: Row(
        children: [
          Container(
            alignment: Alignment.topRight,
            color: Colors.black87,
            width: 480.0,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: appData.playlist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index)  {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(children: [
                          Container(
                            height: 100.0,
                            width: 440.0,
                            decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(

                              child: Container(
                                width:430.0,
                                height: 100.0,
                                decoration: const BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: const BorderRadius.all(Radius.circular(12))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Image.network('${imgurl[index]}'),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8,8,8,8),
                                          child: Text("${appData.playlist[index]['name']}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(6, 4, 8, 8),
                                          child: Text("유튜브 재생목록",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(color: Colors.white54,
                                                  fontSize: 15.0)),
                                        ),
                                        Container(
                                          width: 430.0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(6, 2, 6, 6),
                                            child: Text("${appData.playlist[index]['url']}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(color: Colors.white12,
                                                    fontSize: 13.0)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {

                                setPlaylist(index);
                                print('############### url index : $index / ${YoutubePlayer.convertUrlToId(_videoUrlList[0])}');

                                setState(() {
                                });
                              },
                            ),
                          ),
                        ]),
                      );
                    })),
          ),
          Container(
              child: _loaded? YoutubePlaylistSelected(cStates, lYTC, _videoUrlList):CircularProgressIndicator()),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return _loaded? MainPL():Container(child:CircularProgressIndicator());
  }
}
