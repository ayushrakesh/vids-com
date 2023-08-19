import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vids_com/widgets/chewei_item.dart';

class NewsDetails extends StatefulWidget {
  static const routeName = '/news-details';

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  final height = Get.height;
  final width = Get.width;

  VideoPlayerController? controller;
  String? newsID;
  QueryDocumentSnapshot? newsDocRF;

  final commentCtl = TextEditingController();
  String comment = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      newsID =
          (ModalRoute.of(context)!.settings.arguments as List)[0] as String;
      // newsDocRF = (ModalRoute.of(context)!.settings.arguments as List)[1]
      //     as QueryDocumentSnapshot;
    });

    void like() async {
      final data =
          await FirebaseFirestore.instance.collection('news').doc(newsID).get();
      final likes = data.get('likes');

      await FirebaseFirestore.instance.collection('news').doc(newsID).update({
        'likes': likes + 1,
      });
    }

    void dislike() async {
      final data =
          await FirebaseFirestore.instance.collection('news').doc(newsID).get();
      final dislikes = data.get('dislikes');

      await FirebaseFirestore.instance.collection('news').doc(newsID).update({
        'dislikes': dislikes + 1,
      });
    }

    void addComment() async {
      FocusScope.of(context).unfocus();

      final newComment = {
        'comment': comment,
        'commented-by': 'testing-user',
      };

      final data =
          await FirebaseFirestore.instance.collection('news').doc(newsID).get();
      List prevComments = data.get('comments');

      prevComments.insert(0, newComment);

      await FirebaseFirestore.instance.collection('news').doc(newsID).update({
        'comments': prevComments,
      });

      setState(() {
        comment = '';
      });

      commentCtl.clear();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('News description'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text('Add comment', textAlign: TextAlign.center),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(14),
      //   ),
      //   onPressed: () {
      //     SystemChannels.textInput.invokeMethod('TextInput.open');
      //   },
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              // horizontal: width * 0.05,
              ),
          child: StreamBuilder<DocumentSnapshot>(
            builder: (ctx, stream) {
              if (stream.hasData) {
                final String videolink = stream.data!.get('video-link');
                final comments = stream.data!.get('comments');
                return Column(
                  children: [
                    Container(
                      height: height * 0.3,
                      // width: height * 0.2,
                      child: CheweiItem(
                        VideoPlayerController.networkUrl(
                          // formatHint: VideoFormat.ss,
                          Uri.parse(videolink),
                        ),
                        true,
                        true,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.thumb_up_alt_rounded),
                                          onPressed: like,
                                        ),
                                        Gap(width * 0.030),
                                        Text(
                                          stream.data!.get('likes').toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(width * 0.05),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.thumb_down_alt_rounded),
                                          onPressed: dislike,
                                        ),
                                        Gap(width * 0.030),
                                        Text(
                                          stream.data!
                                              .get('dislikes')
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(stream.data!.get('views').toString()),
                                    Text(' views'),
                                  ],
                                ),
                              ],
                            ),
                            Gap(height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Posted-by '),
                                    Text(stream.data!
                                        .get('posted-by')
                                        .toString()),
                                  ],
                                ),
                                Text(stream.data!.get('date').toString()),
                              ],
                            ),
                            Gap(height * 0.02),
                            Text(
                              stream.data!.get('title').toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(height * 0.01),
                            Text(stream.data!.get('description').toString()),
                            Gap(height * 0.025),
                            Row(
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: TextField(
                                    controller: commentCtl,
                                    onChanged: (value) {
                                      setState(() {
                                        comment = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 193, 192, 192),
                                      hintText: 'Add a comment...',
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: commentCtl.text.isEmpty
                                      ? null
                                      : addComment,
                                  icon: Icon(
                                    Icons.send,
                                    color: commentCtl.text.isEmpty
                                        ? Color.fromARGB(255, 214, 213, 213)
                                        : Color.fromARGB(255, 104, 104, 104),
                                  ),
                                ),
                              ],
                            ),
                            Gap(height * 0.04),
                            const Text(
                              'Comments',
                              style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  // width: width * 0.5,

                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.01,
                                  ),
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.01),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 34, 34, 34),
                                        Colors.black,
                                      ],
                                      end: Alignment.topLeft,
                                      begin: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comments[index]['commented-by'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white60),
                                      ),
                                      Text(
                                        comments[index]['comment'],
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: comments.length,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            stream: FirebaseFirestore.instance
                .collection('news')
                .doc(newsID)
                .snapshots(),
          ),
        ),
      ),
    );
  }
}
