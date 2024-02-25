import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

var screens = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
      child: Text(
    'Favorite',
    style: TextStyle(fontSize: 25),
  )),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
