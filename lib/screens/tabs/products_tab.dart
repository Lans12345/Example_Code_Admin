import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoldText(
                label: 'List of Products', fontSize: 24, color: Colors.blue),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Products')
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
                                label: 'Image',
                                fontSize: 12,
                                color: Colors.white)),
                        DataColumn(
                            label: NormalText(
                                label: 'Name',
                                fontSize: 12,
                                color: Colors.white)),
                        DataColumn(
                            label: NormalText(
                                label: 'Price',
                                fontSize: 12,
                                color: Colors.white)),
                        DataColumn(
                            label: NormalText(
                                label: 'Description',
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
                                minRadius: 50,
                                maxRadius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  data.docs[i]['imageURL'],
                                ),
                              ),
                            )),
                            DataCell(NormalText(
                                label: data.docs[i]['name'],
                                fontSize: 14,
                                color: Colors.white)),
                            DataCell(NormalText(
                                label: '${data.docs[i]['price']}.00php',
                                fontSize: 14,
                                color: Colors.white)),
                            DataCell(NormalText(
                                label: data.docs[i]['desc'],
                                fontSize: 14,
                                color: Colors.white)),
                          ])
                      ]),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
