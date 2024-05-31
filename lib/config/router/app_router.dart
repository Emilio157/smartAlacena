import 'package:smart_alacena/auth/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_alacena/auth/screens/products_list.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
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
      path: '/Root',
      builder: (context, state) =>  FirestoreButtonWidget(),
    ),
  ],
);