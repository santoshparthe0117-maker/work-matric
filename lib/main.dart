import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  if (kIsWeb) {
    // Web requires explicit options
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB4uC-UH0FQApDQP4oZyXynvEerx8xicOA",
          authDomain: "work-matric.firebaseapp.com",
          projectId: "work-matric",
          storageBucket: "work-matric.firebasestorage.app",
          messagingSenderId: "589290053993",
          appId: "1:589290053993:web:2847a520d88579cd1fddf8"),
    );
  } else {
    // Android/iOS auto-detects from google-services.json / plist
    await Firebase.initializeApp();
  }
  InitialBinding().dependencies();

  runApp(const WorkMetricApp());
}

class WorkMetricApp extends StatelessWidget {
  const WorkMetricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WorkMetric',
      initialRoute: Routes.SPLASH_SCREEN,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}
