import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final String img =
      "https://cdn.pixabay.com/photo/2022/06/23/17/13/ball-7280265_1280.jpg";
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(widget.snap['profilePic']),
            radius: 25,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: primaryColor),
                    children: [
                      TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: ' ${widget.snap['text']}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMMMEd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: TextStyle(color: secondaryColor),
                ),
              ],
            ),
          ),
          const Icon(Icons.favorite, size: 20)
        ],
      ),
    );
  }
}
