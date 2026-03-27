class Validators {
  static String? phone(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '请输入手机号';
    if (s.length < 8) return '手机号格式不正确';
    return null;
  }

  static String? password(String? v) {
    final s = (v ?? '');
    if (s.isEmpty) return '请输入密码';
    if (s.length < 6) return '密码至少 6 位';
    return null;
  }

  static String? nonEmpty(String? v, {String label = '内容'}) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return '请输入$label';
    return null;
  }
}
