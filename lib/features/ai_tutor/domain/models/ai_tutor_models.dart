class AiTutorRadioOption {
  const AiTutorRadioOption({
    required this.value,
    required this.label,
    this.subtitle,
  });

  final String value;
  final String label;
  final String? subtitle;
}

class AiTutorData {
  const AiTutorData({
    required this.personalityOptions,
    required this.voiceOptions,
    required this.responseSpeedOptions,
    required this.contentStrictnessOptions,
    required this.languageOptions,
  });

  final List<AiTutorRadioOption> personalityOptions;
  final List<String> voiceOptions;
  final List<String> responseSpeedOptions;
  final List<String> contentStrictnessOptions;
  final List<String> languageOptions;

  static const AiTutorData standard = AiTutorData(
    personalityOptions: [
      AiTutorRadioOption(
        value: 'friendly',
        label: 'Friendly & Supportive',
        subtitle: 'Gentle motivation with positive reinforcement.',
      ),
      AiTutorRadioOption(
        value: 'formal',
        label: 'Formal & Academic',
        subtitle: 'Structured explanations and exam-focused tone.',
      ),
      AiTutorRadioOption(
        value: 'motivational',
        label: 'Motivational & Energetic',
        subtitle: 'High-energy delivery to keep learners engaged.',
      ),
    ],
    voiceOptions: ['Female (Warm)', 'Male (Calm)', 'Neutral (Balanced)'],
    responseSpeedOptions: ['Balanced', 'Faster', 'Deliberate'],
    contentStrictnessOptions: ['Board Specific (State)', 'NCERT Focused', 'Flexible Guidance'],
    languageOptions: ['English', 'Hindi', 'Spanish', 'French'],
  );
}

class AiTutorSelections {
  const AiTutorSelections({
    required this.personality,
    required this.voice,
    required this.responseSpeed,
    required this.contentStrictness,
    required this.language,
  });

  final String personality;
  final String voice;
  final String responseSpeed;
  final String contentStrictness;
  final String language;

  factory AiTutorSelections.fromData(AiTutorData data) {
    return AiTutorSelections(
      personality: data.personalityOptions.first.value,
      voice: data.voiceOptions.first,
      responseSpeed: data.responseSpeedOptions.first,
      contentStrictness: data.contentStrictnessOptions.first,
      language: data.languageOptions.first,
    );
  }

  AiTutorSelections copyWith({
    String? personality,
    String? voice,
    String? responseSpeed,
    String? contentStrictness,
    String? language,
  }) {
    return AiTutorSelections(
      personality: personality ?? this.personality,
      voice: voice ?? this.voice,
      responseSpeed: responseSpeed ?? this.responseSpeed,
      contentStrictness: contentStrictness ?? this.contentStrictness,
      language: language ?? this.language,
    );
  }
}
