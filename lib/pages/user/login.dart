import 'dart:io';
import 'dart:typed_data';

import 'package:app/common/global.dart';
import 'package:app/common/http_util.dart';
import 'package:app/common/tools.dart';
import 'package:app/component/public_widget.dart';
import 'package:app/models/index.dart';
import 'package:app/models/user.dart';
import 'package:app/states/global_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  GlobalModel _globalData;
  User _user = User();
  bool _isFirstLogin = false;

  DateTime _lastPopTime;
  TextEditingController _userName = TextEditingController(text: 'admin');
  TextEditingController _pwd = TextEditingController(text: 'admin');
  TextEditingController _confirmPwd = TextEditingController();
  bool _isShowSecret = false;
  String _oldPwd;
  _changePwd() async {
    if (_pwd.text == '' || _confirmPwd.text == '') {
      PublicWidget.showToast('请输入新密码');
      return;
    }
    if (_pwd.text != _confirmPwd.text) {
      PublicWidget.showToast('两次密码输入不一致');
      return;
    }

    Response res = await HttpUtil().patchObject('user', _user.uid, {
      'password': {
        'oldpassword':
            PublicTools.generateSha256(Uint8List.fromList(_oldPwd.codeUnits)),
        'newpassword':
            PublicTools.generateSha256(Uint8List.fromList(_pwd.text.codeUnits))
      }
    });
    if (res != null) {
      if (res.statusCode == 200) {
        await _setUserInfo();
      }
    } else {
      PublicWidget.showToast('服务异常');
    }
  }

  _setUserInfo() async {
    Response res = await HttpUtil().getObject('user', _user.uid);
    String token = _user.token;
    _user = User.fromJson(res.data['user']);
    _user.token = token;
    _user.isLogin = true;
    Global.user = _user;
    _globalData.user = _user;
    PublicWidget.showToast('登录成功');
    Navigator.of(context).pushNamed("home");
  }

  _login() async {
    if (_userName.text == '') {
      PublicWidget.showToast('用户名不能为空');
      return;
    }
    if (_pwd.text == '') {
      PublicWidget.showToast('密码不能为空');
      return;
    }
    Response res =
        await HttpUtil().request(url: 'login', method: 'POST', data: {
      'account': _userName.text,
      'type': 'app',
      'password':
          PublicTools.generateSha256(Uint8List.fromList(_pwd.text.codeUnits))
    });
    if (res != null) {
      switch (res.statusCode) {
        case 200:
          Global.netCache.cache.clear();
          _user = User.fromJson(res.data);
          HttpUtil.dio.options.headers[HttpHeaders.authorizationHeader] =
              'Bearer ${_user.token}';
          await _setUserInfo();
          break;
        case 406:
          _oldPwd = _pwd.text;
          _user = User.fromJson(res.data);
          HttpUtil.dio.options.headers[HttpHeaders.authorizationHeader] =
              'Bearer ${_user.token}';
          setState(() {
            _pwd.text = '';
            _isFirstLogin = true;
          });
          break;
        case 401:
          PublicWidget.showToast('密码错误');
          break;
        case 404:
          PublicWidget.showToast('用户不存在');
          break;
      }
    } else {
      PublicWidget.showToast('请检查网络');
    }
  }

  Future<bool> _onWillPop() async {
    if (_lastPopTime == null ||
        DateTime.now().difference(_lastPopTime) > Duration(seconds: 2)) {
      _lastPopTime = DateTime.now();
      PublicWidget.showToast('再按一次退出');
      return false;
    } else {
      _lastPopTime = DateTime.now();
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _globalData = Provider.of<GlobalModel>(context);
    double offset = _isFirstLogin ? 0 : 60; //登陆输入框距离top偏移位置
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/background.png',
                    width: size.width,
                    height: size.height,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: new Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 161,
                          height: 84,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Text(
                          '徐州文广旅安全生产平台',
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 20,
                              wordSpacing: 27.46),
                        ),
                      ),
                      Offstage(
                        offstage: !_isFirstLogin,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Text(
                            '首次登录请更改初始密码',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                wordSpacing: 27.46),
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(25, offset, 25, 0),
                          width: 325,
                          height: 243,
                          child: Opacity(
                            opacity: 0.8,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Offstage(
                                    child: userNameColumn(),
                                    offstage: _isFirstLogin,
                                  ),
                                  Offstage(
                                    child: pwdColum('请输入密码'),
                                    offstage: _isFirstLogin,
                                  ),
                                  Offstage(
                                    child: pwdColum('新密码'),
                                    offstage: !_isFirstLogin,
                                  ),
                                  Offstage(
                                    child: confirmPwdColum('确认新密码'),
                                    offstage: !_isFirstLogin,
                                  ),
                                  loginColum()
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(
                                      style: BorderStyle.none, width: 1)),
                              // color: Colors.white70,
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget userNameColumn() {
    return Card(
      shape: PublicWidget.shape(5),
      child: TextField(
        controller: _userName,
        // autocorrect: true,
        style: TextStyle(fontSize: 14, color: Color(0xFF298BEE)),
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10.0),
          hintText: '请输入用户名',
        ),
      ),
    );
  }

  Widget pwdColum(String hintText) {
    return Card(
      shape: PublicWidget.shape(5),
      child: TextField(
        style: TextStyle(fontSize: 14, color: Color(0xFF298BEE)),
        controller: _pwd,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10.0),
          hintText: hintText,
          suffix: GestureDetector(
            onTap: () {
              if (_isShowSecret) {
                _isShowSecret = false;
                setState(() {});
              } else {
                _isShowSecret = true;
                setState(() {});
              }
            },
            child: Image.asset(
              _isShowSecret
                  ? 'assets/images/zhengyan.png'
                  : 'assets/images/biyan.png',
              width: 21,
              height: 13,
              color: Colors.black,
            ),
          ),
        ),
        obscureText: !_isShowSecret,
      ),
    );
  }

  Widget confirmPwdColum(String hintText) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(style: BorderStyle.none, width: 1)),
      child: TextField(
        style: TextStyle(fontSize: 14, color: Color(0xFF298BEE)),
        controller: _confirmPwd,
        inputFormatters: [LengthLimitingTextInputFormatter(50)],
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10.0),
          hintText: hintText,
          suffix: GestureDetector(
            onTap: () {
              if (_isShowSecret) {
                _isShowSecret = false;
                setState(() {});
              } else {
                _isShowSecret = true;
                setState(() {});
              }
            },
            child: Image.asset(
              _isShowSecret
                  ? 'assets/images/zhengyan.png'
                  : 'assets/images/biyan.png',
              width: 21,
              height: 13,
              color: Colors.black,
            ),
          ),
        ),
        obscureText: !_isShowSecret,
      ),
    );
  }

  Widget loginColum() {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: ButtonTheme(
          minWidth: 315.0,
          height: 44.0,
          child: RaisedButton(
            child: Text(
              '登录',
              style: TextStyle(
                color: Color(0xFFFEFEFF),
                fontSize: 16,
                letterSpacing: 15,
              ),
            ),
            onPressed: () async {
              // _contentFocusNode.unfocus();
              if (_isFirstLogin) {
                await _changePwd();
              } else {
                await _login();
              }
            },
            color: Color(0xFF1E72EA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                side: BorderSide(style: BorderStyle.none, width: 0)),
          )),
    );
  }
}
