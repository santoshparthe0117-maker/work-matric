import 'package:flutter/material.dart';
import '../models/checkin_model.dart';
import 'package:intl/intl.dart';

class CheckinTile extends StatelessWidget {
  final CheckinModel checkin;
  const CheckinTile({super.key, required this.checkin});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(checkin.type == 'checkin' ? Icons.login : Icons.logout),
      title: Text(checkin.type.toUpperCase()),
      subtitle: Text('${checkin.address}\n${DateFormat.yMd().add_jm().format(checkin.timestamp)}'),
      isThreeLine: true,
    );
  }
}
