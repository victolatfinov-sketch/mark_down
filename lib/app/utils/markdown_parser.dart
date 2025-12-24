class MarkdownParser {
  static const String codeBlockPattern = r'```(\w+)?\n([\s\S]*?)```';
  static const String headingPattern = r'^(#{1,6})\s+(.+)$';
  static const String boldPattern = r'\*\*(.+?)\*\*';
  static const String italicPattern = r'\*(.+?)\*';
  static const String inlineCodePattern = r'`(.+?)`';
  static const String linkPattern = r'\[(.+?)\]\((.+?)\)';
  static const String imagePattern = r'!\[(.+?)\]\((.+?)\)';
  static const String unorderedListPattern = r'^[-*+]\s+(.+)$';
  static const String orderedListPattern = r'^\d+\.\s+(.+)$';
  static const String blockquotePattern = r'^>\s+(.+)$';
  static const String horizontalRulePattern = r'^[-*_]{3,}$';
  static const String tablePattern = r'\|(.+)\|';
  static const String mermaidPattern = r'^```mermaid';

  static bool isMermaidCodeBlock(String code) {
    return code.trim().toLowerCase().startsWith('```mermaid');
  }

  static List<String> extractMermaidBlocks(String markdown) {
    final blocks = <String>[];
    final lines = markdown.split('\n');
    bool inBlock = false;
    final currentBlock = StringBuffer();

    for (final line in lines) {
      if (line.trim().startsWith('```mermaid')) {
        if (!inBlock) {
          inBlock = true;
          currentBlock.clear();
        } else {
          blocks.add(currentBlock.toString());
          inBlock = false;
        }
      } else if (inBlock) {
        currentBlock.writeln(line);
      }
    }

    return blocks;
  }

  static String removeMermaidBlocks(String markdown) {
    final lines = markdown.split('\n');
    final result = <String>[];
    bool inBlock = false;

    for (final line in lines) {
      if (line.trim().startsWith('```mermaid')) {
        inBlock = !inBlock;
      } else if (!inBlock) {
        result.add(line);
      }
    }

    return result.join('\n');
  }

  static List<String> splitIntoSections(String markdown) {
    final sections = <String>[];
    final buffer = StringBuffer();
    final lines = markdown.split('\n');

    for (final line in lines) {
      if (line.startsWith('## ')) {
        if (buffer.isNotEmpty) {
          sections.add(buffer.toString().trim());
          buffer.clear();
        }
      }
      buffer.writeln(line);
    }

    if (buffer.isNotEmpty) {
      sections.add(buffer.toString().trim());
    }

    return sections.isNotEmpty ? sections : [markdown];
  }

  static String extractTitle(String markdown) {
    for (final line in markdown.split('\n')) {
      if (line.startsWith('# ')) {
        return line.replaceFirst('# ', '').trim();
      }
    }
    return 'Untitled';
  }

  static int estimateReadingTime(String markdown) {
    const wordsPerMinute = 200;
    final wordCount = markdown.split(RegExp(r'\s+')).length;
    return (wordCount / wordsPerMinute).ceil();
  }
}
