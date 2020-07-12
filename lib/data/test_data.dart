import 'package:socialMedia_stories/enum/mediaType.dart';
import 'package:socialMedia_stories/models/storyModel.dart';
import 'package:socialMedia_stories/models/userMode.dart';

final User user = User(
  name: 'SpongeBob',
);
Duration _durationImage = Duration(seconds: 10);
List<Story> stories = [
  Story(
    duration: _durationImage,
    type: MediaType.image,
    url: 'https://suzphx.files.wordpress.com/2014/01/spongebob-wallpaper-spongebob-squarepants-16205104-1024-768.jpg',
    user: user
  ),Story(
    duration: _durationImage,
    type: MediaType.image,
    url: 'https://cutekawaiiresources.files.wordpress.com/2013/07/2.jpg',
    user: user
  ),Story(
    url:
        'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
    type: MediaType.video,
    duration: const Duration(seconds: 0),
    user: user
  ),Story(
    duration: _durationImage,
    type: MediaType.image,
    url: 'https://cutekawaiiresources.files.wordpress.com/2013/07/15.jpg',
    user: user
  )
];
