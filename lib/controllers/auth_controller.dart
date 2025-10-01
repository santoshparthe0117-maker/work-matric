import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _user = Rxn<User>();
  User? get user => _user.value;
  final firestore = Get.find<FirestoreService>();

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((u) async {
      _user.value = u;
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Login failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<String?> register(String email, String password, String role,
      {String? name}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;
      await firestore.createUserDocument(uid, email, role, name: name);
      return uid;
    } catch (e) {
      Get.snackbar(
        'Register failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateDisplayName(String name) async {
    final u = _auth.currentUser;
    if (u != null) {
      await u.updateDisplayName(name);
      await firestore.updateUserDoc(u.uid, {'name': name});
      update();
    }
  }
}
