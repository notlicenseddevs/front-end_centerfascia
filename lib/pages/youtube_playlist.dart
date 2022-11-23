import 'package:flutter/material.dart';

class YoutubePlaylist extends StatefulWidget{
  const YoutubePlaylist({Key? key}) : super(key: key);

  @override
  State<YoutubePlaylist> createState() => _YoutubePlaylistState();
}


class _YoutubePlaylistState extends State<YoutubePlaylist>{
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black45,
          centerTitle: true,
          elevation: 0,
          leading: Container(),
          title: Text('youtube_playlist'),
        ),
        body: Container(

        )
    );
  }
}
