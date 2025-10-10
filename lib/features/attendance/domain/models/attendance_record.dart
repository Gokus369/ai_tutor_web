enum AttendanceStatus { present, absent, late }

class AttendanceRecord {
  const AttendanceRecord({
    required this.name,
    required this.className,
    required this.subject,
    required this.notes,
    required this.status,
    this.updatedAt,
  });

  final String name;
  final String className;
  final String subject;
  final String notes;
  final AttendanceStatus status;
  final DateTime? updatedAt;

  AttendanceRecord copyWith({
    String? name,
    String? className,
    String? subject,
    String? notes,
    AttendanceStatus? status,
    DateTime? Function()? updatedAt,
  }) {
    return AttendanceRecord(
      name: name ?? this.name,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
    );
  }

  static int compareByName(AttendanceRecord a, AttendanceRecord b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());
}
