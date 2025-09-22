import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeBlockWidget extends StatelessWidget {
  final String text;
  final ScrollController _scrollController = ScrollController();

  CodeBlockWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E), // dark background
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mac-style window buttons
              const Row(
                children: [
                  CircleAvatar(radius: 6, backgroundColor: Color(0xFFFF5F56)), // red
                  SizedBox(width: 6),
                  CircleAvatar(radius: 6, backgroundColor: Color(0xFFFFBD2E)), // yellow
                  SizedBox(width: 6),
                  CircleAvatar(radius: 6, backgroundColor: Color(0xFF27C93F)), // green
                ],
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: text,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}