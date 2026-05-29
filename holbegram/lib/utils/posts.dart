import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/pages/methods/post_storage.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        }
        if (snapshot.hasData) {
          var data = snapshot.data!.docs;
          if (data.isEmpty) {
            return const Center(
              child: Text("No posts yet"),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsGeometry.lerp(const EdgeInsets.all(8), const EdgeInsets.all(8), 10),
                  height: 540,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(data[index]['profImage']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(data[index]['username']),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () async {
                                await PostStorage().deletePost(
                                  data[index]['postId'],
                                  '',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Post Deleted")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(data[index]['caption']),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: NetworkImage(data[index]['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(width: 28),
                            Icon(Icons.chat_bubble_outline),
                            SizedBox(width: 28),
                            Icon(Icons.send),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                DocumentSnapshot userSnap =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                          FirebaseAuth.instance.currentUser!.uid,
                                        )
                                        .get();
                                List saved = (userSnap.data() as Map<String, dynamic>)['saved'];
                                await PostStorage().favoritePost(
                                  data[index]['postId'],
                                  FirebaseAuth.instance.currentUser!.uid,
                                  saved,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Favorite updated"),
                                  ),
                                );
                              },
                              child: const Icon(Icons.bookmark_border),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
