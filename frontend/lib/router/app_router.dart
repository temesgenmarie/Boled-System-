import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/screens/auth/login_screen.dart';
import 'package:admin_app/screens/dashboard/dashboard_screen.dart';
import 'package:admin_app/screens/members/members_list_screen.dart';
import 'package:admin_app/screens/members/add_member_screen.dart';
import 'package:admin_app/screens/members/edit_member_screen.dart';
import 'package:admin_app/screens/members/member_detail_screen.dart';
import 'package:admin_app/screens/messages/message_screen.dart';
import 'package:admin_app/screens/messages/message_history_screen.dart';
import 'package:admin_app/screens/profile/profile_screen.dart';
import 'package:admin_app/screens/settings/settings_screen.dart';
import 'package:admin_app/screens/about/about_screen.dart';
import 'package:admin_app/providers/auth_provider.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/members',
        builder: (context, state) => const MembersListScreen(),
      ),
      GoRoute(
        path: '/members/add',
        builder: (context, state) => const AddMemberScreen(),
      ),
      GoRoute(
        path: '/members/:id',
        builder: (context, state) {
          final memberId = state.pathParameters['id']!;
          return MemberDetailScreen(memberId: memberId);
        },
      ),
      GoRoute(
        path: '/members/:id/edit',
        builder: (context, state) {
          final memberId = state.pathParameters['id']!;
          return EditMemberScreen(memberId: memberId);
        },
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessageScreen(),
      ),
      GoRoute(
        path: '/messages/history',
        builder: (context, state) => const MessageHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
