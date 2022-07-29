import 'package:bot_toast/bot_toast.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter_application_2/layout/socialApp/cubit/cubit.dart';

import 'package:flutter_application_2/layout/socialApp/socialLayout.dart';
import 'package:flutter_application_2/modules/Social_app/login/social_login.dart';

import 'package:flutter_application_2/shared/bloc_observer.dart';
import 'package:flutter_application_2/shared/components/components.dart';

import 'package:flutter_application_2/shared/components/constants.dart';
import 'package:flutter_application_2/shared/cubit/cubit.dart';
import 'package:flutter_application_2/shared/cubit/states.dart';
import 'package:flutter_application_2/shared/network/local/cache_helper.dart';

import 'package:flutter_application_2/shared/styles/themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('BackgroundMessage');
  print(message.data.toString());

//   showToast(msg: 'onBackGroundMessage', state: ToastStates.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken() ?? '';
  print(token);

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();

  Widget widget;

  bool? isDark = CacheHelper.getBoolean(key: 'isDark');

  uId = CacheHelper.getData(key: 'uId');
  print(uId);

  FirebaseMessaging.onMessage.listen((event) {
    print('onMessage');
    print(event.data.toString());
    showToast(msg: 'onMessage', state: ToastStates.SUCCESS);
    if (event.notification != null) {
      print('Message also contained a notification: ${event.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('onMessage opened app');
    print(event.data.toString());
    showToast(msg: 'onMessage opened app', state: ToastStates.SUCCESS);
    if (event.notification != null) {
      print('Message also contained a notification: ${event.notification}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  //final bool? onBoarding;
  final Widget? startWidget;
  MyApp({this.isDark, this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (context) => SocialCubit()
            ..getUserData()
            ..getPost()
            ..getAllUsers(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.light,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              home: startWidget,
            );
          }),
    );
  }
}
