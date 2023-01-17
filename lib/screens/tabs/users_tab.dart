import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class UsersTab extends StatefulWidget {
  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  int _dropdownValue1 = 0;

  late bool userType = false;

  sendBanMessage(userEmail) async {
    String username = 'aira.maniquez@lorma.edu';
    String password = 'Percival12';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(userEmail)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'ACCOUNT STATUS'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Your account has been banned!</h1>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print(e);
      for (var p in e.problems) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: NormalText(
                label: '${p.code}: ${p.msg}',
                fontSize: 12,
                color: Colors.white)));
      }
    }
  }

  sendUnbanMessage(userEmail) async {
    String username = 'aira.maniquez@lorma.edu';
    String password = 'Percival12';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(userEmail)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'ACCOUNT STATUS'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Your account has been unbanned!</h1>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print(e);
      for (var p in e.problems) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: NormalText(
                label: '${p.code}: ${p.msg}',
                fontSize: 12,
                color: Colors.white)));
      }
    }
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
                      label: 'List of Users', fontSize: 24, color: Colors.blue),
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
                                Text('Unbanned Users',
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
                                Text('Banned Users',
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
                      .collection('Users')
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
                                      label: 'Profile',
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
                                      label: 'Ban\nUser',
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
                                          fontSize: 14,
                                          color: Colors.grey)),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              data.docs[i]['profilePicture']),
                                          minRadius: 50,
                                          maxRadius: 50,
                                          backgroundColor: Colors.grey,
                                        ),
                                      )),
                                      DataCell(NormalText(
                                          label: data.docs[i]['name'],
                                          fontSize: 14,
                                          color: Colors.grey)),
                                      DataCell(NormalText(
                                          label: data.docs[i]['email'],
                                          fontSize: 14,
                                          color: Colors.grey)),
                                      DataCell(NormalText(
                                          label: data.docs[i]['contactNumber'],
                                          fontSize: 14,
                                          color: Colors.grey)),
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
                                                                  'User unbanned succesfully!',
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)));
                                                  FirebaseFirestore.instance
                                                      .collection('Users')
                                                      .doc(data.docs[i].id)
                                                      .update(
                                                          {'isDeleted': false});
                                                },
                                                icon: Icon(
                                                  Icons.visibility_off,
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
                                                                  'User banned succesfully!',
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)));
                                                  FirebaseFirestore.instance
                                                      .collection('Users')
                                                      .doc(data.docs[i].id)
                                                      .update(
                                                          {'isDeleted': true});
                                                },
                                                icon: Icon(
                                                  Icons.visibility_rounded,
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
