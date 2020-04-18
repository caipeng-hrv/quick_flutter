// 提供五套可选主题色
import 'dart:convert';
import 'dart:io';

import 'package:app/common/http_util.dart';
import 'package:app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'net_cache.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _prefs;
  static List areas;
  static List industrys;

  // 网络缓存对象
  static NetCache netCache = NetCache();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  static User user = User();

  static String downloadPath;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    Directory storageDir = await getExternalStorageDirectory();
    Directory baseDir = Directory(storageDir.path.split('Android')[0] + '徐州文旅');
    baseDir.createSync();
    downloadPath = baseDir.path + '/';
    _prefs = await SharedPreferences.getInstance();
    String userInfo = _prefs.getString("user");
    user.isLogin = false;
    HttpUtil.init();
    if (userInfo != null) {
      user = User.fromJson(jsonDecode(userInfo));
      if (user.token != null) {
        HttpUtil.dio.options.headers[HttpHeaders.authorizationHeader] =
            'Bearer ${user.token}';
        Response res = await HttpUtil().getObject('user', user.uid);
        if (res.statusCode == 200) {
          HttpUtil.dio.options.headers[HttpHeaders.authorizationHeader] =
              'Bearer ${user.token}';
          user.isLogin = true;
        }
      }
    }
    HttpUtil.init();
  }

  // 持久化Profile信息
  static saveProfile() => _prefs.setString("user", jsonEncode(user.toJson()));
  static logout() => _prefs.remove("user");
}
