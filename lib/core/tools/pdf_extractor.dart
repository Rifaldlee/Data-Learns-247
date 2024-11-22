import 'package:html/parser.dart';


class PDFExtractor {
  static String extract({required String content, String className = 'pdfemb-viewer'}) {
    final document = parse(content);

    try {
      final linkElement = document.querySelectorAll('a').firstWhere(
        (element) => element.classes.contains(className),
      );
      return linkElement.attributes['href'] ?? '';
    } catch (e) {
      return "";
    }
  }
}
