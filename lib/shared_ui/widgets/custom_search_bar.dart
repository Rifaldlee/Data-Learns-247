import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final Function()? clear;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.clear,
  });

  @override
  State<CustomSearchBar> createState() {
    return _CustomSearchBarState();
  }
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              onSubmitted: widget.onSubmitted,
              cursorColor: kGreenColor,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return value.text.isNotEmpty ? IconButton(
                onPressed: widget.clear,
                icon: const Icon(Icons.close),
              ) : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}