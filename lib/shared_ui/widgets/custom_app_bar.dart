import 'package:data_learns_247/core/theme/color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? content;
  final Widget? trailing;
  final bool showBackButton;
  final Color? backgroundColor;
  final Function()? backAction;

  const CustomAppBar({
    super.key,
    this.leading,
    this.content,
    this.trailing,
    required this.showBackButton,
    this.backgroundColor = kWhiteColor,
    this.backAction,
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
            if (leading != null)
              Expanded(
                flex: showBackButton ? 3 : 4,
                child: leading!,
              ),
            if (content != null)
              Expanded(
                flex: showBackButton ? 3 : 4,
                child: content!,
              ),
            if (trailing != null)
              Expanded(
                flex: showBackButton ? 3 : 4,
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(56);
}