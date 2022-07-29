import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';
import 'package:flutter_application_2/modules/Social_app/new_post/new_post_screen.dart';
import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_application_2/shared/styles/icon_broken.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.title[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Notification,
                  size: 20.0,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Search,
                  size: 20.0,
                ),
              ),
            ],
          ),
          // body: BuildCondition(
          //   condition: SocialCubit.get(context).model != null,
          //   builder: (context) => Column(
          //     children: [
          // if (!FirebaseAuth.instance.currentUser!.emailVerified)
          //   Container(
          //     color: Colors.amber.withOpacity(.6),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 20.0,
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.info_outline,
          //           ),
          //           SizedBox(
          //             width: 5.0,
          //           ),
          //           Expanded(
          //             child: Text(
          //               'Send email verification',
          //             ),
          //           ),
          //           SizedBox(
          //             width: 20.0,
          //           ),
          //           defaultTextButton(
          //             function: () {
          //               FirebaseAuth.instance.currentUser!
          //                   .sendEmailVerification()
          //                   .then((value) {
          //                 showToast(
          //                   msg: 'Check your mail',
          //                   state: ToastStates.SUCCESS,
          //                 );
          //               }).catchError((error) {
          //                 print(error.toString());
          //               });
          //             },
          //             text: 'Send',
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          //     ],
          //   ),
          //   fallback: (context) => Center(child: CircularProgressIndicator()),
          // ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Location),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: 'Setting',
              ),
            ],
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
          ),
          body: cubit.screen[cubit.currentIndex],
        );
      },
    );
  }
}


//  https://www.freepik.com/free-photo/stylish-good-looking-ambitious-smiling-brunette-woman-with-curly-hairstyle-cross-hands-chest-confident-professional-pose-smiling-standing-casually-summer-outfit-talking-friend-white-wall_18040581.htm#page=3&query=woman&position=13&from_view=keyword

// https://img.freepik.com/free-photo/stylish-good-looking-ambitious-smiling-brunette-woman-with-curly-hairstyle-cross-hands-chest-confident-professional-pose-smiling-standing-casually-summer-outfit-talking-friend-white-wall_176420-36248.jpg?t=st=1655365716~exp=1655366316~hmac=3e2dfa7998d6a2a851d80e9c8c1112f3cfab85faedcdb861f45f07dd54813837&w=740

// https://img.freepik.com/free-photo/friendly-smiling-young-woman-with-brown-hair-gives-good-advice-suggestion-what-buy-indicates-with-fore-finger-upper-right-corner_273609-18601.jpg?t=st=1655365610~exp=1655366210~hmac=8780b16f3242c753c449dfa2fc5061fdfc72278e3ab1a6573ce608b9110a4b17&w=740

// https://img.freepik.com/free-photo/dancing-woman-sunglasses-listening-music-headphones-holding-lolipop-smartphone-laughing-smiling-happy-standing-pink-background_1258-85561.jpg?t=st=1655365610~exp=1655366210~hmac=3d385bbbe8ca1af7bb3b2446f1dbc7ae88256190ab7f07f04fa4238ad6f16947&w=740

// https://img.freepik.com/free-photo/close-up-portrait-coquettish-smiling-woman-glamour-girl-thinking-looking-thoughtful-standing_1258-85985.jpg?t=st=1655365610~exp=1655366210~hmac=f3882f7cae52eb3d7d9c744dff23ddb4df99064f2d57c9cd72303f5147b82d5b&w=740