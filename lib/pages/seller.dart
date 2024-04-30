import 'package:agentapp/common/constant.dart';
import 'package:agentapp/pages/chatpage.dart';
import 'package:agentapp/pages/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Agents extends StatefulWidget {
  final String email;
  final String username;
  const Agents({
    super.key,
    required this.email,
    required this.username,
  });

  @override
  State<Agents> createState() => _AgentsState();
}

class _AgentsState extends State<Agents> {
  Map<String, String> myAgentEmailsMap = {'': ""};

  @override
  void initState() {
    super.initState();
    getUniqueAgentEmailsAndNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavDrawer(
      //   email: widget.email,
      //   name: widget.username,
      // ),
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Stack(
          children: [
            if (myAgentEmailsMap.isNotEmpty)
              ListView.builder(
                itemCount: myAgentEmailsMap.length,
                itemBuilder: (context, index) {
                  final List<String> agentEmails =
                      myAgentEmailsMap.keys.toList();
                  final String agentEmail = agentEmails[index];
                  final String agentName = myAgentEmailsMap[agentEmail]!;
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                agentName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.to(ChatPage(
                                        receiverEmail: agentEmail,
                                        receiverName: agentName,
                                        myEmail: widget.email,
                                        myName: widget.username,
                                        userType: 'Seller',
                                      ));
                                    },
                                    icon: const Icon(Icons.message)),
                                ZegoSendCallInvitationButton(
                                  onPressed: (code, message, p2) async {
                                    DateTime nowTime = DateTime.now();
                                    await FirebaseFirestore.instance
                                        .collection('Agents')
                                        .doc(widget.email)
                                        .collection('Call History')
                                        .doc()
                                        .set({
                                      'Name': agentName,
                                      'CallID': agentEmail,
                                      'Direction': "Outgoing",
                                      'Date-Time': nowTime,
                                      'User Type': "Seller",
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(agentEmail)
                                        .collection('Call History')
                                        .doc()
                                        .set({
                                      'Name': widget.username,
                                      'CallID': widget.email,
                                      'Direction': "Incoming",
                                      'Date-Time': nowTime,
                                      'User Type': 'Agents',
                                    });
                                    setState(() {});
                                  },
                                  notificationTitle: widget.username,
                                  notificationMessage: "Agent is calling you",
                                  buttonSize: const Size(50, 50),
                                  icon:
                                      ButtonIcon(icon: const Icon(Icons.call)),
                                  iconSize: const Size(40, 40),
                                  isVideoCall: false,
                                  resourceID: "zego_sokoni",
                                  invitees: [
                                    ZegoUIKitUser(
                                      id: agentEmail,
                                      name: agentName,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void getUniqueAgentEmailsAndNames() async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('Agents')
        .doc(widget.email)
        .collection('Sellers');
    try {
      QuerySnapshot querySnapshot = await collection.get();
      Map<String, String> agentEmailsMap = {};

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
        if (data != null &&
            data.containsKey('Seller Email') &&
            data.containsKey('Seller Name')) {
          agentEmailsMap[data['Seller Email']] = data['Seller Name'];
        }
      }

      setState(() {
        myAgentEmailsMap = agentEmailsMap;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching data: $error");
      }
    }
  }
}
