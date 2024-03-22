// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  bool isUser;

  ProfileScreen({
    Key? key,
    required this.uid,
    this.isUser = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postData = {};
  int _postLength = 0;
  int _followers = 0;
  int _following = 0;
  bool _isLoading = true;
  bool _isFollowing = false;

  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getFollowers(uid) async {
    var returnData = {};
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      returnData = snap.data()!;
    } catch (err) {
      print(err.toString());
    }

    return returnData;
  }

  getData() async {
    setState(() {
      _isLoading = false;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = snap.data()!;

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      _postLength = postSnap.docs.length;
      _followers = snap.data()!['followers'].length;
      _following = snap.data()!['following'].length;
      _isFollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (err) {
      print(err.toString());
    }
    setState(() {
      _isLoading = true;
    });
  }

  // column list
  Column columnList(int data, String type) {
    return Column(
      children: [
        Text(
          data.toString(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 7),
        Text(type),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    const String img =
        "https://cdn.pixabay.com/photo/2022/06/23/17/13/ball-7280265_1280.jpg";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(
          userData['username'] ?? 'Username',
        ),
      ),
      body: _isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: secondarySearchColor,
                        backgroundImage: CachedNetworkImageProvider(
                            userData['photoUrl'] ?? img),
                        radius: 60,
                      ),
                      Container(
                        // color: Colors.blue,
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                columnList(_postLength, 'Posts'),
                                const SizedBox(width: 20),
                                columnList(_followers, 'Followers'),
                                const SizedBox(width: 20),
                                columnList(_following, 'Following'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 210,
                              child: user.uid == widget.uid
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isSigningOut = false;
                                        });
                                        await AuthMethods().signOut();
                                        setState(() {
                                          _isSigningOut = true;
                                        });

                                        if (_isSigningOut) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          secondaryColor,
                                        ),
                                      ),
                                      child: const Text('Logout'),
                                    )
                                  : _isFollowing
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            await FirestoreMethods().followUser(
                                              // String myUid, String otherUid, List followers, List following
                                              user.uid,
                                              userData['uid'],
                                              userData['followers'],
                                              user.following,
                                              true,
                                            );

                                            var data =
                                                await getFollowers(user.uid);

                                            setState(() {
                                              _followers =
                                                  data['followers'].length;
                                              _isFollowing = false;
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              secondaryColor,
                                            ),
                                          ),
                                          child: const Text('Following'),
                                        )
                                      : ElevatedButton(
                                          onPressed: () async {
                                            await FirestoreMethods().followUser(
                                              // String myUid, String otherUid, List followers, List following
                                              user.uid,
                                              userData['uid'],
                                              userData['followers'],
                                              user.following,
                                              false,
                                            );

                                            var data =
                                                await getFollowers(user.uid);
                                            setState(() {
                                              _followers =
                                                  data['followers'].length;
                                              _isFollowing = true;
                                            });
                                          },
                                          child: const Text('Follow'),
                                        ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // bio real name
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData['username'] ?? 'username',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userData['bio'] ?? 'username',
                      )
                    ],
                  ),
                ),
                // post list header
                const SizedBox(height: 7),
                const Divider(height: 1),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.data!.docs.length == 0) {
                      return const Center(
                        child: Text('No posts'),
                      );
                    }

                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  snapshot.data!.docs[index]['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                // posts
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
