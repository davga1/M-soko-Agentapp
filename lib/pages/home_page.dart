import 'package:agentapp/common/constant.dart';
import 'package:agentapp/common/plain_text.dart';
import 'package:agentapp/pages/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../call_invitation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> propertyItemsDataMap = {};
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final callTextCtrl = TextEditingController();
  String userName = "";
  String useremail = "";

  @override
  void initState() {
    super.initState();
    final zego = CallInvitationPage();
    User user = FirebaseAuth.instance.currentUser!;
    String? username = user.displayName;
    String? userId = user.email;
    zego.onUserLogin(userId!, username!);
    setState(() {
      userName = username.toString();
      useremail = userId.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 205, 205),
      key: scaffoldKey,
      // drawer: NavDrawer(
      //   email: useremail,
      //   name: userName,
      // ),
      body: CustomScrollView(
        slivers: [
          FutureBuilder<Map<String, dynamic>>(
            future: fetchDocumentIds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                Map<String, dynamic> propertyItemsDataMap = snapshot.data ?? {};

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (propertyItemsDataMap.isEmpty) {
                        // Display a container with a message when no properties are available
                        return SizedBox(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'No properties to Show\n ',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      String documentId =
                          propertyItemsDataMap.keys.elementAt(index);
                      Map<String, dynamic> documentData =
                          propertyItemsDataMap[documentId];
                      String imageUrl = "";
                      try {
                        imageUrl = documentData['Images'][0];
                      } catch (e) {
                        imageUrl =
                            "https://firebasestorage.googleapis.com/v0/b/msoko-seller.appspot.com/o/avatar%2FAvatar_Property.png?alt=media&token=571a9f00-0f39-416a-a00e-8cd1aa592ca9";
                      }

                      String title = "${documentData['Title'] ?? 'N/A'}";
                      String location =
                          '${documentData['Plot Number']}, ${documentData['Locality']}';
                      String price =
                          "${documentData['Selling Price (TZS)'] ?? 'N/A'}";
                      String desc = "${documentData['Description'] ?? 'N/A'}";
                      String postby = documentData['Post By'];
                      String ReraID = documentData['Post By'];
                      String status =
                          "${documentData['Listing Status'] ?? 'N/A'}";

                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: GestureDetector(
                          child: SizedBox(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 236, 236, 236),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                            color: (status == 'Active')
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: Image.network(
                                        imageUrl,
                                        height: 150,
                                        width: 200,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                              child: Icon(Icons.error));
                                        },
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "TZS $price | $title",
                                                style: const TextStyle(
                                                  fontSize: 23,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_sharp,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    location,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "PostBy :$postby",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.51),
                                                ),
                                              ),
                                              Text(
                                                ReraID,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.51),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: propertyItemsDataMap.isEmpty
                        ? 1
                        : propertyItemsDataMap.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> fetchDocumentIds() async {
    Map<String, dynamic> propertyItemsDataMap = {};

    try {
      QuerySnapshot propertiesSnapshot = await FirebaseFirestore.instance
          .collection('Agents')
          .doc(useremail)
          .collection('Properties')
          .get();

      for (QueryDocumentSnapshot propertyItemDoc in propertiesSnapshot.docs) {
        DocumentSnapshot<Map<String, dynamic>> propertiesInfoSnapshot =
            await FirebaseFirestore.instance
                .collection('property_items')
                .doc(propertyItemDoc.id)
                .get();

        String documentId = propertiesInfoSnapshot.id;
        Map<String, dynamic>? documentData = propertiesInfoSnapshot.data();

        if (documentData != null) {
          propertyItemsDataMap[documentId] = documentData;
        } else {
          print('Error: Document data is null for document $documentId');
        }
      }
    } catch (error) {
      print('Error fetching document IDs: $error');
      rethrow;
    }

    return propertyItemsDataMap;
  }
}
