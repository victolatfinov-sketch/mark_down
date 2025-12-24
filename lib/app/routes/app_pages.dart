import 'package:get/get.dart';

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
