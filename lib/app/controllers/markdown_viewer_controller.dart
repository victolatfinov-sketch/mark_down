import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class MarkdownViewerController extends GetxController {
  final markdownContent = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentFilePath = ''.obs;
  final fontSize = 16.0.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments['filePath'] != null) {
      currentFilePath.value = arguments['filePath'];
      loadMarkdownFile(arguments['filePath']);
    } else {
      errorMessage.value = 'No file path provided';
    }
  }

  Future<void> loadMarkdownFile(String filePath) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('Loading file: $filePath');

      String content;
      
      if (filePath.startsWith('assets/')) {
        content = await rootBundle.loadString(filePath);
      } else {
        final file = File(filePath);
        if (await file.exists()) {
          content = await file.readAsString();
        } else {
          throw Exception('File not found: $filePath');
        }
      }

      markdownContent.value = content;
      print('File content loaded: ${content.substring(0, 100)}...');
    } catch (e) {
      errorMessage.value = 'Error loading file: $e';
      print('Error loading file: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void increaseFontSize() {
    if (fontSize.value < 32) {
      fontSize.value += 2;
    }
  }

  void decreaseFontSize() {
    if (fontSize.value > 12) {
      fontSize.value -= 2;
    }
  }

  void refreshFile() {
    if (currentFilePath.value.isNotEmpty) {
      loadMarkdownFile(currentFilePath.value);
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}
