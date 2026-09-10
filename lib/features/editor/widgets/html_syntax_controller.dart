import 'package:flutter/material.dart';

class HtmlSyntaxTextEditingController extends TextEditingController {
  bool isDarkMode = true;
  String searchQuery = '';
  int activeSearchIndex = -1;
  List<TextRange> searchMatches = [];

  HtmlSyntaxTextEditingController({
    super.text,
    this.isDarkMode = true,
  });

  void updateSearch(String query, int activeIndex) {
    searchQuery = query;
    activeSearchIndex = activeIndex;
    _computeSearchMatches();
    notifyListeners();
  }

  void _computeSearchMatches() {
    searchMatches.clear();
    if (searchQuery.isEmpty || text.isEmpty) return;

    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    int startIndex = 0;

    while (startIndex < lowerText.length) {
      final index = lowerText.indexOf(lowerQuery, startIndex);
      if (index == -1) break;
      searchMatches.add(TextRange(start: index, end: index + lowerQuery.length));
      startIndex = index + lowerQuery.length;
    }
  }

  @override
  set text(String newText) {
    super.text = newText;
    _computeSearchMatches();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (text.isEmpty) {
      return TextSpan(text: '', style: style);
    }

    final baseStyle = style ?? const TextStyle(fontFamily: 'monospace');

    // Syntax colors tailored for Dark / Light themes
    final commentStyle = baseStyle.copyWith(
      color: isDarkMode ? const Color(0xFF6A9955) : const Color(0xFF008000),
      fontStyle: FontStyle.italic,
    );
    final tagStyle = baseStyle.copyWith(
      color: isDarkMode ? const Color(0xFF569CD6) : const Color(0xFF0000FF),
      fontWeight: FontWeight.w600,
    );
    final attrStyle = baseStyle.copyWith(
      color: isDarkMode ? const Color(0xFF9CDCFE) : const Color(0xFF001080),
    );
    final stringStyle = baseStyle.copyWith(
      color: isDarkMode ? const Color(0xFFCE9178) : const Color(0xFFA31515),
    );
    final keywordStyle = baseStyle.copyWith(
      color: isDarkMode ? const Color(0xFFC586C0) : const Color(0xFFAF00DB),
      fontWeight: FontWeight.w600,
    );
    final numberStyle = baseStyle.copyWith(
      color: isDarkMode ? const Color(0xFFB5CEA8) : const Color(0xFF098658),
    );
    final searchHighlightStyle = baseStyle.copyWith(
      backgroundColor: const Color(0x66F59E0B),
      color: isDarkMode ? Colors.white : Colors.black,
    );
    final activeSearchHighlightStyle = baseStyle.copyWith(
      backgroundColor: const Color(0xFFEAB308),
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    // If search is active, we can overlay search matches
    // First, tokenize the text
    final List<_Token> tokens = _tokenize(text);

    final List<TextSpan> spans = [];

    for (final token in tokens) {
      TextStyle tokenStyle;
      switch (token.type) {
        case _TokenType.comment:
          tokenStyle = commentStyle;
          break;
        case _TokenType.tag:
          tokenStyle = tagStyle;
          break;
        case _TokenType.attribute:
          tokenStyle = attrStyle;
          break;
        case _TokenType.string:
          tokenStyle = stringStyle;
          break;
        case _TokenType.keyword:
          tokenStyle = keywordStyle;
          break;
        case _TokenType.number:
          tokenStyle = numberStyle;
          break;
        case _TokenType.plain:
          tokenStyle = baseStyle;
          break;
      }

      // Check if this token intersects with search matches
      if (searchMatches.isEmpty) {
        spans.add(TextSpan(text: token.text, style: tokenStyle));
      } else {
        spans.addAll(_highlightTokenWithSearch(
          token,
          tokenStyle,
          searchHighlightStyle,
          activeSearchHighlightStyle,
        ));
      }
    }

    return TextSpan(children: spans, style: baseStyle);
  }

  List<TextSpan> _highlightTokenWithSearch(
    _Token token,
    TextStyle tokenStyle,
    TextStyle searchStyle,
    TextStyle activeSearchStyle,
  ) {
    final List<TextSpan> result = [];
    final tokenStart = token.start;
    final tokenEnd = token.end;

    int currentPos = tokenStart;

    for (int i = 0; i < searchMatches.length; i++) {
      final match = searchMatches[i];
      if (match.end <= tokenStart || match.start >= tokenEnd) continue;

      // Part before match
      if (match.start > currentPos) {
        final prefix = text.substring(currentPos, match.start);
        result.add(TextSpan(text: prefix, style: tokenStyle));
        currentPos = match.start;
      }

      // Overlapping match part
      final matchStart = match.start < currentPos ? currentPos : match.start;
      final matchEnd = match.end > tokenEnd ? tokenEnd : match.end;

      if (matchStart < matchEnd) {
        final matchText = text.substring(matchStart, matchEnd);
        final style = (i == activeSearchIndex) ? activeSearchStyle : searchStyle;
        result.add(TextSpan(text: matchText, style: style));
        currentPos = matchEnd;
      }
    }

    // Trailing part of token
    if (currentPos < tokenEnd) {
      result.add(TextSpan(text: text.substring(currentPos, tokenEnd), style: tokenStyle));
    }

    return result.isEmpty ? [TextSpan(text: token.text, style: tokenStyle)] : result;
  }

  List<_Token> _tokenize(String src) {
    final List<_Token> list = [];

    // Combined regex for HTML, attributes, strings, comments, numbers, keywords
    final regex = RegExp(
      r'(<!--[\s\S]*?-->)|' // Comment
      r'(<!DOCTYPE[^>]*>)|' // Doctype
      r'(<\/?[a-zA-Z0-9:-]+)|' // Tag name
      r'''("[^"]*"|'[^']*')|''' // Quoted string
      r'([a-zA-Z0-9_-]+)(?=\s*=)|' // Attribute name
      r'(\b\d+(\.\d+)?(px|em|rem|%|s|ms|vh|vw)?\b)|' // Number or unit
      r'(\b(?:function|var|let|const|return|if|else|for|while|try|catch|true|false|null|undefined|document|window|alert|new|this)\b)|' // Keywords
      r'(>|\/>)|' // Tag close
      r'''([^\s<"\'=]+)|''' // Word
      r'(\s+)', // Whitespace
      multiLine: true,
    );

    int lastIndex = 0;
    for (final match in regex.allMatches(src)) {
      if (match.start > lastIndex) {
        list.add(_Token(
          text: src.substring(lastIndex, match.start),
          type: _TokenType.plain,
          start: lastIndex,
          end: match.start,
        ));
      }

      final matchedText = match.group(0)!;
      _TokenType type = _TokenType.plain;

      if (match.group(1) != null || match.group(2) != null) {
        type = _TokenType.comment;
      } else if (match.group(3) != null || match.group(8) != null) {
        type = _TokenType.tag;
      } else if (match.group(4) != null) {
        type = _TokenType.string;
      } else if (match.group(5) != null) {
        type = _TokenType.attribute;
      } else if (match.group(6) != null) {
        type = _TokenType.number;
      } else if (match.group(7) != null) {
        type = _TokenType.keyword;
      }

      list.add(_Token(
        text: matchedText,
        type: type,
        start: match.start,
        end: match.end,
      ));
      lastIndex = match.end;
    }

    if (lastIndex < src.length) {
      list.add(_Token(
        text: src.substring(lastIndex),
        type: _TokenType.plain,
        start: lastIndex,
        end: src.length,
      ));
    }

    return list;
  }
}

enum _TokenType {
  plain,
  comment,
  tag,
  attribute,
  string,
  keyword,
  number,
}

class _Token {
  final String text;
  final _TokenType type;
  final int start;
  final int end;

  const _Token({
    required this.text,
    required this.type,
    required this.start,
    required this.end,
  });
}
