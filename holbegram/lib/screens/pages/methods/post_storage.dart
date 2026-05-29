import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/methods/user_storage.dart';
import '../../../models/post.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String response = "Some error occurred";

    try {
      String photoUrl = await StorageMethods().uploadImageToStorage(
        true,
        "posts",
        image,
      );

      String postId = DateTime.now().millisecondsSinceEpoch.toString();

      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      await _firestore.collection("posts").doc(postId).set(post.toJson());

      response = "Ok";
    } catch (error) {
      response = error.toString();
    }

    return response;
  }

  Future<void> deletePost(String postId, String publicId) async {
    await _firestore.collection("posts").doc(postId).delete();
  }

  Future<void> favoritePost(
    String postId,
    String uid,
    List saved,
  ) async {
    if (saved.contains(postId)) {
      await _firestore.collection('users').doc(uid)
          .update({'saved': FieldValue.arrayRemove([postId])});
    } else {
      await _firestore.collection('users').doc(uid)
          .update({'saved': FieldValue.arrayUnion([postId])});
    }
  }
}
