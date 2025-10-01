import 'package:cloud_firestore/cloud_firestore.dart';

class CheckinModel {
  String? id;
  String userId;
  String userEmail;
  double latitude;
  double longitude;
  String address;
  DateTime timestamp;
  String type; // 'checkin' or 'checkout'

  CheckinModel({
    this.id,
    required this.userId,
    required this.userEmail,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userEmail': userEmail,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'timestamp': timestamp.toUtc(),
        'type': type,
      };

  factory CheckinModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    final t = m['timestamp'];
    DateTime dt;
    if (t is Timestamp) {
      dt = t.toDate();
    } else if (t is DateTime) {
      dt = t;
    } else {
      dt = DateTime.tryParse(t?.toString() ?? '') ?? DateTime.now();
    }
    return CheckinModel(
      id: doc.id,
      userId: (m['userId'] ?? '') as String,
      userEmail: (m['userEmail'] ?? '') as String,
      latitude: (m['latitude'] ?? 0.0).toDouble(),
      longitude: (m['longitude'] ?? 0.0).toDouble(),
      address: (m['address'] ?? '') as String,
      timestamp: dt,
      type: (m['type'] ?? 'checkin') as String,
    );
  }
}
