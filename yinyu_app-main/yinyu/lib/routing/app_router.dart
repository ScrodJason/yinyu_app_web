import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/auth/presentation/onboarding_page.dart';
import '../features/shell/presentation/app_shell_page.dart';

import '../features/home/presentation/detection/detection_page.dart';
import '../features/home/presentation/music/music_library_page.dart';
import '../features/home/presentation/music/music_player_page.dart';
import '../features/home/presentation/meditation/meditation_page.dart';
import '../features/home/presentation/meditation/meditation_session_page.dart';
import '../features/home/presentation/consultation/consultation_page.dart';
import '../features/home/presentation/consultation/consultant_detail_page.dart';
import '../features/home/presentation/consultation/consult_chat_page.dart';

import '../features/community/presentation/community_page.dart';
import '../features/community/presentation/new_post_page.dart';
import '../features/community/presentation/article_detail_page.dart';
import '../features/community/presentation/video_detail_page.dart';

import '../features/mall/presentation/mall_page.dart';
import '../features/mall/presentation/product_detail_page.dart';
import '../features/mall/presentation/cart_page.dart';
import '../features/mall/presentation/orders_page.dart';
import '../features/mall/presentation/logistics_page.dart';

import '../features/profile/presentation/profile_page.dart';
import '../features/profile/presentation/profile_edit_page.dart';
import '../features/profile/presentation/membership_page.dart';
import '../features/profile/presentation/support_page.dart';
import '../features/profile/presentation/security_page.dart';

import '../features/auth/state/auth_controller.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: auth,
    redirect: (context, state) {
      final s = auth.state;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!s.isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (s.isFirstLogin) {
        return isOnboarding ? null : '/onboarding';
      }

      // 已登录 + 已完成问卷
      if (isLoggingIn || isOnboarding) return '/app';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),

      GoRoute(
        path: '/app',
        pageBuilder: (_, __) => const NoTransitionPage(child: AppShellPage()),
        routes: [
          // tab deep-links (optional)
          GoRoute(path: 'community', builder: (_, __) => const CommunityPage()),
          GoRoute(path: 'mall', builder: (_, __) => const MallPage()),
          GoRoute(path: 'profile', builder: (_, __) => const ProfilePage()),
        ],
      ),

      // 首页四大功能
      GoRoute(path: '/detection', builder: (_, __) => const DetectionPage()),
      GoRoute(path: '/music', builder: (_, __) => const MusicLibraryPage()),
      GoRoute(path: '/music/player/:trackId', builder: (_, s) {
        final id = s.pathParameters['trackId']!;
        return MusicPlayerPage(trackId: id);
      }),
      GoRoute(path: '/meditation', builder: (_, __) => const MeditationPage()),
      GoRoute(path: '/meditation/session', builder: (_, s) {
        final mins = int.tryParse(s.uri.queryParameters['mins'] ?? '') ?? 15;
        final preset = s.uri.queryParameters['preset'] ?? '雨声';
        return MeditationSessionPage(minutes: mins, preset: preset);
      }),
      GoRoute(path: '/consultation', builder: (_, __) => const ConsultationPage()),
      GoRoute(path: '/consultation/consultant/:id', builder: (_, s) {
        final id = s.pathParameters['id']!;
        return ConsultantDetailPage(consultantId: id);
      }),
      GoRoute(path: '/consultation/chat/:id', builder: (_, s) {
        final id = s.pathParameters['id']!;
        return ConsultChatPage(consultantId: id);
      }),

      // 社区
      GoRoute(path: '/community', builder: (_, __) => const CommunityPage()),
      GoRoute(path: '/community/new-post', builder: (_, s) => NewPostPage(prefill: s.uri.queryParameters['prefill'])),
      GoRoute(path: '/community/article/:id', builder: (_, s) {
        final id = s.pathParameters['id']!;
        return ArticleDetailPage(articleId: id);
      }),
      GoRoute(path: '/community/video/:id', builder: (_, s) {
        final id = s.pathParameters['id']!;
        return VideoDetailPage(videoId: id);
      }),

      // 商城
      GoRoute(path: '/mall', builder: (_, __) => const MallPage()),
      GoRoute(path: '/mall/product/:id', builder: (_, s) {
        final id = s.pathParameters['id']!;
        return ProductDetailPage(productId: id);
      }),
      GoRoute(path: '/mall/cart', builder: (_, __) => const CartPage()),
      GoRoute(path: '/mall/orders', builder: (_, __) => const OrdersPage()),
      GoRoute(path: '/mall/logistics/:orderId', builder: (_, s) {
        final id = s.pathParameters['orderId']!;
        return LogisticsPage(orderId: id);
      }),

      // 我的
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      GoRoute(path: '/profile/edit', builder: (_, __) => const ProfileEditPage()),
      GoRoute(path: '/profile/membership', builder: (_, __) => const MembershipPage()),
      GoRoute(path: '/profile/support', builder: (_, __) => const SupportPage()),
      GoRoute(path: '/profile/security', builder: (_, __) => const SecurityPage()),
    ],
  );
});
