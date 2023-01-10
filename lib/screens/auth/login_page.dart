import 'package:flutter/material.dart';
import 'package:the_serve_admin/screens/home_page.dart';
import 'package:the_serve_admin/widgets/text_widget.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final passConttroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back.png'), fit: BoxFit.fitHeight),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 800),
              child: Card(
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 500,
                  width: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        BoldText(
                            label: 'Hi, Welcome to',
                            fontSize: 24,
                            color: Colors.blue),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          'assets/logo.png',
                          height: 125,
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            minWidth: 300,
                            height: 60,
                            color: Colors.blue,
                            child: NormalText(
                                label: 'CONTINUE',
                                fontSize: 18,
                                color: Colors.white),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return Dialog(
                                      child: Container(
                                        color: Colors.blue,
                                        height: 300,
                                        width: 300,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BoldText(
                                                label: 'Enter Admin Passcode',
                                                fontSize: 14,
                                                color: Colors.white),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30, right: 30),
                                              child: Container(
                                                color: Colors.white,
                                                child: TextFormField(
                                                  obscureText: true,
                                                  controller: passConttroller,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                minWidth: 220,
                                                height: 60,
                                                color: Colors.white,
                                                child: NormalText(
                                                    label: 'CONTINUE',
                                                    fontSize: 18,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  if (passConttroller.text ==
                                                      'admin123') {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomeScreen()));
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        duration: Duration(
                                                            seconds: 5),
                                                        content: Text(
                                                            'Passcode Incorrect!'),
                                                      ),
                                                    );
                                                    Navigator.of(context).pop();
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    );
                                  }));
                            }),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
