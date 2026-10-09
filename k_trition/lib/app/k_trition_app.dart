import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';

class KTritionApp extends StatelessWidget {
  const KTritionApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'K-Trition',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD65A24)),
      useMaterial3: true,
    ),
    home: const DashboardScreen(),
  );
}
