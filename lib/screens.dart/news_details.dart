import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        title: const Text('All news'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
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
            Row(
              children: [
                IconButton(
                  onPressed: updateLikedStatus,
                  icon: newsDetails!['is-liked']
                      ? const Icon(
                          Icons.thumb_up_alt_rounded,
                        )
                      : const Icon(
                          Icons.thumb_up_outlined,
                        ),
                ),
                IconButton(
                  onPressed: updatedisLikedStatus,
                  icon: newsDetails!['is-disliked']
                      ? const Icon(
                          Icons.thumb_down_alt_rounded,
                        )
                      : const Icon(
                          Icons.thumb_down_alt_outlined,
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
