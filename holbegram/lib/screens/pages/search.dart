import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'profile_screen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    isShowUsers = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isShowUsers
                // USERS SEARCH
                ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'searchKey',
                        isGreaterThanOrEqualTo: searchController.text.toLowerCase(),
                      ).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var users = snapshot.data!.docs;
                    if (users.isEmpty) {
                      return const Center(
                        child: Text("No users found"),
                      );
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(users[index]['photoUrl']),
                          ),
                          title: Text(users[index]['username']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: users[index]['uid'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
                // POSTS GRID
                : StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("posts").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error ${snapshot.error}"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var data = snapshot.data!.docs;
                    if (data.isEmpty) {
                      return const Center(
                        child: Text("No posts yet"),
                      );
                    }
                    return MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            data[index]['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}
