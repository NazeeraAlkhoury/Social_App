import 'package:flutter_application_2/shared/network/local/cache_helper.dart';

String token = CacheHelper.getData(key: 'token');

String? uId;

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) {
    print(match.group(0));
  });
}
