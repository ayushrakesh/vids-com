import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:vids_com/screens.dart/news_details.dart';
import 'package:vids_com/widgets/chewei_item.dart';
import 'package:path/path.dart';

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
          horizontal: width * 0.05,
        ),
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(NewsDetails.routeName,
                          arguments: [
                            snapshot.data!.docs[index],
                            snapshot.data!.docs[index]
                          ]);
                    },
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.2,
                            width: height * 0.25,
                            child: CheweiItem(
                              VideoPlayerController.network(
                                snapshot.data!.docs[index].data()['video-link'],
                              ),
                              false,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                style: TextStyle(fontSize: 18),
                                snapshot.data!.docs[index]['title'].toString(),
                              ),
                              Text(
                                style: TextStyle(fontSize: 12),
                                snapshot.data!.docs[index]['date'].toString(),
                              ),
                              Text(
                                style: TextStyle(fontSize: 12),
                                snapshot.data!.docs[index]['location']
                                    .toString(),
                              ),
                              Text(
                                style: TextStyle(fontSize: 12),
                                snapshot.data!.docs[index]['views'].toString(),
                              ),
                              Row(
                                children: [
                                  Text('Category'),
                                  Text(
                                    snapshot.data!.docs[index]['category'],
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              )
                            ],
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
