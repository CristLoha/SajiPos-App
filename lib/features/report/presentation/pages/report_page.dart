import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';
import 'report_mobile_page.dart';
import 'report_tablet_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<ReportBloc>();
    if (bloc.state is! ReportLoaded) {
      bloc.add(FetchTodaySummary());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ReportError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onFocusChange: null,
                    onPressed: () =>
                        context.read<ReportBloc>().add(FetchTodaySummary()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ReportLoaded) {
          return ResponsiveLayout(
            mobile: ReportMobilePage(summary: state.summary),
            tablet: ReportTabletPage(summary: state.summary),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
