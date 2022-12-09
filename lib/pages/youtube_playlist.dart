import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:centerfascia_application/pages/youtube_playlist/youtube_playlist_selected.dart';

class YoutubePlaylist extends StatefulWidget {
  const YoutubePlaylist({Key? key}) : super(key: key);

  @override
  State<YoutubePlaylist> createState() => _YoutubePlaylistState();
}
var json;
class _YoutubePlaylistState extends State<YoutubePlaylist> {
  late String videoTitle;
  List<dynamic>? urllist = [];


  final List<String> playlistUrl = [
    'PLaPiTr4kM_as6id1T0twAY5S5xt8-B_q6',
    'PL6dFf0WniYfKIF9GVcLyiOCrz_u5Ulq62',
    'PLpF9ZVTtb3m6jjmGShxr6tGiXzZ3RSTni',
  ];

  final List<String> playlistTitle = [
    '기분이 좋아지는 플레이리스트',
    '편안하게 들을 수 있는 플레이리스트',
    '드라이브할 때 듣는 신나는 플레이리스트',
  ];
  final List<String> _videoUrlList = [
    'https://youtu.be/dWs3dzj4Wng',
    'https://www.youtube.com/watch?v=668nUCeBHyY',
    'https://youtu.be/S3npWREXr8s',
    'https://www.youtube.com/watch?v=90huos_0lVw',
  ];

  final List<String> _videoUrlListTmp = [
    'https://www.youtube.com/watch?v=u6HihlihBp0',
    'https://www.youtube.com/watch?v=pDqsXkfc8_0',
    'https://www.youtube.com/watch?v=K6BRna4_bmg',
    'https://www.youtube.com/watch?v=7rFtdZv4AZY',
    'https://youtu.be/qlcgPoI6h48',
    'https://youtu.be/POYLCr17a-o',
  ];
  late int currVideoNum = 0;

  @override
  void initState()  {

    getPlaylist();
    super.initState();
    fillYTlists(_videoUrlList);
  }

  void getPlaylist(){
    fetchVideos(playlistUrl[0], 20);
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
            _ytController.load(_id, startAt: 0);
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

  void changeCurrentPlaylist(){
    print("handle tap events\n");
    for (int k = 0; k < lYTC.length; k++) {
      final id = YoutubePlayer.convertUrlToId(_videoUrlListTmp[k]);
      lYTC[k].load(id!, startAt: 0);
    }
    for(int k = lYTC.length; k < _videoUrlListTmp.length; k++){

    }
    YoutubePlaylistSelected(cStates, lYTC, _videoUrlList);
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
                    itemCount: playlistUrl.length,
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

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Image.network('${imgurl[index]}'),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Text("${playlistTitle[index]}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: Colors.blue,
                                            fontSize: 17.0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
                                        child: Text("유튜브 재생목록",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(color: Colors.white54,
                                                fontSize: 15.0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
                                        child: Text("www.youtube.com/list=${playlistUrl[index]}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: Colors.white12,
                                              fontSize: 13.0)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              onTap: () {
                                setState(() {
                                  fetchVideos(playlistUrl[index], 20);
                                  print("<<<< index : $index >>>>>>>");
                                  _videoUrlList.clear();
                                  for(int s = 0 ; s < 20 ; s ++){
                                    _videoUrlList.add("https://youtu.be/${jsonResponse['items'][s]['snippet']['resourceId']['videoId']}");
                                  }
                                  print(_videoUrlList);
                                  fillYTlists(_videoUrlList);

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
