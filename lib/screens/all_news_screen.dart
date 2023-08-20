import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vids_com/screens/news_details.dart';
import 'package:vids_com/widgets/chewei_item.dart';

class AllNewsScreen extends StatefulWidget {
  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  final height = Get.height;
  final width = Get.width;

  VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: kToolbarHeight,
        title: Text('News'),
        centerTitle: true,
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          controller!.value.isPlaying
              ? controller!.play()
              : controller!.pause();
        },
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
