class AddSchoolRequest {
  const AddSchoolRequest({
    required this.schoolName,
    required this.address,
    required this.code,
    required this.boardId,
    this.principalId,
    this.createdById,
  });

  final String schoolName;
  final String address;
  final String code;
  final int boardId;
  final int? principalId;
  final int? createdById;

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'address': address,
      'code': code,
      'boardId': boardId,
      if (principalId != null) 'principalId': principalId,
      if (createdById != null) 'createdById': createdById,
    };
  }
}
