import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/teachers/domain/models/teacher.dart';
import 'package:ai_tutor_web/features/teachers/domain/models/teacher_request.dart';
import 'package:dio/dio.dart';

class TeacherPage {
  const TeacherPage({
    required this.data,
    required this.currentPage,
    required this.hasNext,
  });

  final List<Teacher> data;
  final int currentPage;
  final bool hasNext;
}

class TeacherRepository {
  TeacherRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<TeacherPage> fetchTeachers({
    int offset = 1,
    int take = 100,
    String? name,
    int? schoolId,
    String? subject,
  }) async {
    final filters = _buildFilters(
      name: name,
      schoolId: schoolId,
      subject: subject,
    );
    final queries = _buildQueryOptions(
      offset: offset,
      take: take,
      filters: filters,
    );

    DioException? lastError;
    for (final option in queries) {
      try {
        return await _requestTeachers(
          query: option.query,
          fallbackPage: option.page,
          fallbackPageSize: option.pageSize,
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          lastError = e;
          continue;
        }
        rethrow;
      }
    }

    if (lastError != null) throw lastError;
    return const TeacherPage(data: [], currentPage: 1, hasNext: false);
  }

  Future<Teacher> createTeacher({
    required TeacherCreateRequest request,
  }) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/users',
      data: _payloadFromRequest(request),
    );
    final data = response.data ?? <String, dynamic>{};
    return Teacher.fromJson(data);
  }

  Future<Teacher> updateTeacher({
    required int id,
    required TeacherCreateRequest request,
  }) async {
    final response = await _apiClient.dio.put<Map<String, dynamic>>(
      '/users/$id',
      data: _payloadFromUpdate(request),
    );
    final data = response.data ?? <String, dynamic>{};
    return Teacher.fromJson(data);
  }

  Future<void> deleteTeacher({required int id}) async {
    await _apiClient.dio.delete<void>('/users/$id');
  }

  List<_TeacherQueryOption> _buildQueryOptions({
    required int offset,
    required int take,
    required Map<String, dynamic> filters,
  }) {
    final int safeOffset = offset < 1 ? 1 : offset;
    final int safeTake = take < 1 ? 1 : take;
    const int fallbackTake = 20;
    final int reducedTake =
        safeTake > fallbackTake ? fallbackTake : safeTake;

    return [
      _TeacherQueryOption(
        query: _withPagination(
          filters: filters,
          pageKey: 'offset',
          sizeKey: 'take',
          page: safeOffset,
          size: safeTake,
        ),
        page: safeOffset,
        pageSize: safeTake,
      ),
      if (reducedTake != safeTake)
        _TeacherQueryOption(
          query: _withPagination(
            filters: filters,
            pageKey: 'offset',
            sizeKey: 'take',
            page: safeOffset,
            size: reducedTake,
          ),
          page: safeOffset,
          pageSize: reducedTake,
        ),
      _TeacherQueryOption(
        query: _withPagination(
          filters: filters,
          pageKey: 'page',
          sizeKey: 'limit',
          page: safeOffset,
          size: safeTake,
        ),
        page: safeOffset,
        pageSize: safeTake,
      ),
      if (reducedTake != safeTake)
        _TeacherQueryOption(
          query: _withPagination(
            filters: filters,
            pageKey: 'page',
            sizeKey: 'limit',
            page: safeOffset,
            size: reducedTake,
          ),
          page: safeOffset,
          pageSize: reducedTake,
        ),
    ];
  }

  Map<String, dynamic> _buildFilters({
    String? name,
    int? schoolId,
    String? subject,
  }) {
    return <String, dynamic>{
      'userType': 'TEACHER',
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (schoolId != null) 'schoolId': schoolId,
      if (subject != null && subject.trim().isNotEmpty)
        'subject': subject.trim(),
    };
  }

  Map<String, dynamic> _withPagination({
    required Map<String, dynamic> filters,
    required String pageKey,
    required String sizeKey,
    required int page,
    required int size,
  }) {
    return {
      pageKey: page,
      sizeKey: size,
      ...filters,
    };
  }

  Future<TeacherPage> _requestTeachers({
    required Map<String, dynamic> query,
    required int fallbackPage,
    required int fallbackPageSize,
  }) async {
    final response = await _apiClient.dio
        .get<dynamic>('/users', queryParameters: query);
    final body = response.data;

    final dataList = _extractList(body);
    final teachers = dataList
        .whereType<Map<String, dynamic>>()
        .map(Teacher.fromJson)
        .toList();

    final pagination = _extractPagination(body);
    final currentPage =
        _parseInt(pagination['currentPage']) ??
        _parseInt(pagination['page']) ??
        _parseInt(pagination['pageNumber']) ??
        fallbackPage;
    final totalPages =
        _parseInt(pagination['totalPages']) ??
        _parseInt(pagination['pageCount']);
    final totalCount =
        _parseInt(pagination['total']) ??
        _parseInt(pagination['totalCount']);
    final hasNext =
        pagination['hasNext'] == true ||
        pagination['hasMore'] == true ||
        (totalPages != null && currentPage < totalPages) ||
        (totalCount != null && currentPage * fallbackPageSize < totalCount);

    return TeacherPage(
      data: teachers,
      currentPage: currentPage,
      hasNext: hasNext,
    );
  }

  List<dynamic> _extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic>) {
        final nested = data['data'];
        if (nested is List) return nested;
      }
      final users = body['users'];
      if (users is List) return users;
      final items = body['items'];
      if (items is List) return items;
      final result = body['result'];
      if (result is List) return result;
    }
    return const [];
  }

  Map<String, dynamic> _extractPagination(dynamic body) {
    if (body is Map<String, dynamic>) {
      final pagination = body['pagination'];
      if (pagination is Map<String, dynamic>) return pagination;
      final meta = body['meta'];
      if (meta is Map<String, dynamic>) return meta;
      final pageInfo = body['pageInfo'];
      if (pageInfo is Map<String, dynamic>) return pageInfo;
    }
    return <String, dynamic>{};
  }

  Map<String, dynamic> _payloadFromRequest(TeacherCreateRequest request) {
    final name = request.name.trim();
    final email = request.email.trim();
    if (name.isEmpty) {
      throw ArgumentError('Name is required');
    }
    if (email.isEmpty) {
      throw ArgumentError('Email is required');
    }
    if (request.schoolId == null || request.schoolId == 0) {
      throw ArgumentError('School is required');
    }

    final numbers = _normalizeNumbers(request.phone);
    final countryCode = _countryCode(request.phone);
    final subjectIds = _parseSubjectIds(request.subject);
    final password = request.password?.trim().isNotEmpty == true
        ? request.password!.trim()
        : 'password123';

    return {
      'name': name,
      'contactEmail': email,
      'contactNumber': numbers,
      'countryCode': countryCode,
      'userType': 'TEACHER',
      'schoolId': request.schoolId,
      if (subjectIds.isNotEmpty) 'subjects': subjectIds,
      'password': password,
    };
  }

  Map<String, dynamic> _payloadFromUpdate(TeacherCreateRequest request) {
    final payload = <String, dynamic>{};
    final name = request.name.trim();
    if (name.isNotEmpty) {
      payload['name'] = name;
    }

    final numbers = _normalizeNumbers(request.phone);
    if (numbers.isNotEmpty) {
      payload['contactNumber'] = numbers.first;
      payload['countryCode'] = _countryCode(request.phone);
    }

    if (request.schoolId != null && request.schoolId != 0) {
      payload['schoolId'] = request.schoolId;
    }

    final subjectIds = _parseSubjectIds(request.subject);
    if (subjectIds.isNotEmpty) {
      payload['subjects'] = subjectIds;
    }

    return payload;
  }

  List<String> _normalizeNumbers(String? phone) {
    if (phone == null) return const [];
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return const [];
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const [];
    return [digits];
  }

  String _countryCode(String? phone) {
    if (phone == null || phone.trim().isEmpty) return '+91';
    final match = RegExp(r'^\s*\+(\d{1,3})').firstMatch(phone.trim());
    if (match != null) {
      return '+${match.group(1)}';
    }
    return '+91';
  }

  List<int> _parseSubjectIds(String? subject) {
    if (subject == null || subject.trim().isEmpty) return const [];
    return subject
        .split(RegExp(r'[,\s]+'))
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>()
        .toList();
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class _TeacherQueryOption {
  const _TeacherQueryOption({
    required this.query,
    required this.page,
    required this.pageSize,
  });

  final Map<String, dynamic> query;
  final int page;
  final int pageSize;
}
