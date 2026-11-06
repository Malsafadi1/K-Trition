import 'package:flutter/material.dart';

import '../data/nutrition_repository.dart';
import '../features/dashboard/dashboard_screen.dart';

class KTritionApp extends StatelessWidget {
  const KTritionApp({required this.repository, super.key});

  final NutritionRepository repository;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'K-Trition',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD65A24)),
      useMaterial3: true,
    ),
    home: DashboardScreen(repository: repository),
  );
}
