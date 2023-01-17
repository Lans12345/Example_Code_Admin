import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:the_serve_admin/screens/pages/providers_page.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class PendingTab extends StatefulWidget {
  const PendingTab({super.key});

  @override
  State<PendingTab> createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {
  int _dropdownValue1 = 0;

  late bool userType = false;

  late String msg = '';

  final box = GetStorage();

  sendBanMessage(userEmail, String newMsg) async {
    String username = 'aira.maniquez@lorma.edu';
    String password = 'Percival12';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(userEmail)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'PERMISSION STATUS'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>$newMsg</h1>";

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
              BoldText(
                  label: 'Pending Service Providers',
                  fontSize: 24,
                  color: Colors.blue),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Providers')
                      // .where('status', isEqualTo: 'Pending')
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
                                      label: '',
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
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              tooltip:
                                                  'View/Validate Service Provider',
                                              onPressed: () {
                                                box.write('data', data.docs[i]);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProvidersPage()));
                                              },
                                              icon: Icon(
                                                Icons.visibility,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            IconButton(
                                              tooltip:
                                                  'Reject Service Provider',
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      return Dialog(
                                                        child: SizedBox(
                                                          width: 200,
                                                          height: 200,
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        30,
                                                                        10,
                                                                        30,
                                                                        10),
                                                                child:
                                                                    TextFormField(
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'State a reason',
                                                                        ),
                                                                        onChanged:
                                                                            ((value) {
                                                                          msg =
                                                                              value;
                                                                        })),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              MaterialButton(
                                                                  color: Colors
                                                                      .blue,
                                                                  minWidth: 200,
                                                                  height: 50,
                                                                  child: NormalText(
                                                                      label:
                                                                          'Continue',
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .white),
                                                                  onPressed:
                                                                      (() {
                                                                    sendBanMessage(
                                                                        data.docs[i]
                                                                            [
                                                                            'email'],
                                                                        msg);
                                                                    Navigator.of(
                                                                        context);
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                        content: NormalText(
                                                                            label:
                                                                                'Service Provider rejected!',
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white)));
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Providers')
                                                                        .doc(data
                                                                            .docs[
                                                                                i]
                                                                            .id)
                                                                        .update({
                                                                      'status':
                                                                          'Rejected'
                                                                    });
                                                                  }))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }));
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
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
