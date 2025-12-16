class School {
  const School({
    required this.id,
    required this.schoolName,
    required this.address,
    required this.code,
    required this.boardId,
    this.principalId,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final int id;
  final String schoolName;
  final String address;
  final String code;
  final int boardId;
  final int? principalId;
  final int? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  factory School.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) =>
        value == null || value.isEmpty ? null : DateTime.tryParse(value);

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    return School(
      id: parseInt(json['id']) ?? 0,
      schoolName: json['schoolName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      boardId: parseInt(json['boardId']) ?? 0,
      principalId: parseInt(json['principalId']),
      createdById: parseInt(json['createdById']),
      createdAt: parseDate(json['createdAt']?.toString()),
      updatedAt: parseDate(json['updatedAt']?.toString()),
      deletedAt: parseDate(json['deletedAt']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schoolName': schoolName,
      'address': address,
      'code': code,
      'boardId': boardId,
      'principalId': principalId,
      'createdById': createdById,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  School copyWith({
    int? id,
    String? schoolName,
    String? address,
    String? code,
    int? boardId,
    int? principalId,
    int? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return School(
      id: id ?? this.id,
      schoolName: schoolName ?? this.schoolName,
      address: address ?? this.address,
      code: code ?? this.code,
      boardId: boardId ?? this.boardId,
      principalId: principalId ?? this.principalId,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
