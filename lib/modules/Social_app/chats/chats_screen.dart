import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';
import 'package:flutter_application_2/models/socialApp/socialUserModel.dart';
import 'package:flutter_application_2/modules/Social_app/chat_detials/chat_detials_screen.dart';
import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return BuildCondition(
          condition: cubit.users.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                buildUserItem(cubit.users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: cubit.users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    ));
  }
}

Widget buildUserItem(SocialUserModel model, context) => InkWell(
      onTap: () {
        navigateTo(
            context,
            ShatDetialsScreen(
              model: model,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                '${model.image}',
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Expanded(child: Text('${model.name}')),
          ],
        ),
      ),
    );
