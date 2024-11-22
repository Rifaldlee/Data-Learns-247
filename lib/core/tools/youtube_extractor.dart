import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';

class YoutubeExtractor {
  static String extract({required String content, String attribute = 'src'}){
    final document = parse(content);

    try{
      return document.querySelector('iframe')!.attributes[attribute].toString().splitBetween('embed/', '?');
    } catch(e){
      return "";
    }
  }
}