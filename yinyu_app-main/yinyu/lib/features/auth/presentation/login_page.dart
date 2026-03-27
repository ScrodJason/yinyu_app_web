import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/gradient_background.dart';
import 'widgets/auth_agreement_section.dart';
import '../state/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _pwd = TextEditingController();
  bool _obscure = true;
  bool _agreed = false;

  @override
  void dispose() {
    _phone.dispose();
    _pwd.dispose();
    super.dispose();
  }

  bool _ensureAgreement() {
    if (_agreed) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请先阅读并同意《用户许可协议》')),
    );
    return false;
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_ensureAgreement()) return;
    ref.read(authControllerProvider).signIn(phone: _phone.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      const Color(0xFF8B5CF6),
                    ]),
                  ),
                  child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text('音愈', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 14),
            Text('登录后即可进入：音愈检测、音乐库、冥想挑战、心理咨询等核心功能', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: '手机号',
                          prefixIcon: Icon(Icons.phone_rounded),
                        ),
                        validator: Validators.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pwd,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: '密码',
                          prefixIcon: const Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          ),
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 12),
                      AuthAgreementSection(
                        value: _agreed,
                        onChanged: (value) => setState(() => _agreed = value),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _login,
                          child: const Text('登录'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: const Text('注册账号'),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('演示版未接入短信/找回密码，仅做页面展示。')),
                              );
                            },
                            child: const Text('忘记密码'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text('其他登录方式', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _AltLoginChip(
                  icon: Icons.chat_rounded,
                  label: '微信登录',
                  onTap: () {
                    if (!_ensureAgreement()) return;
                    _login();
                  },
                ),
                _AltLoginChip(
                  icon: Icons.chat_bubble_rounded,
                  label: 'QQ登录',
                  onTap: () {
                    if (!_ensureAgreement()) return;
                    _login();
                  },
                ),
                _AltLoginChip(
                  icon: Icons.flash_on_rounded,
                  label: '本机号码一键登录',
                  onTap: () {
                    if (!_ensureAgreement()) return;
                    _login();
                  },
                ),
                _AltLoginChip(
                  icon: Icons.key_rounded,
                  label: '账号密码登录',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '提示：首次登录会弹出基础信息与偏好问卷，用于优化体验与功能推荐。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AltLoginChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AltLoginChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
