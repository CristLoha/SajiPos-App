import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_today_summary.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetTodaySummary getTodaySummary;

  ReportBloc({required this.getTodaySummary}) : super(ReportInitial()) {
    on<FetchTodaySummary>(_onFetchTodaySummary);
  }

  Future<void> _onFetchTodaySummary(
    FetchTodaySummary event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    final result = await getTodaySummary();
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (summary) => emit(ReportLoaded(summary)),
    );
  }
}
