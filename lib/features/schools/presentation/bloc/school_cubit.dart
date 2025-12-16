import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'school_state.dart';

class SchoolCubit extends Cubit<SchoolState> {
  SchoolCubit(this._repository) : super(const SchoolState());

  final SchoolRepository _repository;

  Future<void> loadSchools({
    int offset = 1,
    int take = 10,
    String? name,
    String? code,
    int? boardId,
  }) async {
    emit(state.copyWith(status: SchoolStatus.loading, error: null));
    try {
      final page = await _repository.fetchSchools(
        offset: offset,
        take: take,
        schoolName: name,
        code: code,
        boardId: boardId,
      );
      emit(
        state.copyWith(
          status: SchoolStatus.success,
          schools: page.data,
          currentPage: page.currentPage,
          hasNext: page.hasNext,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SchoolStatus.error, error: _friendlyError(e)));
    }
  }

  void addLocal(AddSchoolRequest request) {
    final updated = List<School>.from(state.schools)
      ..add(School.fromRequest(request));
    emit(state.copyWith(schools: updated));
  }

  Future<School> createSchool(AddSchoolRequest request) async {
    emit(state.copyWith(status: SchoolStatus.loading, error: null));
    try {
      final created = await _repository.createSchool(request: request);
      final updated = List<School>.from(state.schools)..add(created);
      emit(
        state.copyWith(
          status: SchoolStatus.success,
          schools: updated,
        ),
      );
      return created;
    } catch (e) {
      final message = _friendlyError(e);
      emit(state.copyWith(status: SchoolStatus.error, error: message));
      throw Exception(message);
    }
  }

  Future<void> updateSchool({
    required int id,
    required AddSchoolRequest request,
  }) async {
    emit(state.copyWith(status: SchoolStatus.loading, error: null));
    try {
      final updatedSchool =
          await _repository.updateSchool(id: id, request: request);
      final updatedList = state.schools
          .map((s) => s.id == updatedSchool.id ? updatedSchool : s)
          .toList();
      emit(
        state.copyWith(
          status: SchoolStatus.success,
          schools: updatedList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SchoolStatus.error, error: _friendlyError(e)));
    }
  }

  Future<void> deleteSchool(int id) async {
    emit(state.copyWith(status: SchoolStatus.loading, error: null));
    try {
      await _repository.deleteSchool(id: id);
      final updated = state.schools.where((s) => s.id != id).toList();
      emit(
        state.copyWith(
          status: SchoolStatus.success,
          schools: updated,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SchoolStatus.error, error: _friendlyError(e)));
      rethrow;
    }
  }

  String _friendlyError(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown) {
        return 'Unable to reach the server. Check your network connection or API base URL.';
      }
      return error.message ?? error.toString();
    }
    return error.toString();
  }
}
