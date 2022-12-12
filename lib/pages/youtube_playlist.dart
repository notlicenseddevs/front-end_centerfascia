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
var json;
class _YoutubePlaylistState extends State<YoutubePlaylist> {
  late String videoTitle;

  final List<String> _videoUrlList = [
    'https://www.youtube.com/watch?v=ot_RXb9XJnU',
    'https://www.youtube.com/watch?v=668nUCeBHyY',
    'https://youtu.be/S3npWREXr8s',
    'https://www.youtube.com/watch?v=90huos_0lVw',
  ];
  late int currVideoNum = 0;

  @override
  void initState()  {
    getPlaylist();
    super.initState();
    fillYTlists(_videoUrlList);
  }

  void getPlaylist() async{
    print(YoutubePlayer.convertUrlToId(appData.playlist[0]['url']!).toString());
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
  void abcd(int index) async{
    await fetchVideos(appData.playlist[index]['url']?.substring(34), 20);
    print("<<<< index : $index >>>>>>>");
    _videoUrlList.clear();
    for(int s = 0 ; s < 20 ; s ++){
      _videoUrlList.add("https://youtu.be/${jsonResponse['items'][s]['snippet']['resourceId']['videoId']}");
    }
    print(_videoUrlList);
    print(YoutubePlayer.convertUrlToId(_videoUrlList[0]));
    lYTC[0].load(YoutubePlayer.convertUrlToId(_videoUrlList[0])!, startAt: 0);
    fillYTlists(_videoUrlList);
    print(lYTC[0].initialVideoId);
  }

  List<YoutubePlayerController> lYTC = [];

  Map<String, dynamic> cStates = {};

  fillYTlists(List<String> _videoUrlList) {
    lYTC.clear();
    cStates.clear();
    for (var element in _videoUrlList) {
      String _id = YoutubePlayer.convertUrlToId(element)!;
      YoutubePlayerController _ytController = YoutubePlayerController(
        initialVideoId: _id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          enableCaption: true,
          captionLanguage: 'en',
        ),
      );

      _ytController.addListener(() {
        print('for $_id got isPlaying state ${_ytController.value.isPlaying}');
        if (cStates[_id] != _ytController.value.isPlaying) {
        if (mounted) {
          setState(() {
            cStates[_id] = _ytController.value.isPlaying;
          });
        }
      }});

      lYTC.add(_ytController);
    }
  }
  late List<YoutubePlayer> YoutubePlayerList;
  @override
  void dispose() {
    for (var element in lYTC) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Row(
        children: [
          Container(
            alignment: Alignment.topRight,
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
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(

                              child: Container(
                                width:430.0,
                                height: 100.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Image.network('${imgurl[index]}'),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(4,4,4,4),
                                          child: Text("${appData.playlist[index]['name']}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
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
                                            padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
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
                                setState(() {
                                  abcd(index);
                                });
                              },
                            ),
                          ),
                        ]),
                      );
                    })),
          ),
          YoutubePlaylistSelected(cStates, lYTC, _videoUrlList),
        ],
      ),
    );
  }
}
