import 'package:flutter/material.dart';

class MockPaymentResult {
  final String methodLabel;
  final int amountYuan;

  const MockPaymentResult({required this.methodLabel, required this.amountYuan});
}

enum _MockPaymentMethod { wechat, alipay }

extension on _MockPaymentMethod {
  String get label {
    switch (this) {
      case _MockPaymentMethod.wechat:
        return '微信支付';
      case _MockPaymentMethod.alipay:
        return '支付宝';
    }
  }

  IconData get icon {
    switch (this) {
      case _MockPaymentMethod.wechat:
        return Icons.forum_rounded;
      case _MockPaymentMethod.alipay:
        return Icons.account_balance_wallet_rounded;
    }
  }
}

Future<MockPaymentResult?> showMockPaymentFlow(
  BuildContext context, {
  required String title,
  required int amountYuan,
  String? description,
}) async {
  final method = await showModalBottomSheet<_MockPaymentMethod>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _PaymentMethodSheet(
      title: title,
      amountYuan: amountYuan,
      description: description,
    ),
  );

  if (method == null || !context.mounted) return null;

  final paid = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _PasswordDialog(method: method, amountYuan: amountYuan),
  );

  if (paid != true || !context.mounted) return null;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _SuccessDialog(method: method, amountYuan: amountYuan),
  );

  return MockPaymentResult(methodLabel: method.label, amountYuan: amountYuan);
}

class _PaymentMethodSheet extends StatefulWidget {
  final String title;
  final int amountYuan;
  final String? description;

  const _PaymentMethodSheet({
    required this.title,
    required this.amountYuan,
    this.description,
  });

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  _MockPaymentMethod _selected = _MockPaymentMethod.wechat;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '选择支付方式',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
            if (widget.description != null) ...[
              const SizedBox(height: 4),
              Text(widget.description!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('应付金额', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    '￥${widget.amountYuan}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _PaymentTile(
              method: _MockPaymentMethod.wechat,
              selected: _selected == _MockPaymentMethod.wechat,
              onTap: () => setState(() => _selected = _MockPaymentMethod.wechat),
            ),
            const SizedBox(height: 10),
            _PaymentTile(
              method: _MockPaymentMethod.alipay,
              selected: _selected == _MockPaymentMethod.alipay,
              onTap: () => setState(() => _selected = _MockPaymentMethod.alipay),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_selected),
                child: Text('使用${_selected.label}支付'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final _MockPaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({required this.method, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? colorScheme.primary : Colors.black.withOpacity(0.08),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary.withOpacity(0.10),
              child: Icon(method.icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('演示支付，不会发起真实扣款', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: selected ? colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordDialog extends StatefulWidget {
  final _MockPaymentMethod method;
  final int amountYuan;

  const _PasswordDialog({required this.method, required this.amountYuan});

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('输入支付密码 · ${widget.method.label}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('应付金额：￥${widget.amountYuan}'),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: '请输入6位支付密码',
              errorText: _error,
              counterText: '',
            ),
            onChanged: (_) {
              if (_error != null) {
                setState(() => _error = null);
              }
            },
          ),
          const SizedBox(height: 6),
          Text(
            '演示密码可输入任意6位数字',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_controller.text.trim().length != 6) {
              setState(() => _error = '请输入6位支付密码');
              return;
            }
            Navigator.of(context).pop(true);
          },
          child: const Text('确认支付'),
        ),
      ],
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final _MockPaymentMethod method;
  final int amountYuan;

  const _SuccessDialog({required this.method, required this.amountYuan});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          CircleAvatar(
            radius: 28,
            child: const Icon(Icons.check_rounded, size: 34),
          ),
          const SizedBox(height: 12),
          Text('支付成功', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('支付方式：${method.label}'),
          const SizedBox(height: 4),
          Text('支付金额：￥$amountYuan'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('完成'),
            ),
          ),
        ],
      ),
    );
  }
}
