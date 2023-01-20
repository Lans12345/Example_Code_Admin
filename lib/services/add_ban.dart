import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future addBan(String id, String reason) async {
  final docUser = FirebaseFirestore.instance.collection('Ban').doc(id);

  final json = {
    'reason': reason,
  };

  await docUser.set(json);
}
