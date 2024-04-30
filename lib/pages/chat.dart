import 'package:agentapp/common/constant.dart';
import 'package:agentapp/pages/chatpage.dart';
import 'package:agentapp/pages/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesProperty extends StatefulWidget {
  final String email;
  final String username;
  const MessagesProperty({
    super.key,
    required this.email,
    required this.username,
  });

  @override
  State<MessagesProperty> createState() => _MessagesPropertyState();
}

class _MessagesPropertyState extends State<MessagesProperty> {
  Map<String, String> chatPeopleList = {'': ""};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      // drawer: NavDrawer(
      //   email: widget.email,
      //   name: widget.username,
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Agents')
            .doc(widget.email)
            .collection('Chat History')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                width: double.maxFinite,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () {
                    Get.to(ChatPage(
                      receiverEmail: document.id,
                      receiverName: data['Sender'],
                      myEmail: widget.email,
                      myName: widget.username,
                      userType: data['User Type'],
                    ));
                  },
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        CupertinoIcons.person_circle_fill,
                        size: 45,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['Sender'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data['Last Message'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 57, 57, 57)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        (data['User Type'] == "Seller") ? "SELLER" : "BUYER",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: appColor,
                            fontSize: 13),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
