import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class TrailerPage extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final trailerurl;
  TrailerPage({Key? key, required this.trailerurl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChewieController _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.network(this.trailerurl),
        autoInitialize: true,
        looping: false,
        autoPlay: true,
        showControls: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
    return Scaffold(
      extendBody: false,
      backgroundColor: Color.fromARGB(255, 26, 0, 70),
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 26, 0, 70)),
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 26, 0, 70),
        toolbarHeight: 50.0,
        titleSpacing: 36.0,
        title: const Text(
          'Trailer',
          style: TextStyle(
              fontSize: 30.0,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Card(
            margin: const EdgeInsets.all(16.0),
            shadowColor: Colors.deepPurple,
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Color.fromARGB(255, 0, 0, 0),
            child: FittedBox(
              fit: BoxFit.fill,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Chewie(
                    controller: _chewieController,
                  )),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2,
            child: InkWell(
              onTap: () {
                _chewieController.dispose();
                _chewieController.videoPlayerController.dispose();
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
