import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vids_com/screens/news_details.dart';
import 'package:vids_com/widgets/chewei_item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'video_post_screen.dart';

class AllNewsScreen extends StatefulWidget {
  static const routeName = 'all-news';

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  final height = Get.height;
  final width = Get.width;

  VideoPlayerController? controller;

  XFile? video;

  void showAlert() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: const Text(
              'Alert, are you sure to logout!',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await FirebaseAuth.instance.signOut();
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
          );
        });
  }

  void takeVideo() async {
    final pvideo = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(
        seconds: 5,
      ),
    );
    setState(() {
      video = pvideo;
    });
    print(video);

    Navigator.of(context)
        .pushNamed(VideoPostScreen.routeName, arguments: video);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: kToolbarHeight,
        title: Text('News'),
        centerTitle: true,
        actions: [
          DropdownButton(
            // padding: EdgeInsets.all(5),
            // hint: Icon(Icons.more_vert),
            elevation: 0,
            style: const TextStyle(color: Colors.black),
            items: [
              DropdownMenuItem(
                alignment: Alignment.centerRight,
                value: 'logout',
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        size: 24,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
            icon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.more_vert,
                size: 24,
                color: Colors.black,
              ),
            ),
            onChanged: (itemidentifier) {
              if (itemidentifier == 'logout') {
                showAlert();
              }
            },
          ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: takeVideo,
        color: Colors.black,
        style: IconButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: EdgeInsets.all(
            12,
          ),
        ),
        icon: Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            // horizontal: width * 0.05,
            ),
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  final newsdoc = snapshot.data!.docs[index].reference.id;
                  return InkWell(
                    onTap: () {
                      print(newsdoc);
                      Navigator.of(context).pushNamed(
                        NewsDetails.routeName,
                        arguments: [
                          newsdoc,
                          // snapshot.data!.docs[index]
                        ],
                      );
                    },
                    child: Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.3,
                            width: double.infinity,
                            child: CheweiItem(
                              VideoPlayerController.networkUrl(
                                Uri.parse(
                                  snapshot.data!.docs[index]['video-link'],
                                ),
                              ),
                              false,
                              false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      snapshot.data!.docs[index]['title']
                                          .toString(),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          style: TextStyle(fontSize: 12),
                                          snapshot.data!.docs[index]['views']
                                              .toString(),
                                        ),
                                        Text(
                                          style: TextStyle(fontSize: 12),
                                          ' views',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Gap(height * 0.005),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Posted by - ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['posted-by'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      style: TextStyle(fontSize: 12),
                                      snapshot.data!.docs[index]['date']
                                          .toString(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            }
            return Center(child: CircularProgressIndicator());
          },
          stream: FirebaseFirestore.instance.collection('news').snapshots(),
        ),
      ),
    );
  }
}
