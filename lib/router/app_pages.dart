import 'package:solitary_meet/pages/Index/Index_view.dart';
import 'package:solitary_meet/pages/chat/chat_binding.dart';
import 'package:solitary_meet/pages/chat/chat_view.dart';
import 'package:solitary_meet/pages/community/moment/detail/moment_detail_binding.dart';
import 'package:solitary_meet/pages/community/moment/detail/moment_detail_view.dart';
import 'package:solitary_meet/pages/friend/friends_list/friend_list_binding.dart';
import 'package:solitary_meet/pages/friend/friends_list/friend_list_view.dart';
import 'package:solitary_meet/pages/home/home_binding.dart';
import 'package:solitary_meet/pages/home/home_view.dart';
import 'package:solitary_meet/pages/login/login_binding.dart';
import 'package:solitary_meet/pages/login/login_view.dart';
import 'package:solitary_meet/pages/notfound/notfound_view.dart';
import 'package:solitary_meet/pages/profile/profile_binding.dart';
import 'package:solitary_meet/pages/profile/profile_view.dart';
import 'package:solitary_meet/pages/proxy/proxy_view.dart';
import 'package:get/get.dart';
import 'package:solitary_meet/pages/search/search_binding.dart';
import 'package:solitary_meet/pages/search/search_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.Index;

  static final routes = [
    GetPage(
      name: AppRoutes.Index,
      page: () => const IndexPage(),
    ),
    GetPage(
      name: AppRoutes.Login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.Home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.Chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.Search,
      page: () => SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.Profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.Friends,
      page: () => FriendListPage(),
      binding: FriendListBinding(),
    ),
    GetPage(
      name: AppRoutes.MomentDetail,
      page: () => MomentDetailPage(),
      binding: MomentDetailBinding(),
    ),
  ];

  static final unknownRoute = GetPage(
    name: AppRoutes.NotFound,
    page: () => const NotfoundPage(),
  );

  static final proxyRoute = GetPage(
    name: AppRoutes.Proxy,
    page: () => ProxyPage(),
  );
}
