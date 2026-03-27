import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isFirstLogin;
  final UserProfile? profile;

  const AuthState({
    required this.isLoggedIn,
    required this.isFirstLogin,
    required this.profile,
  });

  factory AuthState.signedOut() => const AuthState(isLoggedIn: false, isFirstLogin: false, profile: null);

  AuthState copyWith({bool? isLoggedIn, bool? isFirstLogin, UserProfile? profile}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
      profile: profile ?? this.profile,
    );
  }
}

class AuthController extends ChangeNotifier {
  AuthState _state = AuthState.signedOut();
  AuthState get state => _state;

  void signIn({required String phone}) {
    _state = AuthState(
      isLoggedIn: true,
      isFirstLogin: true,
      profile: UserProfile(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        phone: phone,
        nickname: '新用户',
        age: 20,
        gender: '未设置',
        tags: const [],
      ),
    );
    notifyListeners();
  }

  void completeOnboarding(UserProfile profile) {
    _state = _state.copyWith(isFirstLogin: false, profile: profile);
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    _state = _state.copyWith(profile: profile);
    notifyListeners();
  }

  void signOut() {
    _state = AuthState.signedOut();
    notifyListeners();
  }
}

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) => AuthController());

final authStateProvider = Provider<AuthState>((ref) => ref.watch(authControllerProvider).state);
