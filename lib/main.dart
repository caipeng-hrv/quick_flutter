import 'package:app/common/global.dart';
import 'package:app/component/image_picker.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/user/check_version.dart';
import 'package:app/pages/user/login.dart';
import 'package:app/pages/user/personal.dart';
import 'package:app/states/global_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'component/browser.dart';
import 'component/cupertino_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Global.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: GlobalModel()),
    ],
    child: MyApp(),
  ));
}

//首页
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyAppStata();
  }
}

class _MyAppStata extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '鲲鹏之志',
      localizationsDelegates: [
        RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
        const Locale('zh', ''),
      ],
      routes: <String, WidgetBuilder>{
        "home": (context) => HomePage(),
        "login": (context) => LoginPage(),
        "imagePicker": (context) => ImagePickerWidget(),
        "personal": (context) => PersonalPage(),
        'browser': (context) => BrowserPage(),
      },
      theme: new ThemeData(
        primaryColor: Color(0xFF2779F4),
        backgroundColor: Color(0xFFefeff4),
        // accentColor: Color(0xFF888888),
        textTheme: TextTheme(
          //设置Material的默认字体样式
          body1: TextStyle(color: Color(0xFF45486D), fontSize: 15.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: CheckVersionPage(
          child:HomePage()),
    );
  }
}
