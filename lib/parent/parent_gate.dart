import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../localization/l10n.dart';
import '../theme/app_theme.dart';
import 'parent_gate_challenge.dart';

/// Shows the Parent Gate. Resolves to `true` only if an adult answered.
Future<bool> showParentGate(BuildContext context) async {
  final passed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const ParentGateDialog(),
  );
  return passed ?? false;
}

class ParentGateDialog extends StatefulWidget {
  const ParentGateDialog({super.key, this.challengeFactory});

  /// Injectable for tests.
  final ParentGateChallenge Function()? challengeFactory;

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog> {
  late ParentGateChallenge _challenge = _newChallenge();
  String _input = '';
  bool _wrong = false;

  static const int _maxDigits = 2;

  ParentGateChallenge _newChallenge() =>
      widget.challengeFactory?.call() ?? ParentGateChallenge.random();

  void _onDigit(int d) {
    if (_input.length >= _maxDigits) return;
    setState(() {
      _input += '$d';
      _wrong = false;
    });
  }

  void _onDelete() {
    if (_input.isEmpty) return;
    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _onConfirm() {
    if (_challenge.check(_input)) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _wrong = true;
      _input = '';
      _challenge = _newChallenge();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final fmt = NumberFormat.decimalPattern(locale);
    String n(int v) => fmt.format(v);

    return AlertDialog(
      title: Text(l10n.parentGateTitle, textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.parentGateQuestion(n(_challenge.a), n(_challenge.b)),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 56,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.mutedText),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _input.isEmpty ? '' : n(int.parse(_input)),
                key: const Key('parentGateInput'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (_wrong) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.parentGateWrong,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            _Keypad(
              format: n,
              onDigit: _onDigit,
              onDelete: _onDelete,
              deleteLabel: l10n.parentGateDelete,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('parentGateConfirm'),
          onPressed: _input.isEmpty ? null : _onConfirm,
          child: Text(l10n.parentGateConfirm),
        ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.format,
    required this.onDigit,
    required this.onDelete,
    required this.deleteLabel,
  });

  final String Function(int) format;
  final ValueChanged<int> onDigit;
  final VoidCallback onDelete;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    Widget key(int d) => _KeyButton(
      key: Key('parentGateKey$d'),
      onTap: () => onDigit(d),
      child: Text(format(d), style: const TextStyle(fontSize: 22)),
    );
    return Directionality(
      // Keep the familiar phone keypad layout in every language.
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in const [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ])
            Row(
              mainAxisSize: MainAxisSize.min,
              children: row.map(key).toList(),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 64, height: 56),
              key(0),
              _KeyButton(
                onTap: onDelete,
                child: Icon(
                  Icons.backspace_outlined,
                  semanticLabel: deleteLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: SizedBox(
        width: 56,
        height: 48,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
          child: child,
        ),
      ),
    );
  }
}
