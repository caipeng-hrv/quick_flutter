import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:convert';

String projectDir = path.current;
main(List<String> args) {
  Map config =
      json.decode(File('$projectDir/init/config.json').readAsStringSync());
  initPackageName(config['packageName']);
  initApplicationName(config['applicationName']);
  initApplicationIcon();
  initApplicationAutograph(config['storePassword'], config['keyPassword']);
}

initPackageName(String packageName) {
  //修改包名
  String sourceName = 'com.kunpeng.quick';
  changeFile('$projectDir/android/app/src/main/AndroidManifest.xml', sourceName,
      packageName);
  changeFile('$projectDir/android/app/src/debug/AndroidManifest.xml',
      sourceName, packageName);
  changeFile('$projectDir/android/app/src/profile/AndroidManifest.xml',
      sourceName, packageName);
  changeFile(
      '$projectDir/android/app/src/main/kotlin/com/example/app/MainActivity.kt',
      sourceName,
      packageName);
  changeFile('$projectDir/android/app/build.gradle', sourceName, packageName);
  changeFile('$projectDir/ios/Runner/Info.plist', sourceName, packageName);
  print('修改包名完成');
}

initApplicationName(String applicationName) {
  //修改应用名
  String sourceName = '鲲鹏';
  changeFile('$projectDir/android/app/src/main/AndroidManifest.xml', sourceName,
      applicationName);
  changeFile('$projectDir/ios/Runner/Info.plist', sourceName, applicationName);
  print('修改应用名完成');
}

initApplicationIcon() {
  //替换应用图标
  String basePath = '$projectDir/init/icons/android/';
  List childPaths = [
    'mipmap-hdpi',
    'mipmap-ldpi',
    'mipmap-mdpi',
    'mipmap-xhdpi',
    'mipmap-xxhdpi',
    'mipmap-xxxhdpi',
  ];
  childPaths.forEach((item) {
    Directory androidDir = Directory(basePath + item);
    String androidSource = '$projectDir/android/app/src/main/res/$item';
    Directory(androidSource).deleteSync(recursive: true);
    androidDir.rename(androidSource);
  });

  Directory iosDir = Directory('$projectDir/init/icons/ios/AppIcon.appiconset');
  String iosSource =
      '$projectDir/ios/Runner/Assets.xcassets/AppIcon.appiconset';
  Directory(iosSource).deleteSync(recursive: true);
  iosDir.renameSync(iosSource);
  print('替换应用图标完成');
}

initApplicationAutograph(String storePassword, String keyPassword) {
  File file = File('$projectDir/android/key.properties');
  String keyInfo = '''    storePassword=$storePassword
    keyPassword=$keyPassword
    keyAlias=key
    storeFile=my.jks
    ''';
  file.writeAsStringSync(keyInfo);
  File('$projectDir/init/my.jks').copySync('$projectDir/android/app/key.jks');
  print('应用签名配置完成');
}

changeFile(String name, String source, String replace) {
  File file = File(name);
  String str = file.readAsStringSync();
  str = str.replaceAll(source, replace);
  file.writeAsStringSync(str);
}
