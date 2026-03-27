import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthAgreementSection extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AuthAgreementSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _showAgreement(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('用户许可协议'),
          content: SizedBox(
            width: 420,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Text(
                  _agreementText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('我知道了'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onChanged: (checked) => onChanged(checked ?? false),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF4B5563), height: 1.5),
                children: [
                  const TextSpan(text: '我已阅读并同意'),
                  TextSpan(
                    text: '《用户许可协议》',
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = () => _showAgreement(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _agreementText = '''
欢迎使用音愈。为保障你的合法权益，请在使用本应用前认真阅读本协议。

一、服务说明
1. 音愈为用户提供心理健康相关的内容浏览、音乐陪伴、冥想练习、社区互动、会员服务及商城购买等功能。
2. 本应用中的展示内容、推荐内容、测评结果和建议，仅用于一般信息参考，不构成医疗诊断或治疗方案。

二、用户使用规范
1. 用户应当依法依规使用本应用，不得利用本平台发布违法、侵权、骚扰、侮辱、虚假或其他不当内容。
2. 用户应妥善保管自己的账号、密码及登录信息，并对通过该账号发生的行为负责。
3. 未经许可，用户不得以任何形式复制、传播、抓取、反向工程或商业化利用本应用中的内容与服务。

三、会员与商城服务
1. 会员服务和商城商品以页面展示信息为准。
2. 涉及支付的功能为演示用途时，相关支付结果、订单状态、物流信息可能为模拟数据。
3. 一经确认的订单、会员权益开通记录等，按照页面规则和平台说明处理。

四、隐私与信息保护
1. 音愈会按照相关法律法规，在必要范围内处理你的注册信息、使用记录和偏好设置，用于账号管理、服务优化与安全保障。
2. 未经你的明确授权，平台不会将你的个人敏感信息用于与本服务无关的用途。

五、免责声明
1. 因网络故障、系统维护、不可抗力或第三方服务异常导致的服务中断、延迟或部分功能不可用，平台将尽力修复，但不承担超出法律规定范围的责任。
2. 对于用户自行理解、依赖平台一般信息而作出的决定，平台不承担医疗、投资或其他专业责任。

六、协议生效
1. 当你勾选“我已阅读并同意《用户许可协议》”并继续登录、注册或使用相关功能时，即视为你已阅读、理解并接受本协议全部内容。
2. 平台有权根据产品功能更新对本协议进行调整，更新后的内容将通过页面展示等方式提示。
''';
