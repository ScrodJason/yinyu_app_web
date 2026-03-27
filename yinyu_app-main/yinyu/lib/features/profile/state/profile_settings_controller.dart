import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_settings.dart';

class ProfileSettingsController extends StateNotifier<ProfileSettings> {
  ProfileSettingsController() : super(ProfileSettings.initial());

  void setMembership(String plan) => state = state.copyWith(isMember: true, memberPlan: plan);

  void cancelMembership() => state = state.copyWith(isMember: false, memberPlan: '未开通');

  void setRemindMeditation(bool v) => state = state.copyWith(remindMeditation: v);

  void setRemindDetection(bool v) => state = state.copyWith(remindDetection: v);

  void setSecurityNotify(bool v) => state = state.copyWith(securityNotify: v);

  void set2faSms(bool v) => state = state.copyWith(twoFactorSms: v);

  void set2faEmail(bool v) => state = state.copyWith(twoFactorEmail: v);

  void set2faThirdParty(bool v) => state = state.copyWith(twoFactorThirdParty: v);
}

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsController, ProfileSettings>((ref) => ProfileSettingsController());
