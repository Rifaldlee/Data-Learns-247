import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:data_learns_247/features/article/data/models/list_link_model.dart';

class LinkArticleItem extends StatelessWidget {
  final ListLink listLink;
  final Function() onTap;

  const LinkArticleItem({super.key, required this.listLink, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  listLink.title!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  listLink.image!,
                  height: 64,
                  width: 64,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}