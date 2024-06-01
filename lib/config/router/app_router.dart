import 'package:smart_alacena/auth/auth.dart';
import 'package:go_router/go_router.dart';
import '../../app/menu/screen/menu_screen.dart';
import '../../app/menu/screen/root_menu.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen()
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: '/Root',
      builder: (context, state) => const RootApp(),
    ),
  ],
);