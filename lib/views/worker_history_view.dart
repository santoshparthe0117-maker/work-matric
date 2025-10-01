import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/checkin_controller.dart';
import 'package:intl/intl.dart';

class WorkerHistoryView extends StatelessWidget {
  final auth = Get.find<AuthController>();
  final checkinCtrl = Get.find<CheckinController>();

  WorkerHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = auth.user?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Not logged in',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Load history once when screen builds
    checkinCtrl.loadPersonalHistory(uid);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        final items = checkinCtrl.personalHistory;

        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No history yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Sort descending by timestamp (latest first)
        final sortedItems = [...items];
        sortedItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: sortedItems.length,
          itemBuilder: (_, i) {
            final c = sortedItems[i];

            // Gradient colors based on checkin/out type

            final cardGradient = c.type == 'checkin'
                ? const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 61, 199, 121),
                      Color.fromARGB(255, 5, 149, 34)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 227, 60, 60),
                      const Color.fromARGB(255, 137, 12, 8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  );

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                gradient: cardGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(
                    c.type == 'checkin' ? Icons.login : Icons.logout,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  c.type.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (c.address != null)
                      Text(
                        c.address!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      c.timestamp != null
                          ? DateFormat('dd/MM/yy – hh:mm a')
                              .format(c.timestamp!)
                          : '',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
