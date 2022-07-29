import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/socialApp/socialUserModel.dart';
import 'package:flutter_application_2/modules/Social_app/social_register/cubit/states.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changePassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialRegisterChangePasswordState());
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    SocialUserModel model = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      image:
          'https://img.freepik.com/free-photo/close-up-portrait-coquettish-smiling-woman-glamour-girl-thinking-looking-thoughtful-standing_1258-85985.jpg?t=st=1655365610~exp=1655366210~hmac=f3882f7cae52eb3d7d9c744dff23ddb4df99064f2d57c9cd72303f5147b82d5b&w=740',
      bio: 'write you bio',
      cover:
          'https://img.freepik.com/free-photo/dancing-woman-sunglasses-listening-music-headphones-holding-lolipop-smartphone-laughing-smiling-happy-standing-pink-background_1258-85561.jpg?t=st=1655365610~exp=1655366210~hmac=3d385bbbe8ca1af7bb3b2446f1dbc7ae88256190ab7f07f04fa4238ad6f16947&w=740',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState(uId));
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorState());
    });
  }

  void registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SocialLoadingRegisterState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.uid);
      print(value.user!.email);
      createUser(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
      // emit(SocialSuccessRegisterState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialErrorRegisterState());
    });
  }
}
