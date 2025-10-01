import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../controllers/checkin_controller.dart';

class WorkerHomeSection extends StatelessWidget {
  final dynamic user;
  WorkerHomeSection({super.key, required this.user});

  final checkinCtrl = Get.find<CheckinController>();

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: Text('Not logged in'));

    checkinCtrl.loadPersonalHistory(user.uid);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 70, 10, 133), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Swipe to Check-in or Check-out',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Obx(() {
                final history = checkinCtrl.personalHistory;
                final todayStr =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
                bool checkedIn = false;
                bool checkedOut = false;

                for (var c in history) {
                  final cDateStr = DateFormat('yyyy-MM-dd').format(c.timestamp);
                  if (cDateStr == todayStr) {
                    if (c.type == 'checkin') checkedIn = true;
                    if (c.type == 'checkout') checkedOut = true;
                  }
                }

                return Column(
                  children: [
                    if (checkinCtrl.loading.value)
                      const LinearProgressIndicator(
                        backgroundColor: Colors.white30,
                        color: Colors.white,
                      ),
                    const SizedBox(height: 30),
                    SlideAction(
                      borderRadius: 35,
                      innerColor: Colors.white,
                      outerColor: checkedIn
                          ? Colors.grey.shade400
                          : Colors.greenAccent.shade400,
                      sliderButtonIcon: Icon(
                        Icons.login,
                        color: checkedIn
                            ? Colors.grey.shade700
                            : Colors.green.shade700,
                      ),
                      text: checkedIn
                          ? 'Already Checked-in'
                          : 'Slide to Check-in',
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      enabled: !checkedIn && !checkinCtrl.loading.value,
                      onSubmit: () async {
                        await checkinCtrl.performCheck(
                          user.uid,
                          user.email ?? '',
                          'checkin',
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    SlideAction(
                      borderRadius: 35,
                      innerColor: Colors.white,
                      outerColor: checkedOut
                          ? Colors.grey.shade400
                          : Colors.redAccent.shade400,
                      sliderButtonIcon: Icon(
                        Icons.logout,
                        color: checkedOut
                            ? Colors.grey.shade700
                            : Colors.red.shade700,
                      ),
                      text: checkedOut
                          ? 'Already Checked-out'
                          : 'Slide to Check-out',
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      enabled: !checkedOut && !checkinCtrl.loading.value,
                      onSubmit: () async {
                        await checkinCtrl.performCheck(
                          user.uid,
                          user.email ?? '',
                          'checkout',
                        );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
