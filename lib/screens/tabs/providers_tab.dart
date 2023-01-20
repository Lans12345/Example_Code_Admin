import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProvidersTab extends StatefulWidget {
  const ProvidersTab({super.key});

  @override
  State<ProvidersTab> createState() => _ProvidersTabState();
}

class _ProvidersTabState extends State<ProvidersTab> {
  int _dropdownValue1 = 0;

  late bool userType = false;

  sendBanMessage(userEmail) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: userEmail,
      queryParameters: {
        'subject': 'Provider banned',
        'body': 'Input Message',
      },
    );

    await launch(emailLaunchUri.toString());
  }

  sendUnbanMessage(userEmail) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: userEmail,
      queryParameters: {
        'subject': 'Provider unbanned',
        'body': 'Input Message',
      },
    );

    await launch(emailLaunchUri.toString());
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BoldText(
                      label: 'List of Service Providers',
                      fontSize: 24,
                      color: Colors.blue),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                        child: DropdownButton(
                          underline: Container(color: Colors.transparent),
                          iconEnabledColor: Colors.black,
                          isExpanded: true,
                          value: _dropdownValue1,
                          items: [
                            DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  userType = false;
                                });
                              },
                              value: 0,
                              child: Center(
                                  child: Row(children: [
                                Text('Unbanned Providers',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'QRegular',
                                      color: Colors.black,
                                    ))
                              ])),
                            ),
                            DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  userType = true;
                                });
                              },
                              value: 1,
                              child: Center(
                                  child: Row(children: [
                                Text('Banned Providers',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'QRegular',
                                      color: Colors.black,
                                    ))
                              ])),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _dropdownValue1 = int.parse(value.toString());
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Providers')
                      .where('isDeleted', isEqualTo: userType)
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
                        child: DataTable(
                            border: TableBorder.all(
                              color: Colors.grey,
                            ),
                            columns: [
                              DataColumn(
                                  label: BoldText(
                                      label: 'No.',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Name',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Email',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Contact Number',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Website',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Ban\nProvider',
                                      fontSize: 12,
                                      color: Colors.black)),
                            ],
                            rows: [
                              for (int i = 0; i < data.size; i++)
                                DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color?>((Set<MaterialState> states) {
                                      if (i.floor().isEven) {
                                        return Colors.blueGrey[50];
                                      }
                                      return null; // Use the default value.
                                    }),
                                    cells: [
                                      DataCell(NormalText(
                                          label: '$i',
                                          fontSize: 12,
                                          color: Colors.grey)),
                                      DataCell(SizedBox(
                                        width: 100,
                                        child: NormalText(
                                            label: data.docs[i]['name'],
                                            fontSize: 12,
                                            color: Colors.grey),
                                      )),
                                      DataCell(NormalText(
                                          label: data.docs[i]['email'],
                                          fontSize: 12,
                                          color: Colors.grey)),
                                      DataCell(NormalText(
                                          label: data.docs[i]['contactNumber'],
                                          fontSize: 12,
                                          color: Colors.grey)),
                                      DataCell(SizedBox(
                                        width: 120,
                                        child: NormalText(
                                            label: data.docs[i]['url'],
                                            fontSize: 12,
                                            color: Colors.grey),
                                      )),
                                      userType
                                          ? DataCell(
                                              IconButton(
                                                onPressed: () {
                                                  sendUnbanMessage(
                                                      data.docs[i]['email']);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: NormalText(
                                                              label:
                                                                  'Provider unbanned succesfully!',
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)));
                                                  FirebaseFirestore.instance
                                                      .collection('Providers')
                                                      .doc(data.docs[i].id)
                                                      .update(
                                                          {'isDeleted': false});
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .check_circle_outline_outlined,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            )
                                          : DataCell(
                                              IconButton(
                                                onPressed: () {
                                                  sendBanMessage(
                                                      data.docs[i]['email']);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: NormalText(
                                                              label:
                                                                  'Provider banned succesfully!',
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)));
                                                  FirebaseFirestore.instance
                                                      .collection('Providers')
                                                      .doc(data.docs[i].id)
                                                      .update(
                                                          {'isDeleted': true});
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                    ])
                            ]),
                      ),
                    );
                  }),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
