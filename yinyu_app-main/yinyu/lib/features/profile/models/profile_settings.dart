class ProfileSettings {
  final bool isMember;
  final String memberPlan; // 月度/季度/年度/未开通
  final bool remindMeditation;
  final bool remindDetection;
  final bool securityNotify;
  final bool twoFactorSms;
  final bool twoFactorEmail;
  final bool twoFactorThirdParty;

  const ProfileSettings({
    required this.isMember,
    required this.memberPlan,
    required this.remindMeditation,
    required this.remindDetection,
    required this.securityNotify,
    required this.twoFactorSms,
    required this.twoFactorEmail,
    required this.twoFactorThirdParty,
  });

  factory ProfileSettings.initial() => const ProfileSettings(
        isMember: false,
        memberPlan: '未开通',
        remindMeditation: true,
        remindDetection: true,
        securityNotify: true,
        twoFactorSms: false,
        twoFactorEmail: false,
        twoFactorThirdParty: false,
      );

  ProfileSettings copyWith({
    bool? isMember,
    String? memberPlan,
    bool? remindMeditation,
    bool? remindDetection,
    bool? securityNotify,
    bool? twoFactorSms,
    bool? twoFactorEmail,
    bool? twoFactorThirdParty,
  }) {
    return ProfileSettings(
      isMember: isMember ?? this.isMember,
      memberPlan: memberPlan ?? this.memberPlan,
      remindMeditation: remindMeditation ?? this.remindMeditation,
      remindDetection: remindDetection ?? this.remindDetection,
      securityNotify: securityNotify ?? this.securityNotify,
      twoFactorSms: twoFactorSms ?? this.twoFactorSms,
      twoFactorEmail: twoFactorEmail ?? this.twoFactorEmail,
      twoFactorThirdParty: twoFactorThirdParty ?? this.twoFactorThirdParty,
    );
  }
}
