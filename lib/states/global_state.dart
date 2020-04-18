import 'package:app/common/global.dart';
import 'package:app/models/user.dart';
import 'package:flutter/material.dart';

class GlobalModel extends ChangeNotifier {
  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
    Global.user = user;
    Global.saveProfile();
    super.notifyListeners();
  }
}
