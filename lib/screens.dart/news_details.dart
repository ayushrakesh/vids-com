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
  String? newsDetails;
  QueryDocumentSnapshot? newsDocRF;

  final commentCtl = TextEditingController();
  String comment = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      newsDetails =
          (ModalRoute.of(context)!.settings.arguments as List)[0] as String;
      // newsDocRF = (ModalRoute.of(context)!.settings.arguments as List)[1]
      //     as QueryDocumentSnapshot;
    });

    // void updateLikedStatus() async {
    //   await newsDocRF!.reference
    //       .update({'is-liked': newsDetails!['is-liked'] ? false : true});
    // }

    // void updatedisLikedStatus() async {
    //   await newsDocRF!.reference
    //       .update({'is-disliked': newsDetails!['is-disliked'] ? false : true});
    // }

    void addComment() async {
      FocusScope.of(context).unfocus();

      final newComment = {
        'comment': comment,
        'commented-by': 'username',
      };
      print(newsDetails);
      print(newsDetails!.reference);

      await newsDetails!.reference.update({
        // 'newcomment': newComment,
        'comments': [newComment],
      });

// print(newsDoc);

      // final newsDoc = await newsDetails!.get()

      setState(() {
        comment = '';
      });

      commentCtl.clear();

      //  final newsMap= newsDoc;
      //  newsMap!['comments'].
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
            padding: EdgeInsets.symmetric(
                // horizontal: width * 0.05,
                ),
            child: StreamBuilder<DocumentSnapshot>(
              builder: (ctx, stream) {
                if (stream.hasData) {
                  final String video-link=
                  return Column(
                    children: [
                      Container(
                        height: height * 0.3,
                        // width: height * 0.2,
                        child: CheweiItem(
                          VideoPlayerController.networkUrl(
                            // formatHint: VideoFormat.ss,
                            Uri.parse(
                              stream.,
                            ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.thumb_up_alt_rounded,
                                          ),
                                          Gap(width * 0.030),
                                          Text(
                                            newsDetails!['likes'].toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gap(width * 0.05),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.thumb_down_alt_rounded,
                                          ),
                                          Gap(width * 0.030),
                                          Text(
                                            newsDetails!['dislikes'].toString(),
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
                                      Text(newsDetails!['views'].toString()),
                                      Text(' views'),
                                    ],
                                  ),
                                ],
                              ),
                              Gap(height * 0.01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('Posted-by '),
                                      Text(newsDetails!['posted-by']),
                                    ],
                                  ),
                                  Text(newsDetails!['date']),
                                ],
                              ),
                              Gap(height * 0.02),
                              Text(
                                newsDetails!['title'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gap(height * 0.01),
                              Text(newsDetails!['description']),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                              SingleChildScrollView(
                                child: Expanded(
                                  child: StreamBuilder<DocumentSnapshot>(
                                    builder: (ctx, stream) {
                                      if (stream.hasData) {
                                        return ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (ctx, index) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.03,
                                                vertical: height * 0.01,
                                              ),
                                              margin: EdgeInsets.only(
                                                  bottom: height * 0.01),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 34, 34, 34),
                                                    Colors.black,
                                                  ],
                                                  end: Alignment.topLeft,
                                                  begin: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    newsDetails!['comments']
                                                                [index]
                                                            ['commented-by']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white60),
                                                  ),
                                                  Text(
                                                    newsDetails!['comments']
                                                            [index]['comment']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount:
                                              newsDetails!['comments'].length,
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
                                    stream: newsDetails!.reference.snapshots(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
              stream: FirebaseFirestore.instance
                  .collection('news')
                  .where('id', isEqualTo: newsDetails)
                  .snapshots(),
            )),
      ),
    );
  }
}
