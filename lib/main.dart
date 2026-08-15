import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/history_service.dart';
import 'services/star_service.dart';
import 'theme/hazmat_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StarService.instance.load();
  await HistoryService.instance.load();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HazMatProApp());
}

class HazMatProApp extends StatelessWidget {
  const HazMatProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HazMat Pro - MSDS & UN Number',
      debugShowCheckedModeBanner: false,
      theme: HMTheme.theme,
      home: const AppShell(),
    );
  }
}
