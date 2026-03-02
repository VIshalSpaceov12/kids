import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/local/local_storage_service.dart';
import 'data/providers/app_state_provider.dart';
import 'data/providers/progress_provider.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/progress_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Lock to portrait mode for kids
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final storageService = LocalStorageService(prefs);
  final apiService = ApiService(prefs);
  final authService = AuthService(apiService);
  final progressSyncService = ProgressSyncService(apiService);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        Provider<AuthService>.value(value: authService),
        Provider<ProgressSyncService>.value(value: progressSyncService),
        ChangeNotifierProvider(
          create: (_) => AppStateProvider(storageService, authService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgressProvider(storageService, progressSyncService, apiService),
        ),
      ],
      child: const ChhotuGeniusApp(),
    ),
  );
}
