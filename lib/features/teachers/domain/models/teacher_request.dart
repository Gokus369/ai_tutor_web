class TeacherCreateRequest {
  const TeacherCreateRequest({
    required this.name,
    required this.email,
    this.phone,
    this.subject,
    this.attendance,
    this.schoolId,
    this.schoolName,
    this.password,
  });

  final String name;
  final String email;
  final String? phone;
  final String? subject;
  final double? attendance;
  final int? schoolId;
  final String? schoolName;
  final String? password;
}
