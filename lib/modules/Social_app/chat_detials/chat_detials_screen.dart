import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';
import 'package:flutter_application_2/models/socialApp/SocialMessageModel.dart';
import 'package:flutter_application_2/models/socialApp/socialUserModel.dart';

import 'package:flutter_application_2/shared/styles/colors.dart';
import 'package:flutter_application_2/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ShatDetialsScreen extends StatelessWidget {
  final SocialUserModel model;
  ShatDetialsScreen({required this.model});
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(recieveId: model.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SocialSendMessageSuccessState) textController.clear();
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 15.0,
                      backgroundImage: NetworkImage(
                        '${model.image}',
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                        child: Text(
                      '${model.name}',
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: BuildCondition(
                        condition:
                            SocialCubit.get(context).messageList.length > 0,
                        builder: (context) => ListView.separated(
                          physics: BouncingScrollPhysics(),
                          //shrinkWrap: true,

                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messageList[index];
                            if (SocialCubit.get(context).userModel!.uId ==
                                message.senderId)
                              return myMessageBuildItem(message);

                            return messageBuildItem(message);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10.0,
                          ),
                          itemCount:
                              SocialCubit.get(context).messageList.length,
                        ),
                        fallback: (context) => Center(
                            child: Text(
                          'No messages!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.shade600,
                          ),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 50.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: textController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'type your message here  ...',
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            color: defaultColor,
                            child: MaterialButton(
                              minWidth: 1,
                              onPressed: () {
                                SocialCubit.get(context).sendMessage(
                                  dateTime: DateTime.now().toString(),
                                  text: textController.text,
                                  recieverId: model.uId!,
                                );
                              },
                              child: Icon(
                                IconBroken.Send,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
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
      },
    );
  }
}

Widget messageBuildItem(MessageModel message) => Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 10.0,
          ),
          child: Text(
            message.text!,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          ),
        ),
      ),
    );

Widget myMessageBuildItem(MessageModel message) => Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 10.0,
          ),
          child: Text(
            message.text!,
          ),
        ),
        decoration: BoxDecoration(
          color: defaultColor.withOpacity(0.2),
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          ),
        ),
      ),
    );
