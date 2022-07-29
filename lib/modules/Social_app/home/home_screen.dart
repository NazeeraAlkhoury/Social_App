import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';
import 'package:flutter_application_2/models/socialApp/socialPostModel.dart';

import 'package:flutter_application_2/shared/styles/colors.dart';
import 'package:flutter_application_2/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getPost();
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return BuildCondition(
            condition: SocialCubit.get(context).posts.length > 0 &&
                SocialCubit.get(context).userModel != null,
            builder: (context) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: EdgeInsets.all(
                        8.0,
                      ),
                      elevation: 10.0,
                      child: Stack(
                        children: [
                          Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://img.freepik.com/free-photo/dancing-woman-sunglasses-listening-music-headphones-holding-lolipop-smartphone-laughing-smiling-happy-standing-pink-background_1258-85561.jpg?t=st=1655365610~exp=1655366210~hmac=3d385bbbe8ca1af7bb3b2446f1dbc7ae88256190ab7f07f04fa4238ad6f16947&w=740',
                            ),
                            height: 200.0,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Communicate with friends',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ],
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPostItem(context,
                          SocialCubit.get(context).posts[index], index),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 5.0,
                      ),
                      itemCount: SocialCubit.get(context).posts.length,
                    ),
                    // SizedBox(
                    //   height: 100,
                    // ),
                  ],
                ),
              );
            },
            fallback: (context) => Center(child: CircularProgressIndicator()),
          );
        },
      );
    });
  }
}

enum Menu {
  Delete,
  Update,
}

void onSelected(Menu menu, context, index) {
  switch (menu) {
    case (Menu.Delete):
      SocialCubit.get(context)
          .deletePost(postId: SocialCubit.get(context).postId[index]);
      break;
    case (Menu.Update):
      print('update');
      break;
  }
}

Widget buildPostItem(context, SocialPostModel postmodel, index) => Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    '${postmodel.image}',
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${postmodel.name!}'),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 16.0,
                            color: defaultColor,
                          ),
                        ],
                      ),
                      Text(
                        '${postmodel.dateTime!}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              color: Colors.grey,
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<Menu>(
                    child: Icon(
                      Icons.more_horiz,
                      size: 16.0,
                    ),
                    onSelected: (Menu menu) => onSelected(menu, context, index),
                    //{
                    //   switch (menu) {
                    //     case (Menu.Delete):
                    //       SocialCubit.get(context).deletePost(
                    //           postId: SocialCubit.get(context).postId[index]);
                    //       break;
                    //     case (Menu.Update):
                    //       navigateTo(context, NewPostScreen());
                    //       break;
                    //   }
                    //},
                    itemBuilder: (context) => [
                          PopupMenuItem<Menu>(
                            value: Menu.Update,
                            child: Text('Update'),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem<Menu>(
                            value: Menu.Delete,
                            child: Text('Delete'),
                          ),
                        ]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Text(
              '${postmodel.text!}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            //tags
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 5.0,
            //   ),
            //   child: Wrap(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsetsDirectional.only(
            //           end: 5.0,
            //         ),
            //         child: Container(
            //           height: 20,
            //           child: MaterialButton(
            //             onPressed: () {},
            //             child: Text(
            //               '#softwaer',
            //               style: Theme.of(context).textTheme.caption!.copyWith(
            //                     color: defaultColor,
            //                     height: 1.3,
            //                   ),
            //             ),
            //             padding: EdgeInsets.zero,
            //             minWidth: 1.0,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            if (postmodel.postImage != '')
              Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: Container(
                  height: 160.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(
                      4.0,
                    ),
                    image: DecorationImage(
                      image: NetworkImage('${postmodel.postImage}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            // SocialCubit.get(context).postId[index]
                            
                              Text(
                                '${SocialCubit.get(context).likes[SocialCubit.get(context).postId[index]]}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              IconBroken.Chat,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '0 comments',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                              '${SocialCubit.get(context).userModel!.image}'),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'write a comment ...',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    SocialCubit.get(context).postLike(
                      postId: SocialCubit.get(context).postId[index],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          size: 16.0,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
