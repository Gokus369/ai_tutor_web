import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
import 'package:ai_tutor_web/features/teachers/data/teacher_repository.dart';
import 'package:ai_tutor_web/features/teachers/domain/models/teacher.dart';
import 'package:ai_tutor_web/features/teachers/domain/models/teacher_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit(this._repository) : super(const TeacherState());

  final TeacherRepository _repository;

  Future<void> loadTeachers({
    int offset = 1,
    int take = 100,
    String? name,
    int? schoolId,
    String? subject,
  }) async {
    emit(state.copyWith(status: TeacherStatus.loading, error: null));
    try {
      final page = await _repository.fetchTeachers(
        offset: offset,
        take: take,
        name: name,
        schoolId: schoolId,
        subject: subject,
      );
      emit(
        state.copyWith(
          status: TeacherStatus.success,
          teachers: page.data,
          currentPage: page.currentPage,
          hasNext: page.hasNext,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TeacherStatus.error, error: _friendlyError(e)));
    }
  }

  Future<Teacher> createTeacher(AddTeacherRequest request) async {
    emit(state.copyWith(status: TeacherStatus.loading, error: null));
    try {
      final createRequest = _buildRequest(request);
      final created = await _repository.createTeacher(request: createRequest);
      final merged = _mergeTeacher(created, createRequest);
      final updated = [merged, ...state.teachers];
      emit(
        state.copyWith(
          status: TeacherStatus.success,
          teachers: updated,
        ),
      );
      return merged;
    } catch (e) {
      final message = _friendlyError(e);
      emit(state.copyWith(status: TeacherStatus.error, error: message));
      throw Exception(message);
    }
  }

  void removeLocal(Teacher teacher) {
    final updated = List<Teacher>.from(state.teachers)..remove(teacher);
    emit(state.copyWith(teachers: updated));
  }

  Future<Teacher> updateTeacher({
    required int id,
    required AddTeacherRequest request,
  }) async {
    emit(state.copyWith(status: TeacherStatus.loading, error: null));
    try {
      final updateRequest = _buildRequest(request);
      final updatedTeacher =
          await _repository.updateTeacher(id: id, request: updateRequest);
      final fallback = state.teachers
          .cast<Teacher?>()
          .firstWhere((teacher) => teacher?.id == id, orElse: () => null);
      final merged =
          _mergeTeacher(updatedTeacher, updateRequest, fallback: fallback);
      final updatedList = state.teachers
          .map((teacher) => teacher.id == id ? merged : teacher)
          .toList();
      emit(
        state.copyWith(
          status: TeacherStatus.success,
          teachers: updatedList,
        ),
      );
      return merged;
    } catch (e) {
      final message = _friendlyError(e);
      emit(state.copyWith(status: TeacherStatus.error, error: message));
      throw Exception(message);
    }
  }

  Future<void> deleteTeacher(int id) async {
    emit(state.copyWith(status: TeacherStatus.loading, error: null));
    try {
      await _repository.deleteTeacher(id: id);
      final updated = state.teachers.where((t) => t.id != id).toList();
      emit(
        state.copyWith(
          status: TeacherStatus.success,
          teachers: updated,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TeacherStatus.error, error: _friendlyError(e)));
      rethrow;
    }
  }

  Teacher _mergeTeacher(
    Teacher created,
    TeacherCreateRequest request, {
    Teacher? fallback,
  }) {
    final nameFromRequest = request.name.trim();
    final emailFromRequest = request.email.trim();
    final resolvedName = created.name.trim().isNotEmpty &&
            created.name != 'Unnamed'
        ? created.name
        : (nameFromRequest.isNotEmpty
            ? nameFromRequest
            : (fallback?.name ?? 'Unnamed'));
    final resolvedEmail = created.email.trim().isNotEmpty
        ? created.email
        : (emailFromRequest.isNotEmpty
            ? emailFromRequest
            : (fallback?.email ?? ''));
    final resolvedSubject = (created.subject ?? '').trim().isNotEmpty
        ? created.subject
        : ((request.subject ?? '').trim().isNotEmpty
            ? request.subject
            : fallback?.subject);
    final resolvedPhone = (created.phone ?? '').trim().isNotEmpty
        ? created.phone
        : ((request.phone ?? '').trim().isNotEmpty
            ? request.phone
            : fallback?.phone);
    final resolvedSchoolName = (created.schoolName ?? '').trim().isNotEmpty
        ? created.schoolName
        : ((request.schoolName ?? '').trim().isNotEmpty
            ? request.schoolName
            : fallback?.schoolName);
    final resolvedAttendance =
        created.attendance ?? request.attendance ?? fallback?.attendance;
    final resolvedSchoolId =
        created.schoolId ?? request.schoolId ?? fallback?.schoolId;

    return created.copyWith(
      name: resolvedName,
      email: resolvedEmail,
      subject: resolvedSubject,
      phone: resolvedPhone,
      attendance: resolvedAttendance,
      schoolId: resolvedSchoolId,
      schoolName: resolvedSchoolName,
    );
  }

  TeacherCreateRequest _buildRequest(AddTeacherRequest request) {
    return TeacherCreateRequest(
      name: request.name,
      email: request.email,
      phone: request.phone,
      subject: request.subject,
      attendance: request.attendance,
      schoolId: request.schoolId,
      schoolName: request.schoolName,
    );
  }

  String _friendlyError(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown) {
        return 'Unable to reach the server. Check your network connection or API base URL.';
      }
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final msg =
            data['message']?.toString() ??
            data['error']?.toString() ??
            data['detail']?.toString();
        if (msg != null && msg.trim().isNotEmpty) return msg;
      } else if (data is String && data.trim().isNotEmpty) {
        return data;
      }
      return error.message ?? error.toString();
    }
    return error.toString();
  }
}
