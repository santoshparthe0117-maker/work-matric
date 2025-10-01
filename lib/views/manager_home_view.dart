import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/checkin_controller.dart';
import '../routes/app_pages.dart';

class ManagerHomeView extends StatelessWidget {
  final userCtrl = Get.find<UserController>();
  final auth = Get.find<AuthController>();
  final checkinCtrl = Get.find<CheckinController>();

  ManagerHomeView({super.key}) {
    userCtrl.loadWorkers(); // load workers initially
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // White color for drawer icon
        ),
        title: const Text(
          'Manager Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => userCtrl.loadWorkers(),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          final workers = userCtrl.workers;
          if (workers.isEmpty) {
            return const Center(
              child: Text(
                'No workers found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: workers.length,
            itemBuilder: (_, i) {
              final worker = workers[i];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
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
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                  ),
                  title: Text(
                    worker.name ?? 'Unnamed Worker',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    worker.email ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Delete Worker"),
                                content: const Text(
                                  "Are you sure you want to delete this worker? This action cannot be undone.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await userCtrl.deleteWorker(worker.id!);
                                      Get.back();
                                      Get.snackbar(
                                        "Deleted",
                                        "Worker has been deleted",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.white),
                    ],
                  ),
                  onTap: () {
                    Get.toNamed(Routes.WORKER_DETAIL,
                        arguments: {'uid': worker.id});
                  },
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 225, 55, 126),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          "Add Employee",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          final result = await Get.toNamed(Routes.ADD_EMPLOYEE);
          if (result == true) {
            await userCtrl.loadWorkers();
          }
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
              ),
              accountName: Text(auth.user?.email ?? ''),
              accountEmail: const Text("Manager"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/1077/1077012.png",
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF6A11CB)),
              title: const Text('Account'),
              onTap: () => Get.toNamed(Routes.ACCOUNT),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => auth.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
