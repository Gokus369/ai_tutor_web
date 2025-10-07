import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndPolicyCheckbox extends StatefulWidget {
  const TermsAndPolicyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  @override
  State<TermsAndPolicyCheckbox> createState() => _TermsAndPolicyCheckboxState();
}

class _TermsAndPolicyCheckboxState extends State<TermsAndPolicyCheckbox> {
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  late final FocusNode _focusNode;

  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTermsTap;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
    _focusNode = FocusNode(debugLabel: 'terms_checkbox');
  }

  @override
  void didUpdateWidget(TermsAndPolicyCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _termsRecognizer.onTap = widget.onTermsTap;
    _privacyRecognizer.onTap = widget.onPrivacyTap;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool highlight = widget.value || _hovered || _focused;
    final Color borderColor = highlight ? AppColors.primary : AppColors.checkboxBorder;
    final Color backgroundColor = widget.value
        ? AppColors.primary
        : (highlight ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent);

    return SizedBox(
      width: 292.41650390625,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FocusableActionDetector(
            focusNode: _focusNode,
            mouseCursor: SystemMouseCursors.click,
            onShowHoverHighlight: (value) => setState(() => _hovered = value),
            onShowFocusHighlight: (value) => setState(() => _focused = value),
            actions: <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  widget.onChanged(!widget.value);
                  return null;
                },
              ),
            },
            child: GestureDetector(
              onTap: () => widget.onChanged(!widget.value),
              behavior: HitTestBehavior.opaque,
              child: Semantics(
                container: true,
                checked: widget.value,
                label: 'Accept terms of use and privacy policy',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: widget.value
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTypography.bodySmall,
                children: [
                  const TextSpan(text: 'I accept '),
                  TextSpan(
                    text: 'terms of use',
                    style: AppTypography.linkSmall,
                    recognizer: _termsRecognizer,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'privacy policy',
                    style: AppTypography.linkSmall,
                    recognizer: _privacyRecognizer,
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
