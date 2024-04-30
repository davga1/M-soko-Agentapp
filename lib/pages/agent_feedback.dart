import 'package:agentapp/common/constant.dart';
import 'package:agentapp/common/utils.dart';
import 'package:agentapp/pages/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PFeedback extends StatefulWidget {
  const PFeedback({super.key, required this.email, required this.name});
  final String email;
  final String name;

  @override
  State<PFeedback> createState() => _PFeedbackState();
}

class _PFeedbackState extends State<PFeedback> {
  double prating = 0;
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: NavDrawer(
        //   email: widget.email,
        //   name: widget.name,
        // ),
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        prating = rating;
                      });
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      color: const Color.fromARGB(64, 208, 208, 208),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        controller: feedbackController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText:
                              'Write your words and suggestions to help us improve.',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            overflow: TextOverflow.visible,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (feedbackController.text.isEmpty) {
                          ToastM().toastMessage("Please enter feedback!");
                        } else if (prating == 0) {
                          ToastM().toastMessage("Please give rating!");
                        } else {
                          try {
                            final CollectionReference feedback =
                                FirebaseFirestore.instance
                                    .collection('property_feedbacks');
                            DocumentReference userFeedbackRef =
                                feedback.doc(widget.email);
                            await userFeedbackRef.set({
                              'rating': prating,
                              'comment': feedbackController.text,
                            });
                            ToastM()
                                .toastMessage("Feedback Send Successfully!");
                          } catch (error) {
                            ToastM().toastMessage(error.toString());
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
