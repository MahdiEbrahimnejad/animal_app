import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/app_config.dart';
import '../localization/l10n.dart';
import '../theme/app_theme.dart';

/// Offline privacy policy text (the full policy URL, if configured, is shown
/// as plain selectable text so the child can't open a browser by tapping).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final url = context.read<AppConfig>().privacyPolicyUrl;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.privacyPolicyBody, style: const TextStyle(height: 1.6)),
              if (url.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.privacyPolicyOnline),
                SelectableText(url, textDirection: TextDirection.ltr),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
