import 'package:get/get.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../models/checkin_model.dart';

class CheckinController extends GetxController {
  final firestore = Get.find<FirestoreService>();
  final loc = Get.find<LocationService>();
  var loading = false.obs;

  /// Reactive list for worker history
  var personalHistory = <CheckinModel>[].obs;
  var loadinghistory = false.obs;

  /// Keep track of current subscription to avoid multiple listeners
  Rxn<String> _currentUserId = Rxn<String>();

  Future<void> performCheck(
      String userId, String userEmail, String type) async {
    loading.value = true;
    try {
      final pos = await loc.getCurrentPosition();
      final addr = await loc.getAddressFromLatLng(pos.latitude, pos.longitude);
      final model = CheckinModel(
        userId: userId,
        userEmail: userEmail,
        latitude: pos.latitude,
        longitude: pos.longitude,
        address: addr,
        timestamp: DateTime.now().toUtc(),
        type: type,
      );

      await firestore.addCheckin(model.toMap());

      // Add to reactive list immediately
      personalHistory.insert(0, model);

      Get.snackbar(
        'Success',
        '$type recorded',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  /// Load personal history with persistent stream
  void loadPersonalHistory(String uid) {
    // Avoid re-subscribing if same user
    // if (_currentUserId.value == uid) return;
    // _currentUserId.value = uid;

    // 🔹 Show loader while waiting for first snapshot
    loading.value = true;

    firestore.streamCheckinsForUser(uid).listen(
      (snap) {
        personalHistory.value =
            snap.docs.map((d) => CheckinModel.fromDoc(d)).toList();
        // 🔹 Turn loader OFF after data arrives
        loading.value = false;
      },
      onError: (err) {
        print("Error loading history: $err");
        loading.value = false;
      },
    );
  }

  /// Manager: all check-ins for today
  Stream<List<CheckinModel>> streamAllToday() {
    final today = DateTime.now();
    return firestore.streamCheckinsForDate(today).map(
          (snap) => snap.docs.map((d) => CheckinModel.fromDoc(d)).toList(),
        );
  }

  /// Manager: history of a specific worker
  Stream<List<CheckinModel>> streamWorkerHistory(String uid) {
    return firestore.streamCheckinsForUser(uid).map(
          (snap) => snap.docs
              .map((d) => CheckinModel.fromDoc(d))
              .where((checkin) => checkin.userId == uid)
              .toList(),
        );
  }
}
