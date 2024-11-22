import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:shimmer/shimmer.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/shared_ui/screens/image_view_screen.dart';

class HtmlContentParser {
  static Widget parseHtml({
    required dom.Element element,
    required BuildContext context,
    EdgeInsets? padding
  }) {
    if (element.text.trim().isEmpty) {
      return const SizedBox();
    }
    switch (element.localName) {
      case 'h1':
        return Padding(
          padding: (padding == null) ? const EdgeInsets.only(top: 25) : padding,
          child: Text(
            element.text.trim(),
            style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: kBlackColor)
          ),
        );

      case 'h2':
        return Padding(
          padding: (padding == null) ? const EdgeInsets.only(top: 25) : padding,
          child: Text(
            element.text.trim(),
            style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: kBlackColor, fontSize: 21)
          ),
        );

      case 'h3':
        return Padding(
          padding: (padding == null) ? const EdgeInsets.only(top: 25) : padding,
          child: Text(
            element.text.trim(),
            style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: kBlackColor, fontSize: 18)
          ),
        );

      case 'p':
        {
          var strongElem = element.getElementsByTagName('strong');
          String pContent = element.text;
          if (strongElem.isNotEmpty) {
            for (var element in strongElem) {
              pContent = pContent.replaceAll(element.text, '|*${element.text}*|');
            }
            List<TextSpan> textSpans = List.empty(growable: true);
            pContent.split('|').forEach((splittedText) {
              if (splittedText.contains('*')) {
                textSpans.add(TextSpan(
                  text: splittedText.replaceAll('*', ''),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: kBlackColor,
                    fontSize: 16,
                    fontWeight: bold,
                    height: 2
                  )
                ));
              } else {
                //apply regular text style
                textSpans.add(
                  TextSpan(
                    text: splittedText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: kBlackColor,
                      fontSize: 18,
                      height: 1.6
                    )
                  )
                );
              }
            });
            //Text with different style
            return Text.rich(
              TextSpan(children: textSpans),
              textAlign: TextAlign.justify
            );
          }
          return Padding(
            padding: (padding == null) ? const EdgeInsets.only(top: 16) : padding,
            child: Text(pContent.trim(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: kBlackColor,
              fontSize: 18,
              height: 1.6
            ),
            textAlign: TextAlign.start
            ),
          );
        }

      case 'ul':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: element.getElementsByTagName('li').map((li) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\t\u2022",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: kBlackColor,
                    fontSize: 18,
                    height: 1.6
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(li.text.trim(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kBlackColor,
                        fontSize: 18,
                        height: 1.6
                      ),
                      textAlign: TextAlign.start
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );

      case 'ol':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: element.getElementsByTagName('li').asMap().entries.map((entry) {
            int index = entry.key;
            var li = entry.value;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\t${index + 1}.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: kBlackColor,
                    fontSize: 18,
                    height: 1.6
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(li.text.trim(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kBlackColor,
                        fontSize: 18,
                        height: 1.6
                      ),
                      textAlign: TextAlign.start
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );

      case 'figure':
        var img = element.getElementsByTagName('img')[0];
        String src = img.attributes['src']?? '';
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageViewerScreen(imageUrl: src),
              ));
            },
            child: FastCachedImage(
              url: src,
              fit: BoxFit.fitWidth,
              fadeInDuration: const Duration(seconds: 0),
              loadingBuilder: (context, progress) {
                return Shimmer.fromColors(
                  baseColor: kShimmerBaseColor,
                  highlightColor: kShimmerHighligtColor,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                  )
                );
              }
            ),
          ),
        );

      case 'figcaption':
        return Padding(
          padding: (padding == null) ? const EdgeInsets.only(top: 12) : padding,
          child: Center(
            child: Text(
              element.text.trim(),
              style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: kLightGreyColor),
              textAlign: TextAlign.center,
            ),
          ),
        );

      case 'code':
      case 'pre':
        {
          ScrollController scrollController = ScrollController();
          return Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: kCodeBackgroundColor,
                border: Border.all(color: kLightGreyColor)
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                child: Text(
                  element.text,
                  style: GoogleFonts.sourceCodePro(
                    color: kBlackColor, fontSize: 14),
                ),
              ),
            ),
          );
        }

      case 'span':
        if (element.classes.contains('lifterlms-price')) {
          return Text(
            element.text.trim(),
            style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: kBlackColor)
          );
        }

      case 'div':
        if (element.classes.contains('llms-meta-info')) {
          var metaTitle = element.getElementsByTagName('h3').where((h3) => h3.classes.contains('llms-meta-title'));
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              metaTitle.first.text.trim(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                color: kBlackColor,
                fontWeight: bold,
              ),
            ),
          );
        }

        else if (element.classes.contains('llms-meta llms-difficulty')) {
          var metaDifficulty = element.getElementsByTagName('p');
          return Padding(
            padding: (padding == null) ? const EdgeInsets.only(top: 16) : padding,
            child: Text(metaDifficulty.first.text.trim(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: kBlackColor,
                  fontSize: 18,
                  height: 1.6
                ),
                textAlign: TextAlign.start
            ),
          );
        }

        else if (element.classes.contains('llms-categories')) {
          return Padding(
            padding: padding ?? const EdgeInsets.only(top: 8),
            child: parseHtml(
                element: element.children.first,
                context: context
            ),
          );
        }
        return const SizedBox();
    }
    return const SizedBox();
  }
}