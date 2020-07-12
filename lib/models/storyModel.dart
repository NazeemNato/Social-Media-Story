import 'package:socialMedia_stories/enum/mediaType.dart';
import 'package:socialMedia_stories/models/userMode.dart';

class Story {
  final String url;
  final MediaType type;
  final Duration duration;
  final User user;

  Story({this.url, this.type, this.duration, this.user});
}
