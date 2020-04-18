import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/common/global.dart';
import 'package:app/component/public_widget.dart';
import 'package:app/config/config.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';

class HttpUtil {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  Options _options = Options(extra: {
    'noCache': true,
  });
  static Dio dio = new Dio(BaseOptions(baseUrl: Config.baseurl));

  static void init() {
    // 添加缓存插件
    dio.interceptors.add(Global.netCache);
    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (Config.env == 'dev') {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // client.findProxy = (uri) {
        //   return "PROXY 10.1.10.250:8888";
        // };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  //所有请求都走request接口
  Future request({String url, String method, Map data}) async {
    Map<String, dynamic> params = {};
    if (data != null) {
      data.keys.forEach((key) {
        params[key] = data[key];
      });
    }
    BuildContext context = params.remove('context');
    dio.options.headers['method'] = method;
    Map queryParameters;
    if (method == 'GET' || method == 'DELETE' || method == null) {
      queryParameters = params;
      params = null;
    }
    Response res;
    DioError error;
    if ((method == 'GET' || method == null) &&
        queryParameters != null &&
        queryParameters.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        if (value is List) {
          for (var i = 0; i < value.length; i++) {
            options.write('$key=${value[i]}&');
          }
          queryParameters.remove(key);
        }
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }
    try {
      res = await dio.request(url,
          data: params,
          queryParameters: queryParameters,
          options: _options.merge(method: method));
      return _statusFilter(res, error, context);
    } catch (e) {
      print(e);
      error = e;
      return _statusFilter(res, error, context);
    }
  }

  Future<Response> getObjects(String name, [Map data]) async {
    return await this.request(url: name, data: data);
  }

  Future<Response> getObject(String name, num id, [Map data]) async {
    return await this.request(url: '$name/$id', data: data);
  }

  Future<Response> postObject(String name, [Map data]) async {
    return await this.request(url: name, data: data, method: 'POST');
  }

  Future<Response> patchObject(String name, num id, [Map data]) async {
    return await this.request(url: '$name/$id', data: data, method: 'PATCH');
  }

  Future download(String uri, {Function onReceive}) async {
    String saveFilePath;
    String callback(Headers responseHeaders) {
      saveFilePath = Global.downloadPath +
          Utf8Decoder().convert(responseHeaders['content-disposition'][0]
              .split("''")[1]
              .codeUnits);
      return saveFilePath;
    }

    try {
      await dio.download(uri, callback, options: _options.merge(),
          onReceiveProgress: (count, total) {
        if (onReceive != null) {
          onReceive();
        }
      });
      return saveFilePath;
    } catch (e) {
      print(e);
    }
  }

  //过滤器
  _statusFilter(Response res, DioError error, BuildContext context) async {
    if (error != null) {
      print(error.request.uri);
      res = error.response;
    }
    if (res == null) {
      PublicWidget.showToast('无法连接服务器');
      return Response(statusCode: 400);
    }
    if (context == null) {
      return res;
    }
    switch (res.statusCode) {
      case 200:
        switch (res.data['code']) {
          case 'tokenErr':
            PublicWidget.showToast('您的账号在其它设备登录');
            await Global.logout();
            break;
          case 'pwdErr':
            PublicWidget.showToast('账户密码已更改');
            // await Api.logOut(context);
            break;
          default:
            return res;
        }
        break;
      case 401:
        PublicWidget.showToast('token过期,请重新登录');
        await Global.logout();
        break;
      case 403:
        PublicWidget.showToast('权限不足');
        break;
      case 500:
        PublicWidget.showToast(res.data['responseDesc']);
        break;
      default:
        PublicWidget.showToast('请检查网络');
    }
    return res;
  }
}
