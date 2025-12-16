import 'package:ai_tutor_web/features/schools/data/schools_repository.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:ai_tutor_web/features/schools/domain/models/school.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SchoolsStatus { initial, loading, loaded, failure }

class SchoolsState {
  const SchoolsState({
    this.status = SchoolsStatus.initial,
    this.schools = const [],
    this.error,
    this.isSubmitting = false,
  });

  final SchoolsStatus status;
  final List<School> schools;
  final String? error;
  final bool isSubmitting;

  bool get isLoading => status == SchoolsStatus.loading;

  SchoolsState copyWith({
    SchoolsStatus? status,
    List<School>? schools,
    String? error,
    bool? isSubmitting,
  }) {
    return SchoolsState(
      status: status ?? this.status,
      schools: schools ?? this.schools,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class SchoolsCubit extends Cubit<SchoolsState> {
  SchoolsCubit(this._repository) : super(const SchoolsState());

  final SchoolsRepository _repository;

  Future<void> loadSchools() async {
    emit(state.copyWith(status: SchoolsStatus.loading, error: null));
    try {
      final schools = await _repository.fetchSchools();
      emit(
        state.copyWith(
          status: SchoolsStatus.loaded,
          schools: schools,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SchoolsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<School> createSchool(AddSchoolRequest request) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        error: null,
      ),
    );
    try {
      final school = await _repository.createSchool(request);
      final updated = [school, ...state.schools];
      emit(
        state.copyWith(
          isSubmitting: false,
          status: SchoolsStatus.loaded,
          schools: updated,
        ),
      );
      return school;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
      rethrow;
    }
  }

  void removeFromCache(int id) {
    final updated = state.schools.where((s) => s.id != id).toList();
    emit(
      state.copyWith(
        schools: updated,
        error: null,
      ),
    );
  }
}
