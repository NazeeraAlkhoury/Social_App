class SocialPostModel {
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;
  String? postImage;

  SocialPostModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
  });

  SocialPostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
    };
  }
}

// class LikePostModel extends SocialPostModel {
//   List<String>? likes;
//   String? postId;
  // LikePostModel({this.likes, this.postId}) : super();
  // LikePostModel.fromJson(Map<String,dynamic> json){

  // }:
//}


  // postModel.likes.contains(userModel.uId)
  //                   ? Icons.favorite
  //                   : IconBroken.Heart,

  //postModel.likes.length.toString(),

  //SocialCubit.get(context).likePost(postIndex: index);

  //  postModel.likes.contains(userModel.uId)
  //                         ? 'liked'
  //                         : 'like',


  //  await postDoc.reference
  //           .collection('likes')
  //           .where('like', isEqualTo: true)
  //           .get()
  //           .then((likeValue) {
  //         posts.add(
  //           GetPostModel.fromJson(
  //             json: postDoc.data(),
  //             postId: postDoc.id,
  //             likes: likeValue.docs.map((e) => e.id).toList(),
  //           ),
  //         );
  //       }).catchError((error) {
  //         log('error when get post likes: ${error.toString()}');
  //       });

  //  Future<void> likePost({
  //   required int postIndex,
  // }) async {
  //   String postId = posts[postIndex].postId;
  //   bool isLiked = posts[postIndex].likes.contains(userModel!.uId);

  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('likes')
  //       .doc(userModel!.uId)
  //       .set({
  //     'like': !isLiked,
  //   }).then((_) {
  //     if (isLiked) {
  //       posts[postIndex].likes.remove(userModel!.uId);
  //     } else {
  //       posts[postIndex].likes.add(userModel!.uId);
  //     }

  //     emit(SocialLikePostSuccessState());
  //   }).catchError((error) {
  //     log('error when likePost: ${error.toString()}');
  //     emit(SocialLikePostErrorState(error.toString()));
  //   });
  // }