import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

//工具类
class PublicTools {
  static internetState() async {
    try {
      var result = await InternetAddress.lookup('www.baidu.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  //数字中文英文
  static RegExp generalText = RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]");
  //emoji
  static RegExp emojiText = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  //中国电话号码
  static bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  //6位数字验证码
  static bool isValidateCaptcha(String input) {
    RegExp mobile = new RegExp(r"\d{6}$");
    return mobile.hasMatch(input);
  }

  //8~16位数字和字符组合,区分大小写
  static bool isLoginPassword(String input) {
    RegExp mobile =
        new RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,16}$");
    return mobile.hasMatch(input);
  }

  //md5
  static String generateMd5(Uint8List bytes) {
    var digest = md5.convert(bytes);
    return hex.encode(digest.bytes);
  }

  //sha256
  static String generateSha256(List bytes) {
    var digest = sha256.convert(bytes);
    return hex.encode(digest.bytes);
  }

  //生成base16编码
  static String getBase16FromBytes(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  static Uint8List getBytesFromBase16(String base16) {
    Uint8List bytes = Uint8List.fromList(
      List.generate(base16.length,
              (i) => i % 2 == 0 ? base16.substring(i, i + 2) : null)
          .where((b) => b != null)
          .map((b) => int.parse(b, radix: 16))
          .toList(),
    );
    return bytes;
  }

  static String generateRandomKey() {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = 6;

    /// 生成的字符串固定长度
    String randomKey = '';
    for (var i = 0; i < strlenght; i++) {
      randomKey = randomKey + alphabet[Random().nextInt(alphabet.length)];
    }
    return randomKey;
  }

  static String changeSecondsToHms(num seconds) {
    String str = '';
    num hour = seconds ~/ 3600;
    num left = seconds % 3600;
    if (hour.toString().length < 2) {
      str += '0' + hour.toString() + ':';
    } else {
      str += hour.toString() + ':';
    }
    num minute = left ~/ 60;
    seconds = left % 60;
    if (minute.toString().length < 2) {
      str += '0' + minute.toString() + ':';
    } else {
      str += minute.toString() + ':';
    }
    if (seconds.toString().length < 2) {
      str += '0' + seconds.toString();
    } else {
      str += seconds.toString();
    }
    return str;
  }

  static clearCatch() async {
    String path = (await getTemporaryDirectory()).path + '/';
    Directory dir = Directory(path);
    Stream<FileSystemEntity> entityList =
        dir.list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in entityList) {
      //文件、目录和链接都继承自FileSystemEntity
      //FileSystemEntity.type静态函数返回值为FileSystemEntityType
      //FileSystemEntityType有三个常量：
      //Directory、FILE、LINK、NOT_FOUND
      //FileSystemEntity.isFile .isLink .isDerectory可用于判断类型
      entity.deleteSync();
    }
  }
}
