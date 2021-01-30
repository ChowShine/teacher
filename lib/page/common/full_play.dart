//全屏播放
// import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFullPage extends StatefulWidget {
  final String url;
  VideoFullPage(this.url);
  @override
  _VideoFullState createState() => _VideoFullState();
}

class _VideoFullState extends State<VideoFullPage> {
  VideoPlayerController _controller;
  void checkIfVideoFinished() {
    print("播放时间秒：${_controller.value.position.inSeconds}");
    print("总时间秒：${_controller.value.duration?.inSeconds}");
    print("总时间分钟：${_controller.value.duration?.inMinutes}");
    if (_controller == null ||
        _controller.value == null ||
        _controller.value.position == null ||
        _controller.value.duration == null) return;
    if (_controller.value.position.inSeconds == _controller.value.duration.inSeconds) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _controller.pause();
        });
        _controller.seekTo(Duration.zero);
      });
      print("播放结束");
    }
  }

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        //widget.second = _controller.value.duration.inSeconds;
       if(mounted) setState(() {});
      });
    _controller.addListener(checkIfVideoFinished);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Center(
              child: Hero(
                tag: "full screen player",
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        _controller.value.initialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              )
                            : Container(),
                        Center(
                          child: Icon(
                            !_controller.value.isPlaying ? Icons.play_circle_outline : Icons.pause_circle_outline,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, right: 20),
              child: IconButton(
                icon: const BackButtonIcon(),
                color: Colors.white,
                iconSize: 40.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller.value.isPlaying) _controller.pause();
    _controller.dispose();
    _controller.removeListener(checkIfVideoFinished);
  }
}
