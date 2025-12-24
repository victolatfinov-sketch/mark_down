import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:markdown_reader_mvp/app/controllers/markdown_viewer_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';

class MarkdownViewerScreen extends StatelessWidget {
  const MarkdownViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkdownViewerController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Markdown Viewer'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.text_decrease),
                onPressed: controller.decreaseFontSize,
                tooltip: 'Decrease font size',
              ),
              IconButton(
                icon: const Icon(Icons.text_increase),
                onPressed: controller.increaseFontSize,
                tooltip: 'Increase font size',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: controller.refreshFile,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (controller.errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.red.withOpacity(0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: controller.clearError,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : controller.markdownContent.isNotEmpty
                          ? MarkdownViewer(
                              content: controller.markdownContent.value,
                              fontSize: controller.fontSize.value,
                            )
                          : const Center(
                              child: Text('No content to display'),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MarkdownViewer extends StatefulWidget {
  final String content;
  final double fontSize;

  const MarkdownViewer({
    super.key,
    required this.content,
    this.fontSize = 16,
  });

  @override
  State<MarkdownViewer> createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  final WebViewController _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ),
    );

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void didUpdateWidget(MarkdownViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content ||
        oldWidget.fontSize != widget.fontSize) {
      _loadContent();
    }
  }

  void _loadContent() {
    final htmlContent = _generateHtmlContent(widget.content, widget.fontSize);
    _webViewController.loadHtmlString(
      htmlContent,
      baseUrl: 'assets://',
    );
  }

  String _generateHtmlContent(String markdown, double fontSize) {
    final processedMarkdown = _processMermaidBlocks(markdown);
    
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      font-size: ${fontSize}px;
      line-height: 1.6;
      padding: 16px;
      max-width: 800px;
      margin: 0 auto;
      color: #333;
      background-color: #fff;
    }
    @media (prefers-color-scheme: dark) {
      body {
        color: #e0e0e0;
        background-color: #1e1e1e;
      }
    }
    h1, h2, h3, h4, h5, h6 {
      margin-top: 24px;
      margin-bottom: 16px;
      font-weight: 600;
      line-height: 1.25;
    }
    h1 { font-size: 2em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }
    h2 { font-size: 1.5em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }
    h3 { font-size: 1.25em; }
    h4 { font-size: 1em; }
    p { margin: 16px 0; }
    a { color: #0366d6; text-decoration: none; }
    a:hover { text-decoration: underline; }
    code {
      padding: 0.2em 0.4em;
      margin: 0;
      font-size: 85%;
      background-color: rgba(27,31,35,0.05);
      border-radius: 3px;
      font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
    }
    pre {
      padding: 16px;
      overflow: auto;
      font-size: 85%;
      line-height: 1.45;
      background-color: #f6f8fa;
      border-radius: 3px;
      margin: 16px 0;
    }
    @media (prefers-color-scheme: dark) {
      pre { background-color: #2d2d2d; }
    }
    pre code {
      padding: 0;
      background-color: transparent;
    }
    blockquote {
      padding: 0 1em;
      color: #6a737d;
      border-left: 0.25em solid #dfe2e5;
      margin: 16px 0;
    }
    @media (prefers-color-scheme: dark) {
      blockquote { color: #8b949e; border-left-color: #30363d; }
    }
    ul, ol { padding-left: 2em; margin: 16px 0; }
    li { margin: 4px 0; }
    img { max-width: 100%; height: auto; }
    table {
      border-collapse: collapse;
      width: 100%;
      margin: 16px 0;
    }
    table th, table td {
      border: 1px solid #dfe2e5;
      padding: 6px 13px;
      text-align: left;
    }
    table th { background-color: #f6f8fa; font-weight: 600; }
    @media (prefers-color-scheme: dark) {
      table th { background-color: #2d2d2d; }
      table th, table td { border-color: #30363d; }
    }
    .mermaid-container {
      display: flex;
      justify-content: center;
      margin: 24px 0;
      padding: 16px;
      background-color: #f8f9fa;
      border-radius: 8px;
      min-height: 100px;
    }
    @media (prefers-color-scheme: dark) {
      .mermaid-container { background-color: #2d2d2d; }
    }
    hr {
      height: 0.25em;
      padding: 0;
      margin: 24px 0;
      background-color: #e1e4e8;
      border: 0;
    }
    @media (prefers-color-scheme: dark) {
      hr { background-color: #30363d; }
    }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10.6.1/dist/mermaid.min.js"></script>
</head>
<body>
  <div id="content">
    ${_convertMarkdownToHtml(processedMarkdown)}
  </div>
  <script>
    mermaid.initialize({
      startOnLoad: true,
      theme: 'default',
      securityLevel: 'loose',
      fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif'
    });
  </script>
</body>
</html>
''';
  }

  String _processMermaidBlocks(String markdown) {
    final buffer = StringBuffer();
    final lines = markdown.split('\n');
    bool inCodeBlock = false;
    bool isMermaid = false;
    int braceCount = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trim().startsWith('```')) {
        if (!inCodeBlock) {
          inCodeBlock = true;
          final language = line.trim().substring(3);
          isMermaid = language.toLowerCase() == 'mermaid';
          if (isMermaid) {
            buffer.write('<div class="mermaid-container"><pre class="mermaid">\n');
          } else {
            buffer.write('<pre><code>');
          }
        } else {
          if (isMermaid) {
            buffer.write('</pre></div>\n');
          } else {
            buffer.write('</code></pre>\n');
          }
          inCodeBlock = false;
          isMermaid = false;
        }
      } else if (inCodeBlock) {
        if (isMermaid) {
          buffer.write(line);
          buffer.write('\n');
        } else {
          buffer.write(_escapeHtml(line));
          buffer.write('\n');
        }
      } else {
        buffer.write(line);
        buffer.write('\n');
      }
    }

    return buffer.toString();
  }

  String _convertMarkdownToHtml(String markdown) {
    final html = markdown
        .replaceAllMapped(RegExp(r'^### (.+)$', multiLine: true), (match) => '<h3>${match.group(1)}</h3>')
        .replaceAllMapped(RegExp(r'^## (.+)$', multiLine: true), (match) => '<h2>${match.group(1)}</h2>')
        .replaceAllMapped(RegExp(r'^# (.+)$', multiLine: true), (match) => '<h1>${match.group(1)}</h1>')
        .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (match) => '<strong>${match.group(1)}</strong>')
        .replaceAllMapped(RegExp(r'\*(.+?)\*'), (match) => '<em>${match.group(1)}</em>')
        .replaceAllMapped(RegExp(r'`(.+?)`'), (match) => '<code>${match.group(1)}</code>')
        .replaceAllMapped(RegExp(r'\[(.+?)\]\((.+?)\)'), (match) => '<a href="${match.group(2)}">${match.group(1)}</a>')
        .replaceAllMapped(RegExp(r'^- (.+)$', multiLine: true), (match) => '<li>${match.group(1)}</li>')
        .replaceAllMapped(RegExp(r'^\d+\. (.+)$', multiLine: true), (match) => '<li>${match.group(1)}</li>')
        .replaceAllMapped(RegExp(r'^> (.+)$', multiLine: true), (match) => '<blockquote>${match.group(1)}</blockquote>')
        .replaceAllMapped(RegExp(r'---'), (match) => '<hr>')
        .replaceAllMapped(RegExp(r'\n\n'), (match) => '</p><p>');

    return '<p>$html</p>'.replaceAll('<p></p>', '').replaceAll('<p><hr></p>', '<hr>');
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#039;');
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _webViewController);
  }
}
