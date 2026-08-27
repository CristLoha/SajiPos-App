import 'dart:io';

void main() {
  final file = File('lib/main.dart');
  String content = file.readAsStringSync();
  
  if (content.contains('Firebase.initializeApp')) return;

  final imports = '''
import 'package:firebase_core/firebase_core.dart';
import 'package:saji_pos_app/features/notification/presentation/bloc/notification_bloc.dart';
''';

  content = content.replaceFirst('import \'package:flutter/material.dart\';', '${imports}import \'package:flutter/material.dart\';');

  // Add Firebase.initializeApp inside main()
  content = content.replaceFirst('WidgetsFlutterBinding.ensureInitialized();', 'WidgetsFlutterBinding.ensureInitialized();\n  await Firebase.initializeApp();');

  // Add BlocProvider to MultiBlocProvider
  final blocString = 'BlocProvider(create: (_) => di.locator<NotificationBloc>()..add(InitializeNotificationEvent())),';
  content = content.replaceFirst('providers: [', 'providers: [\n        $blocString');

  file.writeAsStringSync(content);
}
