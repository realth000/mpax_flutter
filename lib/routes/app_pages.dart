import 'package:get/get.dart';
import 'package:mpax_flutter/views/home_page.dart';

part 'app_routes.dart';

class MPaxPages {
  static const initialPage = MPaxRoutes.home;

  static final routes = [
    GetPage(
      name: MPaxRoutes.home,
      page: () => const HomePage(),
    ),
  ];
}
