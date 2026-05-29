import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  int postLength = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getData();
  }

  Future<void> getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      var postSnap = await FirebaseFirestore
          .instance.collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          )
          .get();

      setState(() {
        userData = userSnap.data() as Map<String, dynamic>;

        postLength = postSnap.docs.length;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 38,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 36,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(userData!['photoUrl']),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatColumn(
                              postLength,
                              "posts",
                            ),
                            buildStatColumn(
                              userData!['followers'].length,
                              "followers",
                            ),
                            buildStatColumn(
                              userData!['following'].length,
                              "following",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userData!['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore
                  .instance
                  .collection('posts')
                  .where(
                    'uid',
                    isEqualTo: widget.uid,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var snap = snapshot.data!.docs;
                return MasonryGridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 6,
                  itemCount: snap.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      snap[index]['postUrl'],
                      fit: BoxFit.cover,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int number, String label) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
