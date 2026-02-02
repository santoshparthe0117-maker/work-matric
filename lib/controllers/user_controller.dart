import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseApp, Firebase;
import 'package:get/get.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  final firestore = Get.find<FirestoreService>();

  /// Observable list of workers
  var workers = <AppUser>[].obs;

  /// Load all workers from Firestore
  Future<void> loadWorkers() async {
    try {
      final list = await firestore.getWorkersList();
      workers.assignAll(
        list.map((m) {
          final id = m['id'] as String;
          final data = m['data'] as Map<String, dynamic>;
          return AppUser.fromMap(id, data);
        }),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load workers: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Get a single worker by UID
  Future<AppUser?> getUserById(String uid) async {
    try {
      final data = await firestore.getUserDoc(uid);
      if (data != null) {
        return AppUser.fromMap(uid, data);
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Delete a worker from Firestore and update local list
  Future<void> deleteWorker(String uid) async {
    try {
      await firestore.deleteUser(uid);
      workers.removeWhere((w) => w.id == uid);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete worker: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Add a new worker (FirebaseAuth + Firestore + update local list)
  Future<void> addWorker(String email, String name, String password) async {
    try {
      // Step 1: Initialize a secondary Firebase App
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      // Step 2: Create a secondary FirebaseAuth instance
      FirebaseAuth secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      // Step 3: Create the worker user
      final cred = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      // Step 4: Create worker document in Firestore
      await firestore.createUserDocument(uid, email, 'worker', name: name);

      // Step 5: Clean up secondary app
      await secondaryAuth.signOut();
      await secondaryApp.delete();

      // Step 6: Refresh your list
      final newUser = await getUserById(uid);
      if (newUser != null) {
        workers.add(newUser);
      }
      Get.back();

      Get.snackbar(
        'Success',
        'Employee added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Add Worker Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
