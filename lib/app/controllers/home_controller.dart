import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:markdown_reader_mvp/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final selectedFilePath = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> pickMarkdownFile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md', 'markdown', 'txt'],
        dialogTitle: 'Select Markdown File',
      );

      if (result != null && result.files.single.path != null) {
        selectedFilePath.value = result.files.single.path!;
        navigateToViewer();
      }
    } catch (e) {
      errorMessage.value = 'Error selecting file: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void openSampleFile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      selectedFilePath.value = 'assets/markdown/sample.md';
      navigateToViewer();
    } catch (e) {
      errorMessage.value = 'Error opening sample file: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToViewer() {
    if (selectedFilePath.value.isNotEmpty) {
      Get.toNamed(
        Routes.markdownViewer,
        arguments: {'filePath': selectedFilePath.value},
      );
    }
  }

  void clearError() {
    errorMessage.value = '';
  }
}
