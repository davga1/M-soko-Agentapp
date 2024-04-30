import 'package:agentapp/common/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  String receiverName;
  String receiverEmail;
  String myName;
  String myEmail;
  String userType;
  ChatPage({
    super.key,
    required this.myEmail,
    required this.myName,
    required this.receiverEmail,
    required this.receiverName,
    required this.userType,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  String roomID = "";

  @override
  void initState() {
    super.initState();
    findChatRoomId(widget.receiverEmail, widget.myEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          widget.receiverName,
          style: const TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        leading: Builder(builder: (BuildContext builderContext) {
          return InkWell(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: whiteColor,
            ),
          );
        }),
        actions: [
          ZegoSendCallInvitationButton(
            onPressed: (code, message, p2) async {
              DateTime nowTime = DateTime.now();
              await FirebaseFirestore.instance
                  .collection("Agents")
                  .doc(widget.myEmail)
                  .collection('Call History')
                  .doc()
                  .set({
                'Name': widget.receiverName,
                'CallID': widget.receiverEmail,
                'Direction': "Outgoing",
                'Date-Time': nowTime,
                'User Type': widget.userType,
              });
              await FirebaseFirestore.instance
                  .collection(
                      (widget.userType == "Seller") ? "users" : widget.userType)
                  .doc(widget.receiverEmail)
                  .collection('Call History')
                  .doc()
                  .set({
                'Name': widget.myName,
                'CallID': widget.myEmail,
                'Direction': "Incoming",
                'Date-Time': nowTime,
                'User Type': "Agents",
              });
              setState(() {});
            },
            notificationTitle: widget.myName,
            notificationMessage: "Agent is calling you",
            buttonSize: const Size(50, 50),
            icon: ButtonIcon(
                icon: const Icon(
              Icons.call,
              color: Colors.white,
            )),
            iconSize: const Size(40, 40),
            isVideoCall: false,
            resourceID: "zego_sokoni",
            invitees: [
              ZegoUIKitUser(
                id: widget.receiverEmail,
                name: widget.receiverName,
              )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                (widget.userType == "Seller")
                    ? "Property Seller"
                    : "Property Buyer",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          if (roomID == "")
            const Expanded(
                child: Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator()))),
          if (roomID != "")
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(roomID)
                    .collection('messages')
                    .orderBy('Date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      if (data['Sender'] == widget.receiverEmail) {
                        // FirebaseFirestore.instance
                        //     .collection('chatrooms')
                        //     .doc(roomID)
                        //     .collection('messages')
                        //     .doc(document.id)
                        //     .update({'Seen': 'True'});
                        return ListTile(
                          title: Container(
                              margin: const EdgeInsets.only(right: 30),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: Text(
                                data['Text'],
                                textAlign: TextAlign.left,
                              )),
                        );
                      }
                      if (data['Sender'] == widget.myEmail) {
                        return ListTile(
                          title: Container(
                              margin: const EdgeInsets.only(left: 30),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 184, 197, 228),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['Text'],
                                    textAlign: TextAlign.left,
                                  ),
                                  // if (data['Seen'] == "True")
                                  //   const Align(
                                  //     alignment: Alignment.bottomRight,
                                  //     child: Text(
                                  //       "seen",
                                  //       style: TextStyle(
                                  //           color: Color.fromARGB(
                                  //               255, 86, 109, 163),
                                  //           fontSize: 13),
                                  //     ),
                                  //   )
                                ],
                              )),
                        );
                      }
                      return null;
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (value) {},
                    style:
                        const TextStyle(color: Colors.black), // Set text color
                    cursorColor: Colors.black, // Set cursor color
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.fromLTRB(25, 3, 25, 3),
                      hintText: 'Write message here',
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 98, 98, 98)
                              .withOpacity(0.5)), // Set hint text color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Colors.transparent), // Set border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color:
                                Colors.transparent), // Set enabled border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color:
                                Colors.transparent), // Set focused border color
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: appColor, borderRadius: BorderRadius.circular(30)),
                  width: 60,
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (_textController.text == "") {
                        Fluttertoast.showToast(
                          msg: "Message cannot be empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      } else {
                        if (roomID == "blank") {
                          DocumentReference<Map<String, dynamic>>
                              newChatRoomRef = FirebaseFirestore.instance
                                  .collection('chatrooms')
                                  .doc();
                          await newChatRoomRef.set({
                            'Last Message': "",
                            'Participants': [
                              widget.myEmail,
                              widget.receiverEmail
                            ],
                          }).then((value) {
                            setState(() {
                              roomID = newChatRoomRef.id;
                            });
                          });
                          String x = _textController.text;
                          _textController.text = "";
                          await FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(roomID)
                              .collection('messages')
                              .doc('${DateTime.now().millisecondsSinceEpoch}')
                              .set({
                            'Date': DateTime.now(),
                            'Seen': "False",
                            'Sender': widget.myEmail,
                            'Text': x,
                            'Type': "message",
                          });
                          await FirebaseFirestore.instance
                              .collection('Agents')
                              .doc(widget.myEmail)
                              .collection('Chat History')
                              .doc(widget.receiverEmail)
                              .set({
                            'Last Message Date': DateTime.now(),
                            'Last Message': x,
                            'Sender': widget.receiverName,
                            'User Type': widget.userType
                          });
                          await FirebaseFirestore.instance
                              .collection((widget.userType == "Seller")
                                  ? "users"
                                  : widget.userType)
                              .doc(widget.receiverEmail)
                              .collection('Chat History')
                              .doc(widget.myEmail)
                              .set({
                            'Last Message Date': DateTime.now(),
                            'Last Message': x,
                            'Sender': widget.myName,
                            'User Type': 'Agents'
                          });
                        } else if (roomID != "") {
                          String x = _textController.text;
                          _textController.text = "";
                          await FirebaseFirestore.instance
                              .collection('chatrooms')
                              .doc(roomID)
                              .collection('messages')
                              .doc('${DateTime.now().millisecondsSinceEpoch}')
                              .set({
                            'Date': DateTime.now(),
                            'Seen': "False",
                            'Sender': widget.myEmail,
                            'Text': x,
                            'Type': "message",
                          }); //
                          await FirebaseFirestore.instance
                              .collection('Agents')
                              .doc(widget.myEmail)
                              .collection('Chat History')
                              .doc(widget.receiverEmail)
                              .update({
                            'Last Message Date': DateTime.now(),
                            'Last Message': x,
                          });
                          await FirebaseFirestore
                              .instance // specific for Agents
                              .collection((widget.userType == "Seller")
                                  ? "users"
                                  : widget.userType) // specific for Agents
                              .doc(widget.receiverEmail) // specific for Agents
                              .collection('Chat History') // specific for Agents
                              .doc(widget.myEmail) // specific for Agents
                              .update({
                            // specific for Agents
                            'Last Message Date':
                                DateTime.now(), // specific for Agents
                            'Last Message': x,
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void findChatRoomId(String participantId1, String participantId2) async {
    try {
      String localRoomID = "";
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('chatrooms').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> room
          in querySnapshot.docs) {
        List<dynamic>? participants = room.data()['Participants'];

        if (participants != null &&
            participants.contains(participantId1) &&
            participants.contains(participantId2)) {
          setState(() {
            localRoomID = room.id;
          });
        }
      }
      if (localRoomID == "") {
        setState(() {
          roomID = "blank";
        });
      } else {
        setState(() {
          roomID = localRoomID;
        });
      }
    } catch (e) {}
  }
}
