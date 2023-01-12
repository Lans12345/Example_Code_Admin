import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

Future addCateg(String name) async {
  final docUser = FirebaseFirestore.instance.collection('Categ').doc();

  final json = {
    'name': name,
  };

  await docUser.set(json);
}
