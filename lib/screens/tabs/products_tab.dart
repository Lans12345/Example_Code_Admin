import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class ProductsTab extends StatefulWidget {
  const ProductsTab({super.key});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  int _dropdownValue1 = 0;

  late String category = '';

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
                      label: 'List of Products',
                      fontSize: 24,
                      color: Colors.blue),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 50),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Categ')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            print('waiting');
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data12 = snapshot.requireData;
                          return Container(
                            width: 350,
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
                                  for (int i = 0; i < data12.size; i++)
                                    DropdownMenuItem(
                                      onTap: () {
                                        setState(() {
                                          category = data12.docs[i]['name'];
                                        });
                                      },
                                      value: i,
                                      child: Center(
                                          child: Row(children: [
                                        Text(data12.docs[i]['name'],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'QRegular',
                                              color: Colors.black,
                                            ))
                                      ])),
                                    ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _dropdownValue1 =
                                        int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: category == ''
                      ? FirebaseFirestore.instance
                          .collection('Products')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('Products')
                          .where('type', isEqualTo: category)
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
                                      label: 'Image',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Name',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Price',
                                      fontSize: 16,
                                      color: Colors.black)),
                              DataColumn(
                                  label: BoldText(
                                      label: 'Description',
                                      fontSize: 16,
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
                                          minRadius: 50,
                                          maxRadius: 50,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                            data.docs[i]['imageURL'],
                                          ),
                                        ),
                                      )),
                                      DataCell(NormalText(
                                          label: data.docs[i]['name'],
                                          fontSize: 14,
                                          color: Colors.grey)),
                                      DataCell(NormalText(
                                          label:
                                              '${data.docs[i]['price']}.00php',
                                          fontSize: 14,
                                          color: Colors.grey)),
                                      DataCell(NormalText(
                                          label: data.docs[i]['desc'],
                                          fontSize: 14,
                                          color: Colors.grey)),
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
