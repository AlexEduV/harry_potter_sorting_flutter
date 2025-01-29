import 'package:auto_route/auto_route.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/detail_page.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, path: '/'),
    AutoRoute(page: DetailRoute.page, path: '/details/:id'),
  ];

}
