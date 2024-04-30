import 'package:agentapp/common/bold_text.dart';
import 'package:agentapp/common/constant.dart';
import 'package:agentapp/common/plain_text.dart';
import 'package:agentapp/pages/agent_feedback.dart';
import 'package:agentapp/pages/call_history.dart';
import 'package:agentapp/pages/chat.dart';
import 'package:agentapp/pages/home_page.dart';
import 'package:agentapp/pages/seller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

String userName = '';
String useremail = '';

class _MainDrawerState extends State<MainDrawer> {
  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser!;
    String? username = user.displayName;
    String? userId = user.email;
    setState(() {
      userName = username.toString();
      useremail = userId.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(email: useremail, name: userName),
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.email,
    required this.name,
    super.key,
  });
  final String email;
  final String name;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

late List<Widget> _widgetOptions;

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePage(),
      Agents(email: widget.email, username: widget.name),
      MessagesProperty(email: widget.email, username: widget.name),
      CallsProperty(email: widget.email, username: widget.name),
      PFeedback(email: widget.email, name: widget.name)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          _selectedIndex == 0
              ? 'Home'
              : _selectedIndex == 1
                  ? 'Sellers'
                  : _selectedIndex == 2
                      ? 'Chat'
                      : _selectedIndex == 3
                          ? 'Call history'
                          : 'Send Feedback',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: appColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 85,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1)),
                      ],
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        // Default image or placeholder
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/hey.png"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 170,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.to(() => {});
                          },
                          child: SizedBox(
                            width: 304 - 160,
                            child: PlainText(
                              name: widget.name,
                              fontsize: 22,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        PlainText(
                          name: widget.email,
                          fontsize: 14,
                          color: whiteColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
              ),
              title: const BoldText(
                name: "Home",
                fontsize: 18,
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.man,
              ),
              title: const BoldText(
                name: "Sellers", //
                fontsize: 18,
              ),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.chat_bubble_sharp, //
              ),
              title: const BoldText(
                name: "Chat",
                fontsize: 18,
              ),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.call,
              ),
              title: const BoldText(
                name: "Call History", //
                fontsize: 18,
              ),
              selected: _selectedIndex == 3,
              onTap: () {
                // Update the state of the app
                _onItemTapped(3);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.chat_outlined,
              ),
              title: const BoldText(
                name: "Send FeedBack",
                fontsize: 18,
              ),
              selected: _selectedIndex == 4,
              onTap: () {
                // Update the state of the app
                _onItemTapped(4);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const BoldText(
                  name: "Log Out",
                  fontsize: 18,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          height: MediaQuery.sizeOf(context).height * 0.26,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius as needed
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Center(
                                    child: Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 27.0,
                                      fontWeight: FontWeight.w400),
                                )),
                                const SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        foregroundColor: Colors.blue,
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        ZegoUIKitPrebuiltCallInvitationService()
                                            .uninit();
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        foregroundColor: Colors.blue,
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
