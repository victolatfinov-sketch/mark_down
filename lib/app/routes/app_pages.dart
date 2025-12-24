import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/markdown_viewer_controller.dart';
import '../screens/home_screen.dart';
import '../screens/markdown_viewer_screen.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
    GetPage(
      name: Routes.markdownViewer,
      page: () => const MarkdownViewerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MarkdownViewerController());
      }),
    ),
  ];
}

class Routes {
  static const home = '/home';
  static const markdownViewer = '/markdown-viewer';
}
