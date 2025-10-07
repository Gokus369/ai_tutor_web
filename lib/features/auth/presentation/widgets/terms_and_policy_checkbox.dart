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

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTermsTap;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 292.41650390625,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
            side: const BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.primary;
                }
                if (states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.focused)) {
                  return AppColors.primary.withOpacity(0.08);
                }
                return Colors.transparent;
              },
            ),
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
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
