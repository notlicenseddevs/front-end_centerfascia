import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:centerfascia_application/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
];
YoutubePlayerController? _ytController;
Future _future() async {
  await Future.delayed(Duration(milliseconds: 1400));
  return 'WW';
}

Widget YoutubePlaylistSelected(Map cStates, List<YoutubePlayerController> lYTC,
    List<String> _videoUrlList) {
  print("enter playlist select\n");
  print("${lYTC[0].initialVideoId}");
  _ytController = lYTC[0];
  String _id = YoutubePlayer.convertUrlToId(_videoUrlList[0])!;
  String curState = 'undefined';
  if (cStates[_id] != null) {
    curState = cStates[_id] ? 'playing' : 'paused';
  }
  print("lYTC[0] values >");
  print(lYTC[0]);
  print("cstates values >");
  print(cStates);
  return Container(
    width: 475.0,
    child: FutureBuilder(
      future: _future(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

      if(snapshot.hasData == false){
        return CircularProgressIndicator();
      }else {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 220.0,
                    decoration: const BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: YoutubePlayer(
                        controller: _ytController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.lightBlueAccent,
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          FullScreenButton(),
                        ],
                        onReady: () {
                          print('onReady for ');
                        },
                        onEnded: (YoutubeMetaData _md) {
                          // 끝나고 다음 영상 재생
                          lYTC[0].reset();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 270.0,
                width: 465.0,
                child: ListView.builder(
                  itemCount: lYTC.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print(
                        "title : ${jsonResponse['items'][index]['snippet']['title']}");
                    print(
                        "img url ${jsonResponse['items'][index]['snippet']['thumbnails']
                        ['default']}");
                    if ("${jsonResponse['items'][index]['snippet']['title']}"
                        != "Private video") {
                      if (index != 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Image.network(
                                  "${jsonResponse['items'][index]['snippet']['thumbnails']['default']['url']}"),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 335.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            "${jsonResponse['items'][index]['snippet']['title']}",
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0)),
                                      ),
                                    ),
                                    Container(
                                      width: 335.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            "www.youtube.com/watch?v=${jsonResponse['items'][index]['snippet']['resourceId']['videoId']}",
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 15.0)),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        );
                      }
                      else {
                        return Container(

                        );
                      }
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(0.0),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      }
      },
    ),
  );
}

var jsonResponse;
Future<void> fetchVideos(String playlistLink, int itemNum) async {
  String url =
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key=$API_KEY&maxResults=$itemNum&playlistId=$playlistLink';

  final response = await http.get(Uri.parse(url));
  jsonResponse = convert.jsonDecode(response.body);
  //print(jsonResponse[0]);
  //print(jsonResponse[0]['items'][0]['snippet']['resourceId']);
  //imgurl.add(jsonResponse[index]['items'][0]['snippet']['thumbnails']['high']['url']);
  //playlistname.add(jsonResponse[index]['items'][0]['snippet']['playlistId']);
  //playlistfirstsong.add(jsonResponse[index]['items'][0]['snippet']['resourceId']['videoId']);
}
