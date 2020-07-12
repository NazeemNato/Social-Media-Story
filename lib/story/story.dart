import 'package:flutter/material.dart';
import 'package:socialMedia_stories/enum/mediaType.dart';
import 'package:socialMedia_stories/data/test_data.dart';
import 'package:socialMedia_stories/models/storyModel.dart';
import 'package:socialMedia_stories/widget/storyBar.dart';
// import 'package:socialMedia_stories/models/userMode.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryScreen extends StatefulWidget {
  StoryScreen({Key key}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  AnimationController _animationController;
  VideoPlayerController _videoPlayerController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    final Story firstStory = stories.first;
    loadStory(story: firstStory, toPage: false);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_index + 1 < stories.length) {
            _index += 1;
            loadStory(story: stories[_index]);
          } else {
            _index = 0;
            loadStory(story: stories[_index]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = stories[_index];
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) => userTapDown(details, story),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final Story story = stories[index];
                switch (story.type) {
                  case MediaType.image:
                    return CachedNetworkImage(
                        imageUrl: story.url, fit: BoxFit.cover);
                  case MediaType.video:
                    if (_videoPlayerController != null &&
                        _videoPlayerController.value.initialized) {
                      return FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                            width: _videoPlayerController.value.size.width,
                            height: _videoPlayerController.value.size.height,
                            child: VideoPlayer(_videoPlayerController)),
                      );
                    }
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
                top: 40.0,
                left: 10.0,
                right: 10.0,
                //Add Column when you add user info
                child: Row(
                  children: stories
                      .asMap()
                      .map((key, value) => MapEntry(
                          key,
                          StoryBar(
                            animController: _animationController,
                            position: key,
                            currentIndex: _index,
                          )))
                      .values
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }

  void userTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(() {
        if (_index - 1 >= 0) {
          _index -= 1;
          loadStory(story: stories[_index]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_index + 1 < stories.length) {
          _index += 1;
          loadStory(story: stories[_index]);
        } else {
          _index = 0;
          loadStory(story: stories[_index]);
        }
      });
    } else {
      if (story.type == MediaType.video) {
        if (_videoPlayerController.value.isPlaying) {
          _videoPlayerController.pause();
          _animationController.stop();
        } else {
          _videoPlayerController.play();
          _animationController.forward();
        }
      }
    }
  }

  void loadStory({Story story, bool toPage = true}) {
    _animationController.stop();
    _animationController.reset();

    switch (story.type) {
      case MediaType.image:
        _animationController.duration = story.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        _videoPlayerController = null;
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.network(story.url)
          ..initialize().then((_) {
            setState(() {});
            if (_videoPlayerController.value.initialized) {
              _videoPlayerController.play();
              _animationController.forward();
            }
          });

        break;
    }
    if (toPage) {
      _pageController.animateToPage(
        _index,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}
