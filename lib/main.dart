import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'routes/router_config.dart';
import 'ai/services/tflite_service.dart';
import 'ai/services/recommendation_service.dart';
import 'features/face_scan/controllers/face_scan_controller.dart';
import 'features/lifestyle/controllers/lifestyle_controller.dart';
import 'features/recommendation/controllers/recommendation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TFLiteService>(create: (_) => TFLiteService()),
        Provider<RecommendationService>(create: (_) => RecommendationService()),
        ChangeNotifierProvider(create: (_) => FaceScanController()),
        ChangeNotifierProvider(create: (_) => LifestyleController()),
        ChangeNotifierProxyProvider2<FaceScanController, LifestyleController,
            RecommendationController>(
          create: (ctx) => RecommendationController(
            RecommendationService(),
          ),
          update: (ctx, faceScan, lifestyle, prev) =>
              prev!..updateInputs(faceScan, lifestyle),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Smart Glasses AI',
        routerConfig: appRouter,
      ),
    );
  }
}
