import 'package:flutter/material.dart';

class LineNumberGutter extends StatelessWidget {
  final int lineCount;
  final ScrollController scrollController;
  final double fontSize;
  final double lineHeight;
  final bool isDarkMode;

  const LineNumberGutter({
    super.key,
    required this.lineCount,
    required this.scrollController,
    this.fontSize = 14.0,
    this.lineHeight = 1.5,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    // Generate line numbers string: " 1\n 2\n 3\n..."
    final linesText = List.generate(lineCount, (index) => '${index + 1}').join('\n');

    return Container(
      width: (lineCount > 999 ? 56.0 : (lineCount > 99 ? 44.0 : 36.0)),
      color: isDarkMode ? const Color(0xFF181C24) : const Color(0xFFE2E8F0),
      alignment: Alignment.topRight,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const NeverScrollableScrollPhysics(), // Driven by main editor scroll
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Text(
            linesText,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: fontSize,
              height: lineHeight,
              color: isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
