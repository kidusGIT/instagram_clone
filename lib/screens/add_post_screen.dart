import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final String img =
      "https://cdn.pixabay.com/photo/2022/06/23/17/13/ball-7280265_1280.jpg";
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  void _postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String res = await FirestoreMethods().uploadPost(
        _captionController.text,
        uid,
        _file!,
        username,
        profImage,
      );

      if (res == 'Success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Make a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(15),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(15),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(15),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final String userProfile = userProvider.getUser.photoUrl;

    return _file == null
        ? Center(
            child: GestureDetector(
              onTap: () => _selectImage(context),
              child: const Icon(
                Icons.cloud_upload,
                size: 80,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: clearImage,
                ),
              ),
              title: const Text('Post to'),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => _postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProfile,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 17),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 5),
                    _isLoading
                        ? const LinearProgressIndicator()
                        : const SizedBox(height: 0),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            // image: MemoryImage(_file!),
                            image: MemoryImage(_file!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 7),
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              userProfile,
                            ),
                            radius: 30,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              child: TextField(
                                controller: _captionController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write a caption...'),
                                maxLines: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
