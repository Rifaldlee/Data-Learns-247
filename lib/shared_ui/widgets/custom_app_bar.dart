import 'package:flutter/material.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? content;
  final Widget? trailing;
  final bool showBackButton;
  final Color? backgroundColor;
  final Function()? backAction;
  final String? title;

  const CustomAppBar({
    super.key,
    this.leading,
    this.content,
    this.trailing,
    required this.showBackButton,
    this.backgroundColor = kWhiteColor,
    this.backAction,
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: backgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBackButton)
              GestureDetector(
                onTap: backAction ?? () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.keyboard_backspace,
                    size: 32,
                  ),
                ),
              ),
            if (title != null)
              Container(
                padding: const EdgeInsets.only(right: 16),
                decoration: DottedDecoration(
                  shape: Shape.line,
                  linePosition: LinePosition.bottom,
                  color: kBlackColor
                ),
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: bold,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: leading ?? const SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: content ?? const SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: trailing ?? const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(56);
}