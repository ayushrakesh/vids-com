import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  QueryDocumentSnapshot? newsDetails;
  QueryDocumentSnapshot? newsDocRF;

  @override
  Widget build(BuildContext context) {
    setState(() {
      newsDetails = (ModalRoute.of(context)!.settings.arguments as List)[0]
          as QueryDocumentSnapshot;
      newsDocRF = (ModalRoute.of(context)!.settings.arguments as List)[1]
          as QueryDocumentSnapshot;
    });

    void updateLikedStatus() async {
      await newsDocRF!.reference
          .update({'is-liked': newsDetails!['is-liked'] ? false : true});
    }

    void updatedisLikedStatus() async {
      await newsDocRF!.reference
          .update({'is-disliked': newsDetails!['is-disliked'] ? false : true});
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            // horizontal: width * 0.05,
            ),
        child: Column(
          children: [
            Container(
              height: height * 0.3,
              // width: height * 0.2,
              child: CheweiItem(
                VideoPlayerController.networkUrl(
                  // formatHint: VideoFormat.ss,
                  Uri.parse(
                    newsDetails!['video-link'],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.thumb_up_alt_rounded,
                                ),
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
                        Text(newsDetails!['date']),
                        Row(
                          children: [
                            Text(newsDetails!['views'].toString()),
                            Text(' views'),
                          ],
                        ),
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
                    const Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.01,
                          ),
                          margin: EdgeInsets.only(bottom: height * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 42, 41, 41),
                                Colors.black,
                              ],
                              end: Alignment.topLeft,
                              begin: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsDetails!['comments'][index]['commented-by']
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Text(newsDetails!['comments'][index]['comment']
                                  .toString()),
                            ],
                          ),
                        );
                      },
                      itemCount: newsDetails!['comments'].length,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
