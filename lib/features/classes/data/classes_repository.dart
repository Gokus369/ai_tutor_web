import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/create_class_dialog.dart';
import 'package:dio/dio.dart';

class Grade {
  const Grade({
    required this.id,
    required this.name,
    required this.schoolId,
    required this.boardId,
    this.section,
    this.startDateIso,
    this.boardName,
    this.schoolName,
  });

  final int id;
  final String name;
  final int schoolId;
  final int boardId;
  final String? section;
  final String? startDateIso;
  final String? boardName;
  final String? schoolName;

  factory Grade.fromJson(Map<String, dynamic> json) {
    final board = json['board'] as Map<String, dynamic>?;
    final school = json['school'] as Map<String, dynamic>?;
    return Grade(
      id: _asInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      schoolId: _asInt(json['schoolId']) ?? 0,
      boardId: _asInt(json['boardId']) ?? 0,
      section: json['section']?.toString(),
      startDateIso: json['startDate']?.toString(),
      boardName: board?['name']?.toString(),
      schoolName: school?['schoolName']?.toString() ?? school?['name']?.toString(),
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class ClassesRepository {
  ClassesRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<GradePage> fetchGrades({
    int offset = 1,
    int take = 10,
    String? name,
    int? schoolId ,
    int? boardId,
    String? section,
  }) async {
    final query = <String, dynamic>{
      'offset': offset,
      'take': take,
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (schoolId != null) 'schoolId': schoolId,
      if (boardId != null) 'boardId': boardId,
      if (section != null && section.trim().isNotEmpty) 'section': section.trim(),
    };

    final response =
        await _apiClient.dio.get<Map<String, dynamic>>('/grades', queryParameters: query);
    final body = response.data ?? <String, dynamic>{};
    final List<dynamic> dataList = body['data'] as List<dynamic>? ?? const [];
    final pagination = body['pagination'] as Map<String, dynamic>? ?? {};

    final grades = dataList
        .whereType<Map<String, dynamic>>()
        .map(Grade.fromJson)
        .toList();

    final currentPage =
        _parseInt(pagination['currentPage']) ?? _parseInt(query['offset']) ?? 1;
    final hasNext = pagination['hasNext'] == true;

    return GradePage(
      data: grades,
      currentPage: currentPage,
      hasNext: hasNext,
    );
  }

  Future<Grade> createGrade(CreateClassRequest request) async {
    final payload = {
      'name': request.className,
      'schoolId': request.schoolId,
      'boardId': request.boardId,
      if (request.section != null && request.section!.isNotEmpty)
        'section': request.section,
      if (request.startDate != null)
        'startDate': request.startDate!.toUtc().toIso8601String(),
    };

    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/grades',
        data: payload,
      );
      final data = response.data?['data'] ?? response.data ?? <String, dynamic>{};
      if (data is Map<String, dynamic>) {
        return Grade.fromJson(data);
      }
      throw Exception('Unexpected response while creating grade');
    } on DioException catch (e) {
      throw Exception(_extractError(e, fallback: 'Failed to create grade'));
    }
  }

  Future<Grade> updateGrade(int id, CreateClassRequest request) async {
    final payload = {
      'name': request.className,
      'schoolId': request.schoolId,
      'boardId': request.boardId,
      if (request.section != null && request.section!.isNotEmpty)
        'section': request.section,
      if (request.startDate != null)
        'startDate': request.startDate!.toUtc().toIso8601String(),
    };

    try {
      final response = await _apiClient.dio.patch<Map<String, dynamic>>(
        '/grades/$id',
        data: payload,
      );
      final body = response.data ?? <String, dynamic>{};
      final data = body['data'] ?? body;
      if (data is Map<String, dynamic>) {
        return Grade.fromJson(data);
      }
      throw Exception('Unexpected response while updating grade');
    } on DioException catch (e) {
      throw Exception(_extractError(e, fallback: 'Failed to update grade'));
    } catch (e) {
      rethrow;
    }
  }

  Future<Grade> fetchGradeById(int id) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/grades/$id',
      );
      final body = response.data ?? <String, dynamic>{};
      final data = body['data'] ?? body;
      if (data is Map<String, dynamic>) {
        return Grade.fromJson(data);
      }
      throw Exception('Unexpected response while fetching grade');
    } on DioException catch (e) {
      throw Exception(_extractError(e, fallback: 'Failed to fetch grade'));
    } catch (e) {
      rethrow;
    }
  }

  Future<Grade> deleteGrade({required int id, required int deletedById}) async {
    try {
      final response = await _apiClient.dio.delete<Map<String, dynamic>>(
        '/grades/$id',
        data: {'deletedById': deletedById},
      );
      final body = response.data ?? <String, dynamic>{};
      final data = body['data'] ?? body;
      if (data is Map<String, dynamic>) {
        return Grade.fromJson(data);
      }
      throw Exception('Unexpected response while deleting grade');
    } on DioException catch (e) {
      throw Exception(_extractError(e, fallback: 'Failed to delete grade'));
    } catch (e) {
      rethrow;
    }
  }

  String _extractError(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString();
      }
      if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
        return data['error'].toString();
      }
    }
    return e.message ?? fallback;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class GradePage {
  const GradePage({
    required this.data,
    required this.currentPage,
    required this.hasNext,
  });

  final List<Grade> data;
  final int currentPage;
  final bool hasNext;
}
