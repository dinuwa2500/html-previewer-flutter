class HtmlBeautifier {
  static const Set<String> _voidTags = {
    'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input',
    'link', 'meta', 'param', 'source', 'track', 'wbr', '!doctype'
  };

  static String format(String html) {
    if (html.trim().isEmpty) return html;

    final buffer = StringBuffer();
    int indentLevel = 0;
    const String indentStr = '  ';

    // Regex to match tags, comments, or non-tag text
    final regex = RegExp(r'(<!--.*?-->)|(<[^>]+>)|([^<]+)', dotAll: true);
    final matches = regex.allMatches(html);

    for (final match in matches) {
      final token = match.group(0)?.trim() ?? '';
      if (token.isEmpty) continue;

      if (token.startsWith('<!--')) {
        // Comment
        buffer.writeln('${indentStr * indentLevel}$token');
      } else if (token.startsWith('</')) {
        // Closing tag
        indentLevel = (indentLevel - 1).clamp(0, 50);
        buffer.writeln('${indentStr * indentLevel}$token');
      } else if (token.startsWith('<')) {
        // Opening or self-closing tag
        final tagNameMatch = RegExp(r'^<([a-zA-Z0-9!_-]+)').firstMatch(token);
        final tagName = tagNameMatch?.group(1)?.toLowerCase() ?? '';
        final isSelfClosing = token.endsWith('/>') || _voidTags.contains(tagName);

        buffer.writeln('${indentStr * indentLevel}$token');

        if (!isSelfClosing && !tagName.startsWith('!')) {
          indentLevel++;
        }
      } else {
        // Text content
        final lines = token.split('\n');
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty) {
            buffer.writeln('${indentStr * indentLevel}$trimmed');
          }
        }
      }
    }

    final result = buffer.toString().trim();
    return result.isEmpty ? html : result;
  }
}
