import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:ai_tutor_web/features/schools/domain/models/school.dart';
import 'package:dio/dio.dart';

class SchoolsRepository {
  SchoolsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<School>> fetchSchools() async {
    try {
      final response = await _apiClient.dio.get<dynamic>('/school');
      final data = response.data;
      final List<dynamic> items;
      if (data is List) {
        items = data;
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        items = data['data'] as List<dynamic>;
      } else {
        items = const [];
      }
      return items
          .whereType<Map<String, dynamic>>()
          .map(School.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    } catch (e) {
      throw Exception('Failed to load schools: $e');
    }
  }

  Future<School> createSchool(AddSchoolRequest request) async {
    final payload = request.toJson();
    try {
      final response = await _apiClient.dio.post<dynamic>(
        '/school',
        data: payload,
      );
      final data = response.data;
      if (data == null) {
        throw Exception('Empty response when creating school');
      }
      if (response.statusCode != null &&
          response.statusCode! >= 400 &&
          response.statusCode! < 600) {
        final message = data['message']?.toString();
        throw Exception(message ?? 'Failed to create school');
      }
      if (data is Map<String, dynamic>) {
        return School.fromJson(data);
      }
      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return School.fromJson(data.first as Map<String, dynamic>);
      }
      throw Exception('Unexpected response format from /school');
    } on DioException catch (e) {
      throw Exception(_mapDioError(e));
    } catch (e) {
      throw Exception('Failed to create school: $e');
    }
  }

  String _mapDioError(DioException e) {
    final response = e.response;
    final status = response?.statusCode;
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    if (status != null) {
      return 'Request failed ($status)';
    }
    return e.message ?? 'Network error';
  }
}
