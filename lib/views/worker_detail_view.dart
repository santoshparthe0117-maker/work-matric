import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/checkin_controller.dart';
import 'package:intl/intl.dart';

class WorkerDetailView extends StatelessWidget {
  final args = Get.arguments as Map<String, dynamic>?;
  final userCtrl = Get.find<UserController>();
  final checkinCtrl = Get.find<CheckinController>();

  WorkerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = args?['uid'] as String?;

    if (uid != null) {
      checkinCtrl.loadPersonalHistory(uid);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(), // Navigate to previous page
        ),
        title: const Text(
          'Worker Detail',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 44, 87),
                Color.fromARGB(255, 225, 55, 126)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: uid == null
          ? const Center(
              child: Text(
                'No worker selected',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : FutureBuilder(
              future: userCtrl.getUserById(uid),
              builder: (context, snapUser) {
                if (snapUser.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final user = snapUser.data;
                return Column(
                  children: [
                    // User Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              color: Color(0xFF6A11CB), size: 30),
                        ),
                        title: Text(
                          user?.name ?? 'Worker',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          user?.email ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const Divider(),
                    // Check-in History
                    Expanded(
                      child: Obx(() {
                        if (checkinCtrl.loading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final items = checkinCtrl.personalHistory;
                        if (items.isEmpty) {
                          return const Center(
                            child: Text(
                              'No records',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        final sortedItems = [...items];
                        sortedItems
                            .sort((a, b) => b.timestamp.compareTo(a.timestamp));

                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: sortedItems.length,
                          itemBuilder: (_, i) {
                            final c = sortedItems[i];
                            final isCheckIn = c.type == 'checkin';
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: isCheckIn
                                      ? [
                                          Color.fromARGB(255, 61, 199, 121),
                                          Color.fromARGB(255, 5, 149, 34)
                                        ]
                                      : [
                                          const Color.fromARGB(
                                              255, 227, 60, 60),
                                          const Color.fromARGB(255, 137, 12, 8)
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.3),
                                  child: Icon(
                                    isCheckIn ? Icons.login : Icons.logout,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  c.type.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (c.address != null)
                                      Text(
                                        c.address!,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      c.timestamp != null
                                          ? DateFormat('dd/MM/yy – hh:mm a')
                                              .format(c.timestamp!)
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
