import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

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
                  label: 'List of Users', fontSize: 24, color: Colors.blue),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('isDeleted', isEqualTo: false)
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
                                  label: 'Profile',
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
                              DataCell(Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      data.docs[i]['profilePicture']),
                                  minRadius: 50,
                                  maxRadius: 50,
                                  backgroundColor: Colors.white,
                                ),
                              )),
                              DataCell(NormalText(
                                  label: data.docs[i]['name'],
                                  fontSize: 14,
                                  color: Colors.white)),
                              DataCell(NormalText(
                                  label: data.docs[i]['email'],
                                  fontSize: 14,
                                  color: Colors.white)),
                              DataCell(NormalText(
                                  label: data.docs[i]['contactNumber'],
                                  fontSize: 14,
                                  color: Colors.white)),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(data.docs[i].id)
                                        .update({'isDeleted': true});
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
