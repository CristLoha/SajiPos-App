import 'package:equatable/equatable.dart';
import '../../domain/entities/report_summary.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final ReportSummary summary;

  const ReportLoaded(this.summary);

  @override
  List<Object> get props => [summary];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}
