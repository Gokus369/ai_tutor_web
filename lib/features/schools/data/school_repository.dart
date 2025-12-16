import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';

class School {
  const School({
    this.id,
    required this.name,
    this.address,
    this.code,
    this.boardId,
    this.createdById,
    this.principalId,
  });

  final int? id;
  final String name;
  final String? address;
  final String? code;
  final int? boardId;
  final int? createdById;
  final int? principalId;

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: _asInt(json['id']),
      name: json['schoolName']?.toString() ??
          json['name']?.toString() ??
          'Untitled',
      address: json['address']?.toString() ??
          json['addressLine1']?.toString(),
      code: json['code']?.toString() ??
          json['schoolCode']?.toString() ??
          json['supplierCode']?.toString(),
      boardId: _asInt(json['boardId']),
      createdById: _asInt(json['createdById'] ?? json['createdBy']),
      principalId: _asInt(json['principalId']),
    );
  }

  factory School.fromRequest(AddSchoolRequest request) {
    return School(
      name: request.schoolName,
      address: request.address,
      code: request.code,
      boardId: request.boardId,
      createdById: request.createdById,
      principalId: request.principalId,
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class SchoolPage {
  const SchoolPage({
    required this.data,
    required this.currentPage,
    required this.hasNext,
  });

  final List<School> data;
  final int currentPage;
  final bool hasNext;
}

class SchoolRepository {
  SchoolRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<SchoolPage> fetchSchools({
    int offset = 1,
    int take = 10,
    String? schoolName,
    String? code,
    int? boardId,
  }) async {
    final query = <String, dynamic>{
      'offset': offset,
      'take': take,
      if (schoolName != null && schoolName.trim().isNotEmpty)
        'schoolName': schoolName.trim(),
      if (code != null && code.trim().isNotEmpty) 'code': code.trim(),
      if (boardId != null) 'boardId': boardId,
    };

    final response = await _apiClient.dio
        .get<Map<String, dynamic>>('/school', queryParameters: query);
    final body = response.data ?? <String, dynamic>{};
    final List<dynamic> dataList = body['data'] as List<dynamic>? ?? const [];
    final pagination = body['pagination'] as Map<String, dynamic>? ?? {};

    final schools = dataList
        .whereType<Map<String, dynamic>>()
        .map(School.fromJson)
        .toList();

    final currentPage =
        _parseInt(pagination['currentPage']) ?? _parseInt(query['offset']) ?? 1;
    final hasNext = pagination['hasNext'] == true;

    return SchoolPage(
      data: schools,
      currentPage: currentPage,
      hasNext: hasNext,
    );
  }

  Future<School> createSchool({required AddSchoolRequest request}) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/school',
      data: _payloadFromRequest(request),
    );
    final data = response.data ?? <String, dynamic>{};
    return School.fromJson(data);
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  Future<School> updateSchool({
    required int id,
    required AddSchoolRequest request,
  }) async {
    final response =
        await _apiClient.dio.patch<Map<String, dynamic>>(
      '/school/$id',
      data: _payloadFromRequest(request),
    );
    final data = response.data ?? <String, dynamic>{};
    return School.fromJson(data);
  }

  Future<void> deleteSchool({required int id}) async {
    await _apiClient.dio.delete<void>('/school/$id');
  }

  Map<String, dynamic> _payloadFromRequest(AddSchoolRequest request) {
    return {
      'schoolName': request.schoolName,
      'address': request.address,
      'code': request.code,
      'boardId': request.boardId,
      if (request.principalId != null) 'principalId': request.principalId,
      if (request.createdById != null) 'createdById': request.createdById,
    };
  }
}
