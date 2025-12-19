class Teacher {
  const Teacher({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.subject,
    this.attendance,
    this.schoolId,
    this.schoolName,
  });

  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? subject;
  final double? attendance;
  final int? schoolId;
  final String? schoolName;

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString() ??
        json['fullName']?.toString() ??
        'Unnamed';
    final email = json['contactEmail']?.toString() ??
        json['email']?.toString() ??
        '';
    final school = json['school'];
    return Teacher(
      id: _asInt(json['id'] ?? json['userId'] ?? json['user_id']),
      name: name,
      email: email,
      phone: _parsePhone(json),
      subject: _parseSubjects(json['subjects'] ?? json['subject']),
      attendance: _asDouble(
        json['attendance'] ?? json['attendancePercentage'],
      ),
      schoolId: _asInt(
        json['schoolId'] ??
            json['school_id'] ??
            (school is Map<String, dynamic> ? school['id'] : null),
      ),
      schoolName: json['schoolName']?.toString() ??
          (school is Map<String, dynamic> ? school['name']?.toString() : null),
    );
  }

  Teacher copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? subject,
    double? attendance,
    int? schoolId,
    String? schoolName,
  }) {
    return Teacher(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      subject: subject ?? this.subject,
      attendance: attendance ?? this.attendance,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
    );
  }

  static String? _parsePhone(Map<String, dynamic> json) {
    final country = json['countryCode']?.toString();
    final numbers = json['contactNumber'];
    String? number;
    if (numbers is List && numbers.isNotEmpty) {
      number = numbers.first?.toString();
    } else if (numbers != null) {
      number = numbers.toString();
    } else if (json['phone'] != null) {
      number = json['phone']?.toString();
    }
    if (number == null || number.trim().isEmpty) return null;
    final trimmed = number.trim();
    if (country == null || country.trim().isEmpty) return trimmed;
    final normalized = country.startsWith('+') ? country : '+$country';
    if (trimmed.startsWith('+')) return trimmed;
    return '$normalized $trimmed';
  }

  static String? _parseSubjects(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      String? extract(dynamic item) {
        if (item is Map<String, dynamic>) {
          return item['name']?.toString() ?? item['title']?.toString();
        }
        return item?.toString();
      }

      final names =
          value.map(extract).whereType<String>().map((s) => s.trim()).where(
            (s) => s.isNotEmpty,
          ).toList();
      if (names.isEmpty) return null;
      return names.join(', ');
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _asDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
