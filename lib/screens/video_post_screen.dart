import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:vids_com/widgets/chewei_item.dart';

class VideoPostScreen extends StatefulWidget {
  static const routeName = 'video-post';

  @override
  State<VideoPostScreen> createState() => _VideoPostScreenState();
}

class _VideoPostScreenState extends State<VideoPostScreen> {
  final height = Get.height;
  final width = Get.width;

  final formKey = GlobalKey<FormState>();

  XFile? video;
  File? videoFile;

  String? title;
  String? location;
  String? description;
  String? category;

  final titleCtl = TextEditingController();
  final cateCtl = TextEditingController();
  final locationCtl = TextEditingController();
  final descripCtl = TextEditingController();

  bool isloading = false;

  final currentuseriD = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    // VideoPlayerController videoplayerCtl =
    //     VideoPlayerController.file(File(video!.path));

    setState(() {
      video = ModalRoute.of(context)!.settings.arguments as XFile;
      videoFile = File(video!.path);
      print(video!.path);
      print(File(video!.path));
    });

    void postVideo() async {
      FocusScope.of(context).unfocus();
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
      }

      title!.trim();
      description!.trim();
      category!.trim();
      location!.trim();

      // Directory appDocDir = await getApplicationDocumentsDirectory();

      // String filePath = '${appDocDir.absolute}/file-to-upload.png';
      // File file = File(filePath);

      final storageRF = FirebaseStorage.instance.ref();
      final folderRf = storageRF.child('videos');
      final videoref = folderRf.child('$title-$category-$location.mp4');

      print(videoref);
      print(videoFile);

      setState(() {
        isloading = true;
      });
      final task = await videoref.putFile(videoFile!);
      final downloadURL = await videoref.getDownloadURL();
      final userdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuseriD)
          .get();
      final username = userdata.get('username');

      final now = DateTime.now();
      String formatter = DateFormat('yMd').format(now);

      await FirebaseFirestore.instance.collection('news').add({
        'title': title,
        'category': category,
        'description': description,
        'location': location,
        'date': formatter,
        'views': 0,
        'likes': 0,
        'dislikes': 0,
        'comments': [],
        'video-link': downloadURL,
        'posted-by': username,
      });

      setState(() {
        isloading = false;
      });

      // try {

      // } on firebase_core.FirebaseException catch (e) {
      //   // ...
      // }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post new video'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
            children: [
              Container(
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: CheweiItem(
                    VideoPlayerController.file(videoFile!),
                    false,
                    true,
                  ),
                ),
              ),
              Gap(height * 0.04),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Title'),
                        Gap(height * 0.01),
                        Flexible(
                          child: TextFormField(
                            controller: titleCtl,
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid title';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Title here',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(height * 0.01),
                    Row(
                      children: [
                        Text('Category'),
                        Gap(height * 0.01),
                        Flexible(
                          child: TextFormField(
                            controller: cateCtl,
                            onChanged: (value) {
                              setState(() {
                                category = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid category';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Give a category',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(height * 0.01),
                    Row(
                      children: [
                        Text('Location'),
                        Gap(height * 0.01),
                        Flexible(
                          child: TextFormField(
                            controller: locationCtl,
                            onChanged: (value) {
                              setState(() {
                                location = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid location';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Location of video',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(height * 0.01),
                    Row(
                      children: [
                        Text('Decription'),
                        Gap(height * 0.01),
                        Flexible(
                          child: TextFormField(
                            controller: descripCtl,
                            onChanged: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid description';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Provide some description',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w200,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03, vertical: 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(height * 0.04),
              isloading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.2,
                          vertical: height * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      onPressed: postVideo,
                      child: const Text(
                        'Post',
                        style: TextStyle(
                            color: Color.fromARGB(255, 52, 3, 137),
                            fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
