import 'package:flutter/material.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';
import 'package:flutter_application_2/layout/socialApp/cubit/states.dart';
import 'package:flutter_application_2/shared/components/components.dart';
import 'package:flutter_application_2/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        var userModel = SocialCubit.get(context).userModel;
        if (userModel != null) {
          nameController.text = userModel.name!;
          phoneController.text = userModel.phone!;
          bioController.text = userModel.bio!;
        }

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              TextButton(
                onPressed: () {
                  SocialCubit.get(context).updateUser(
                    bio: bioController.text,
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                },
                child: Text(
                  'UPDATE',
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUpdateUserLoadiogState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 220.0,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 170.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(4.0),
                                    topEnd: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: SocialCubit.get(context)
                                                .coverImage ==
                                            null
                                        ? NetworkImage('${userModel!.cover}')
                                        : FileImage(SocialCubit.get(context)
                                            .coverImage!) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                      child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ))),
                            ],
                          ),
                        ),
                        Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: cubit.profileImage == null
                                      ? NetworkImage('${userModel!.image}')
                                      : FileImage(SocialCubit.get(context)
                                          .profileImage!) as ImageProvider,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    cubit.getProfileImage();
                                  },
                                  icon: CircleAvatar(
                                      child: Icon(
                                    IconBroken.Camera,
                                    size: 14.0,
                                  ))),
                            ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (cubit.profileImage != null || cubit.coverImage != null)
                    Row(
                      children: [
                        if (cubit.profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    cubit.upLoadProfileImage(
                                      bio: bioController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  text: 'Upload Profile',
                                ),
                                if (state
                                        is SocialUploadCoverImageLoadiogState ||
                                    state
                                        is SocialUploadProfileImageLoadiogState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state
                                    is SocialUploadProfileImageLoadiogState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (cubit.coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    cubit.upLoadCoverImage(
                                      bio: bioController.text,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  text: 'Upload Cover',
                                ),

                                if (state
                                        is SocialUploadCoverImageLoadiogState ||
                                    state
                                        is SocialUploadProfileImageLoadiogState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUploadCoverImageLoadiogState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          )
                      ],
                    ),
                  // if (state is SocialUploadCoverImageLoadiogState ||
                  //         state is SocialUploadProfileImageLoadiogState)
                  //       SizedBox(
                  //         height: 5.0,
                  //       ),
                  // if (state is SocialUploadCoverImageLoadiogState ||
                  //     state is SocialUploadProfileImageLoadiogState)
                  //   LinearProgressIndicator(),
                  if (cubit.profileImage != null || cubit.coverImage != null)
                    SizedBox(
                      height: 20.0,
                    ),
                  defaultFormFaild(
                    controller: nameController,
                    label: 'Name',
                    prefix: IconBroken.User,
                    type: TextInputType.name,
                    validated: (String? value) {
                      if (value!.isEmpty) {
                        return 'Name not must be empty';
                      }
                      return null;
                    },
                    onTap: () {
                      print('enter your name');
                    },
                    onSubmitted: (value) {
                      print(value);
                    },
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormFaild(
                    controller: bioController,
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
                    type: TextInputType.text,
                    validated: (String? value) {
                      if (value!.isEmpty) {
                        return 'Bio not must be empty';
                      }
                      return null;
                    },
                    onTap: () {
                      print('enter your bio');
                    },
                    onSubmitted: (value) {
                      print(value);
                    },
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormFaild(
                    controller: phoneController,
                    label: 'Phone',
                    prefix: IconBroken.Call,
                    type: TextInputType.phone,
                    validated: (String? value) {
                      if (value!.isEmpty) {
                        return 'Phone not must be empty';
                      }
                      return null;
                    },
                    onTap: () {
                      print('enter your Phone');
                    },
                    onSubmitted: (value) {
                      print(value);
                    },
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
