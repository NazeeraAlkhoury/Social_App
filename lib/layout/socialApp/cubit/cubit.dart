import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';

import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';
import 'package:flutter_application_2/models/socialApp/SocialMessageModel.dart';
import 'package:flutter_application_2/models/socialApp/socialPostModel.dart';
import 'package:flutter_application_2/models/socialApp/socialUserModel.dart';
import 'package:flutter_application_2/modules/Social_app/chats/chats_screen.dart';
import 'package:flutter_application_2/modules/Social_app/home/home_screen.dart';
import 'package:flutter_application_2/modules/Social_app/new_post/new_post_screen.dart';

import 'package:flutter_application_2/modules/Social_app/setting/setting_screen.dart';
import 'package:flutter_application_2/modules/Social_app/users/users_screen.dart';

import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_application_2/shared/components/constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;
  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());

      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState());
    });
  }

  int currentIndex = 0;

  void changeIndex(index) {
    if (index == 1) getAllUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      //if (index == 0) getPost();
      emit(SocialChangeBottomNavState());
    }
  }

  List<Widget> screen = [
    HomeScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingScreen(),
  ];

  List<String> title = [
    'Home',
    'Chats',
    'Add Post',
    'Users',
    'Setting',
  ];

  final picker = ImagePicker();

  File? profileImage;

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      showToast(msg: 'No image selected', state: ToastStates.ERROR);
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void updateUser({
    required String bio,
    required String name,
    required String phone,
    String? profile,
    String? cover,
  }) {
    emit(SocialUpdateUserLoadiogState());
    SocialUserModel model = SocialUserModel(
      email: userModel!.email,
      name: name,
      phone: phone,
      uId: userModel!.uId,
      image: profile ?? userModel!.image,
      bio: bio,
      cover: cover ?? userModel!.cover,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      // emit(SocialUpdateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialUpdateUserErrorState());
    });
  }

  // String profileImageUrl = '';
  void upLoadProfileImage({
    required String bio,
    required String name,
    required String phone,
  }) {
    emit(SocialUploadProfileImageLoadiogState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // profileImageUrl = value;
        print(value);
        updateUser(bio: bio, name: name, phone: phone, profile: value);
      }).catchError((error) {
        print(error.toString());
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void upLoadCoverImage({
    required String bio,
    required String name,
    required String phone,
  }) {
    emit(SocialUploadCoverImageLoadiogState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(bio: bio, name: name, phone: phone, cover: value);
      }).catchError((error) {
        print(error.toString());
        emit(SocialUploadcoverImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialUploadcoverImageErrorState());
    });
  }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageSuccessState());
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    SocialPostModel postModel = SocialPostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      removePostImage();
    }).catchError((error) {
      print(error.toString);
      emit(SocialCreatePostErrorState());
    });
  }

  void upLoadImagePost({
    required String? text,
    required String? dateTime,
  }) {
    emit(SocialUpdateUserLoadiogState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          text: text!,
          dateTime: dateTime!,
          postImage: value,
        );
        removePostImage();
      }).catchError((error) {
        print(error.toString());
        emit(SocialupLoadImagePostErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialupLoadImagePostErrorState());
    });
  }

  // getPost() {
  //   posts = [];
  //   emit(SocialGetPostLoadingState());
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .orderBy('dateTime')
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) async {
  //       await element.reference.collection('likes').get().then((value) {
  //         posts.add(SocialPostModel.fromJson(element.data()));
  //         postId.add(element.id);
  //         likes.addAll({
  //           element.id: value.docs.length,
  //         });
  //         print(likes.toString());
  //       }).catchError((error) {
  //         print(error.toString());
  //       });
  //     });
  //     emit(SocialGetPostSuccessState());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(SocialGetPostErrorState());
  //   });
  // }

  List<SocialPostModel> posts = [];
  List<String> postId = [];
  Map<String, int> likes = {};
  //List<int> userLike = [];
  void getPost() {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      posts.clear();
      postId.clear();
      likes.clear();
      //userLike.clear();
      event.docs.forEach((element) {
        posts.add(SocialPostModel.fromJson(element.data()));
        postId.add(element.id);
        element.reference.collection('likes').snapshots().listen((event) {
          //userLike.add(event.docs.length);

          likes.addAll({
            element.id: event.docs.length,
          });
        });
      });
    });
    print(postId);
    print(likes.toString());
    emit(SocialGetPostSuccessState());
  }

  void postLike({required String postId}) {
    emit(SocialLikePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId!)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialLikePostErrorState());
    });
  }

  void deletePost({
    required String? postId,
  }) {
    emit(SocialDeletePostErrorState());

    // FirebaseFirestore.instance
    //     .collection('posts')
    //     .doc(postId)
    //     .collection('likes')
    //     .doc()
    //     .delete()
    //     .then((value) {
    //   emit(SocialDeletePostLikeSuccessState());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(SocialDeletePostLikeErrorState());
    // });

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      emit(SocialDeletePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialDeletePostErrorState());
    });
  }

  List<SocialUserModel> users = [];
  void getAllUsers() {
    users = [];
    emit(SocialGetUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] != userModel!.uId)
          users.add(SocialUserModel.fromJson(element.data()));
      });
      emit(SocialGetUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUsersErrorState());
    });
  }

  void sendMessage({
    required String dateTime,
    required String text,
    required String recieverId,
  }) {
    emit(SocialSendMessageLoadingState());
    MessageModel messageModel = MessageModel(
        dateTime: dateTime,
        text: text,
        senderId: userModel!.uId,
        recieverId: recieverId);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messageList = [];

  void getMessages({required String recieveId}) {
    //emit(SocialGetMessageLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(recieveId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messageList.clear();
      event.docs.forEach((element) {
        messageList.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
