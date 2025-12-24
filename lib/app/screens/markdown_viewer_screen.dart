import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:markdown_reader_mvp/app/controllers/markdown_viewer_controller.dart';
import 'package:markdown/markdown.dart' hide Text;



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
                    color: const Color.fromRGBO(255, 0, 0, 0.1),
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
                  child: Obx(
                    () => controller.isLoading.value
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
        onWebResourceError: (WebResourceError error) {
          print('Web resource error: ${error.description}');
        },
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
    print('Generated HTML content: $htmlContent');
    _webViewController.loadHtmlString(
      htmlContent,
      baseUrl: 'assets://',
    );
  }

  String _generateHtmlContent(String markdown, double fontSize) {
    final blocks = _processMermaidBlocks(markdown);
    final buffer = StringBuffer();

    for (final block in blocks) {
      if (block['type'] == 'markdown') {
        buffer.write(markdownToHtml(block['content']!));
      } else if (block['type'] == 'mermaid') {
        buffer.write('<div class="mermaid">${block['content']}</div>');
      }
    }
    
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
    .mermaid {
      display: flex;
      justify-content: center;
      margin: 24px 0;
      padding: 16px;
      background-color: #f8f9fa;
      border-radius: 8px;
      min-height: 100px;
    }
    @media (prefers-color-scheme: dark) {
      .mermaid { background-color: #2d2d2d; }
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
    ${buffer.toString()}
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

  List<Map<String, String>> _processMermaidBlocks(String markdown) {
    final List<Map<String, String>> blocks = [];
    final lines = markdown.split('\n');
    final buffer = StringBuffer();
    bool inMermaidBlock = false;

    for (final line in lines) {
      if (line.trim().startsWith('```mermaid')) {
        if (buffer.isNotEmpty) {
          blocks.add({'type': 'markdown', 'content': buffer.toString()});
          buffer.clear();
        }
        inMermaidBlock = true;
        buffer.write(line.substring(line.indexOf('```mermaid') + '```mermaid'.length));
        buffer.write('\n');
      } else if (line.trim().startsWith('```') && inMermaidBlock) {
        if (buffer.isNotEmpty) {
          blocks.add({'type': 'mermaid', 'content': buffer.toString()});
          buffer.clear();
        }
        inMermaidBlock = false;
      } else {
        buffer.write(line);
        buffer.write('\n');
      }
    }

    if (buffer.isNotEmpty) {
      blocks.add({'type': 'markdown', 'content': buffer.toString()});
    }

    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _webViewController);
  }
}
