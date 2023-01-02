import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class ProvidersTab extends StatelessWidget {
  const ProvidersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoldText(
                  label: 'List of Service Providers',
                  fontSize: 24,
                  color: Colors.blue),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Providers')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('waiting');
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                      );
                    }

                    final data = snapshot.requireData;
                    return Center(
                      child: Container(
                        color: Colors.blue,
                        child: DataTable(columns: [
                          DataColumn(
                              label: NormalText(
                                  label: 'No.',
                                  fontSize: 12,
                                  color: Colors.white)),
                          DataColumn(
                              label: NormalText(
                                  label: 'Name',
                                  fontSize: 12,
                                  color: Colors.white)),
                          DataColumn(
                              label: NormalText(
                                  label: 'Email',
                                  fontSize: 12,
                                  color: Colors.white)),
                          DataColumn(
                              label: NormalText(
                                  label: 'Contact Number',
                                  fontSize: 12,
                                  color: Colors.white)),
                          DataColumn(
                              label: NormalText(
                                  label: 'Website',
                                  fontSize: 12,
                                  color: Colors.white)),
                          DataColumn(
                              label: NormalText(
                                  label: '',
                                  fontSize: 12,
                                  color: Colors.white)),
                        ], rows: [
                          for (int i = 0; i < data.size; i++)
                            DataRow(cells: [
                              DataCell(NormalText(
                                  label: '$i',
                                  fontSize: 14,
                                  color: Colors.white)),
                              DataCell(SizedBox(
                                width: 100,
                                child: NormalText(
                                    label: data.docs[i]['name'],
                                    fontSize: 14,
                                    color: Colors.white),
                              )),
                              DataCell(NormalText(
                                  label: data.docs[i]['email'],
                                  fontSize: 14,
                                  color: Colors.white)),
                              DataCell(NormalText(
                                  label: data.docs[i]['contactNumber'],
                                  fontSize: 14,
                                  color: Colors.white)),
                              DataCell(SizedBox(
                                width: 120,
                                child: NormalText(
                                    label: data.docs[i]['url'],
                                    fontSize: 14,
                                    color: Colors.white),
                              )),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Providers')
                                        .doc(data.docs[i].id)
                                        .delete();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ])
                        ]),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
