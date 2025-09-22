import 'package:data_learns_247/core/tools/html_parser.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class ContentBookScreen extends StatefulWidget {
  final String content;

  const ContentBookScreen({super.key, required this.content});

  @override
  State<ContentBookScreen> createState() {
    return _ContentBookState();
  }
}

class _ContentBookState extends State<ContentBookScreen> {

  @override
  Widget build(BuildContext context) {
    final document = parse(widget.content);
    var descriptionElement = document.getElementById('--description');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: descriptionElement!.children.map((child) {
                return HtmlContentParser.parseHtml(element: child, context: context);
              }).whereType<Widget>().toList(),
            ),
          ],
        ),
      ),
    );
  }
}