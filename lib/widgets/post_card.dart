import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final String img =
      "https://cdn.pixabay.com/photo/2022/06/23/17/13/ball-7280265_1280.jpg";
  bool _isLikeAnimating = false;
  int _commentLength = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      _commentLength = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User userProvider = Provider.of<UserProvider>(context).getUser;
    bool _isLiked = widget.snap['likes'].contains(userProvider.uid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      uid: widget.snap['uid'],
                    ),
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(widget.snap['profImage']),
                  radius: 25,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        uid: widget.snap['uid'],
                      ),
                    ),
                  ),
                  child: Text(
                    widget.snap['username'],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
              widget.snap['postId'],
              userProvider.uid,
              widget.snap['likes'],
            );
            setState(() {
              _isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: widget.snap['postUrl'],
                height: 450,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: _isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 350,
                  ),
                  onEnd: () {
                    setState(() {
                      _isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    size: 130,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row
              Row(
                children: [
                  LikeAnimation(
                    isAnimating: _isLiked,
                    smallLike: true,
                    child: GestureDetector(
                      onTap: () async {
                        await FirestoreMethods().likePost(
                          widget.snap['postId'],
                          userProvider.uid,
                          widget.snap['likes'],
                        );
                        setState(() {
                          _isLikeAnimating = true;
                        });
                      },
                      child: _isLiked
                          ? const Icon(
                              Icons.favorite_sharp,
                              color: Colors.red,
                              size: 35,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              size: 35,
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    ),
                    child: const FaIcon(FontAwesomeIcons.comment, size: 30),
                  ),
                  const SizedBox(width: 20),
                  const FaIcon(FontAwesomeIcons.paperPlane, size: 25),
                ],
              ),
              // Icon tag
              const Icon(Icons.bookmark_border_outlined, size: 35),
            ],
          ),
        ),
        // likes row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              const Icon(Icons.favorite, size: 15),
              const SizedBox(width: 5),
              Text(
                '${widget.snap['likes'].length.toString()} likes',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: primaryColor),
              children: [
                TextSpan(
                  text: widget.snap['username'].toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ${widget.snap['desc'].toString()}',
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
            child: Text(
              'View all $_commentLength comments',
              style: const TextStyle(fontSize: 15, color: secondaryColor),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Text(
            DateFormat.yMMMEd().format(widget.snap['datePublished'].toDate()),
            style: const TextStyle(fontSize: 12, color: secondaryColor),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
