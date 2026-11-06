import 'package:flutter/material.dart';

import 'app/k_trition_app.dart';
import 'data/nutrition_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await NutritionRepository.open();
  runApp(KTritionApp(repository: repository));
}
