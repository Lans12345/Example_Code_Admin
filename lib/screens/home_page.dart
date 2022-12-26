import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:the_serve_admin/screens/tabs/products_tab.dart';
import 'package:the_serve_admin/screens/tabs/providers_tab.dart';
import 'package:the_serve_admin/screens/tabs/users_tab.dart';
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
                  title: 'Users',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.person),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Providers',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.home_repair_service_rounded),
                ),
                SideMenuItem(
                  priority: 2,
                  title: 'Products',
                  onTap: () {
                    page.jumpToPage(2);
                  },
                  icon: const Icon(Icons.card_giftcard_sharp),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: const [
                // AccountsTab(),
                // TradeTab(),
                // ItemsTab(),
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
