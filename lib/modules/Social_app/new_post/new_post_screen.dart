import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';

import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    var textController = TextEditingController();
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCreatePostSuccessState) textController.text = '';
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                  function: () {
                    cubit.postImage == null
                        ? cubit.createPost(
                            text: textController.text,
                            dateTime: now.toString(),
                          )
                        : cubit.upLoadImagePost(
                            text: textController.text,
                            dateTime: now.toString());
                  },
                  text: 'post'),
              SizedBox(
                width: 5.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                if (state is SocialCreatePostLoadingState ||
                    state is SocialupLoadImagePostLoadingState)
                  LinearProgressIndicator(),
                // if (state is SocialGetPostLoadingState)
                if (state is SocialCreatePostLoadingState ||
                    state is SocialupLoadImagePostLoadingState)
                  SizedBox(
                    height: 10.0,
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage:
                          NetworkImage('${cubit.userModel!.image}'),
                    ),
                    SizedBox(
                      width: 7.0,
                    ),
                    Expanded(
                      child: Text('${cubit.userModel!.name}'),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What is on your mind ...',
                    ),
                  ),
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 170.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(4),
                          image: DecorationImage(
                            // ignore: unnecessary_cast
                            image: FileImage(cubit.postImage!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            cubit.removePostImage();
                          },
                          icon: CircleAvatar(
                              child: Icon(
                            Icons.highlight_remove,
                            size: 16.0,
                          ))),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Add Photo',
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        child: Text(
                          '# tags',
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
