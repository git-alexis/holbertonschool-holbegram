import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 38,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(
              FirebaseAuth
                  .instance
                  .currentUser!
                  .uid,
            )
            .get(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          List saved = userData['saved'];
          if (saved.isEmpty) {
            return const Center(
              child: Text("No favorites yet"),
            );
          }
          return StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection('posts')
                .where(
                  'postId',
                  whereIn: saved,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.docs;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      data[index]['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
