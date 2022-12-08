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
  late List<String> imgurl = [];
  late List<String> playlistname =[];
  late List<String> playlistfirstsong =[];


  final List<String> playlistUrl = [
    'PLaPiTr4kM_as6id1T0twAY5S5xt8-B_q6',
    'PL6dFf0WniYfKIF9GVcLyiOCrz_u5Ulq62',
    'PLpF9ZVTtb3m6jjmGShxr6tGiXzZ3RSTni',
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
  Future<void> initState() async {

    await getPlaylist();
    super.initState();
    fillYTlists(_videoUrlList);
  }

  Future<void> getPlaylist() async{
    for(int k=0;k<playlistUrl.length;k++){
      await fetchVideos(playlistUrl[k], 20);
    }
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
        }
      });

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
                      print("<json test print>\n");
                      print(jsonResponse);

                      //imgurl.add(jsonResponse[index]['items'][0]['snippet']['thumbnails']['high']['url']);
                      print("<CP1>");
                      //playlistname.add(jsonResponse[index]['items'][0]['snippet']['playlistId']);
                      print("<CP2>");
                      //playlistfirstsong.add(jsonResponse[index]['items'][0]['snippet']['resourceId']['videoId']);
                      print("<CP3>");
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(children: [
                          Container(
                            height: 100.0,
                            width: 440.0,
                            decoration: const BoxDecoration(
                              color: Color(0xfff5f5f5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //Image.network('${imgurl[index]}'),
                                  Column(
                                    children: [
                                      //Text("${playlistname[index]}",
                                      //style: TextStyle(color: Colors.blue)),
                                      //Text("${playlistfirstsong[index]}"),
                                    ],
                                  ),
                                ],
                              ),

                              onTap: () {
                                setState(() {
                                  //changeCurrentPlaylist();
                                  _videoUrlList.clear();
                                  for(int s = 0 ; s < _videoUrlListTmp.length ; s ++){
                                    _videoUrlList.add(_videoUrlListTmp[s]);
                                  }
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
