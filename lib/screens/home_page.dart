import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:the_serve_admin/screens/auth/login_page.dart';
import 'package:the_serve_admin/screens/tabs/pending_tab.dart';
import 'package:the_serve_admin/screens/tabs/products_tab.dart';
import 'package:the_serve_admin/screens/tabs/providers_tab.dart';
import 'package:the_serve_admin/screens/tabs/users_tab.dart';
import 'package:the_serve_admin/services/add_categ.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController page = PageController();

  final _categ = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue,
            child: SideMenu(
              controller: page,
              style: SideMenuStyle(
                  unselectedTitleTextStyle:
                      const TextStyle(color: Colors.white),

                  // showTooltip: false,
                  displayMode: SideMenuDisplayMode.auto,
                  hoverColor: Colors.blue,
                  selectedColor: Colors.black38,
                  selectedTitleTextStyle:
                      GoogleFonts.openSans(color: Colors.white),
                  selectedIconColor: Colors.white,
                  unselectedIconColor: Colors.white
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.all(Radius.circular(10)),
                  // ),
                  // backgroundColor: Colors.blueGrey[700]
                  ),
              title: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
              footer: Container(
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey))),
                child: Center(
                  child: NormalText(
                    label: 'All right reserved.',
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
              items: [
                SideMenuItem(
                  priority: 0,
                  title: 'Pending Providers',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.pending),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Users',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.person),
                ),
                SideMenuItem(
                  priority: 2,
                  title: 'Providers',
                  onTap: () {
                    page.jumpToPage(2);
                  },
                  icon: const Icon(Icons.home_repair_service_rounded),
                ),
                SideMenuItem(
                  priority: 3,
                  title: 'Products',
                  onTap: () {
                    page.jumpToPage(3);
                  },
                  icon: const Icon(Icons.card_giftcard_sharp),
                ),
                SideMenuItem(
                  priority: 4,
                  title: 'Categories',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SizedBox(
                              height: 500,
                              width: 500,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  BoldText(
                                      label: 'List of Categories',
                                      fontSize: 14,
                                      color: Colors.black),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Categ')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return const Center(
                                              child: Text('Error'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          print('waiting');
                                          return const Padding(
                                            padding: EdgeInsets.only(top: 50),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.black,
                                            )),
                                          );
                                        }

                                        final data = snapshot.requireData;
                                        return Expanded(
                                          child: SizedBox(
                                            child: ListView.separated(
                                                itemCount:
                                                    snapshot.data?.size ?? 0,
                                                separatorBuilder:
                                                    ((context, index) {
                                                  return Divider();
                                                }),
                                                itemBuilder: ((context, index) {
                                                  return ListTile(
                                                    leading: Icon(
                                                      Icons.category_rounded,
                                                      color: Colors.blue,
                                                    ),
                                                    title: NormalText(
                                                        label: data.docs[index]
                                                            ['name'],
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    trailing: IconButton(
                                                      onPressed: (() {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Categ')
                                                            .doc(data
                                                                .docs[index].id)
                                                            .delete();
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: NormalText(
                                                                label:
                                                                    'Category Deleted!',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        );
                                                      }),
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  );
                                                })),
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 10, 50, 10),
                                    child: TextFormField(
                                      controller: _categ,
                                      decoration: InputDecoration(
                                          labelText: 'Name of Category'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MaterialButton(
                                      minWidth: 150,
                                      height: 40,
                                      color: Colors.blue,
                                      child: NormalText(
                                          label: 'Add Category',
                                          fontSize: 12,
                                          color: Colors.white),
                                      onPressed: (() {
                                        if (_categ.text == '') {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: NormalText(
                                                  label:
                                                      'Cannot Procceed! Missing input',
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          );
                                          _categ.text = '';
                                        } else {
                                          addCateg(_categ.text);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: NormalText(
                                                label: 'Category Added!',
                                                fontSize: 14,
                                                color: Colors.white),
                                          ));

                                          _categ.text = '';
                                        }
                                      })),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => LandingPage()));
                  },
                  icon: const Icon(Icons.category),
                ),
                SideMenuItem(
                  priority: 5,
                  title: 'Logout',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LandingPage()));
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                // AccountsTab(),
                // TradeTab(),
                // ItemsTab(),
                PendingTab(),
                UsersTab(),
                ProvidersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
