import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:convert/convert.dart';

class Beecloud {
  static String appId;
  static String appSecret;
  static String aliPay = 'ALI_APP';
  static String wxPay = 'WX_APP';
  static init(String id, String secret) async {
    // Response res = await HttpUtil().request(url: 'beecloud');
    // appId = res.data['appid'];
    // appSecret = res.data['appsecret'];
    appId = id;
    appSecret = secret;
  }

  static pay(num fee,String type) async {
    num timestamp = DateTime.now().millisecondsSinceEpoch;
    String signStr = '$appId$timestamp$appSecret';
    print(signStr);
    String appSign = generateMd5(Uint8List.fromList(signStr.codeUnits));
    Map<String, dynamic> data = {
      'app_id': appId,
      'timestamp': timestamp,
      'app_sign': appSign,
      'channel': type,
      'total_fee': fee,
      'bill_no': '12361885211$timestamp',
      'title': '测试'
    };
    Response res =
        await Dio().post('https://api.beecloud.cn/2/rest/bill', data: data);
    return res;
  }
}

String generateMd5(Uint8List bytes) {
  var digest = md5.convert(bytes);
  return hex.encode(digest.bytes);
}
