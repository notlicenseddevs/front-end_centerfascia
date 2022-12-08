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

Widget YoutubePlaylistSelected (Map cStates, List<YoutubePlayerController> lYTC, List<String> _videoUrlList){
  print("enter playlist select\n");
  print("${lYTC[0].initialVideoId}");
  return Container(
    width: 480.0,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
          child : ListView.builder(
              itemCount: lYTC.length,

          shrinkWrap: true,
          itemBuilder: (context, index) {
            YoutubePlayerController _ytController = lYTC[index];
            String _id =
            YoutubePlayer.convertUrlToId(_videoUrlList[index])!;
            String curState = 'undefined';
            if (cStates[_id] != null) {
              curState = cStates[_id] ? 'playing' : 'paused';
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      borderRadius:
                      const BorderRadius.all(Radius.circular(12)),
                      child: YoutubePlayer(
                        controller: lYTC[index],
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.lightBlueAccent,
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          FullScreenButton(),
                        ],
                        onReady: () {
                          print('onReady for $index');
                        },
                        onEnded: (YoutubeMetaData _md) { // 끝나고 다음 영상 재생
                          lYTC[0].reset();
                          if(index == (lYTC.length - 1)){
                            lYTC[0].seekTo(const Duration(seconds: 0));}
                          if(index < lYTC.length - 1){
                            lYTC[index+1].play();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    ),
  );
}

var jsonResponse;

Future<void> fetchVideos(String playlistLink, int itemNum) async{
  String url = 'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key=$API_KEY&maxResults=$itemNum&playlistId=$playlistLink';

  final response = await http.get(Uri.parse(url));
    jsonResponse.add(convert.jsonDecode(response.body));
    //print(jsonResponse[0]);
    //print(jsonResponse[0]['items'][0]['snippet']['resourceId']);



}

