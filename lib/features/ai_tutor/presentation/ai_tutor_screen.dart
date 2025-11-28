import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_view.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key, this.data = AiTutorData.standard});

  final AiTutorData data;

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  late AiTutorSelections _selections;

  @override
  void initState() {
    super.initState();
    _selections = AiTutorSelections.fromData(widget.data);
  }

  @override
  void didUpdateWidget(covariant AiTutorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _selections = AiTutorSelections.fromData(widget.data);
    }
  }

  void _setPersonality(String value) {
    setState(() {
      _selections = _selections.copyWith(personality: value);
    });
  }

  void _setVoice(String value) {
    setState(() {
      _selections = _selections.copyWith(voice: value);
    });
  }

  void _setResponseSpeed(String value) {
    setState(() {
      _selections = _selections.copyWith(responseSpeed: value);
    });
  }

  void _setContentStrictness(String value) {
    setState(() {
      _selections = _selections.copyWith(contentStrictness: value);
    });
  }

  void _setLanguage(String value) {
    setState(() {
      _selections = _selections.copyWith(language: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.aiTutor,
      title: 'AI Tutor',
      alignContentToStart: true,
      maxContentWidth: 1200,
      builder: (context, _) {
        return AiTutorView(
          data: widget.data,
          selections: _selections,
          onPersonalityChanged: _setPersonality,
          onVoiceChanged: _setVoice,
          onResponseSpeedChanged: _setResponseSpeed,
          onContentStrictnessChanged: _setContentStrictness,
          onLanguageChanged: _setLanguage,
          showTitle: false,
        );
      },
    );
  }
}
