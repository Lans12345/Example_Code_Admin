import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_serve_admin/screens/home_page.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class ProvidersPage extends StatelessWidget {
  ProvidersPage({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: NormalText(
                    label: 'Service Provider rejected!',
                    fontSize: 12,
                    color: Colors.white)));
            FirebaseFirestore.instance
                .collection('Providers')
                .doc(box.read('data')['id'])
                .update({'status': 'Accepted'});
          }),
      appBar: AppBar(
        title: NormalText(
            label: 'Viewing: ${box.read('data')['name']}',
            fontSize: 18,
            color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.network(
                    box.read('data')['logo'],
                    height: 300,
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldText(
                          label: 'Business Permit:',
                          fontSize: 14,
                          color: Colors.grey),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(
                        box.read('data')['permit'],
                        height: 300,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BoldText(
                      label: box.read('data')['name'],
                      fontSize: 18,
                      color: Colors.black),
                  NormalText(
                      label: box.read('data')['address'],
                      fontSize: 12,
                      color: Colors.grey),
                  NormalText(
                      label: box.read('data')['contactNumber'],
                      fontSize: 12,
                      color: Colors.grey),
                  NormalText(
                      label: "Open from: " + box.read('data')['open'],
                      fontSize: 10,
                      color: Colors.grey),
                  NormalText(
                      label: "To: " + box.read('data')['close'],
                      fontSize: 10,
                      color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
