import 'package:app/common/bee_cloud.dart';
import 'package:app/component/base_page.dart';
import 'package:app/component/my_gird_button.dart';
import 'package:app/component/public_widget.dart';
import 'package:app/pages/example/list_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alipay/flutter_alipay.dart';
import 'package:fluwx/fluwx.dart';

//快速创建一个新页面，复制，然后替换Example
class ExamplePage extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<ExamplePage> {
  String name = 'listview';
  
  show(){
    
    Beecloud.init('appid',
              'appsecret');
    switch (name) {
      case 'listview':
        return ListviewExamplePage();
        break;
      case 'alipay':
        return PublicWidget.serchButton('支付宝', () async {
          Response res = await Beecloud.pay(1,Beecloud.aliPay);
          try {
            var payResult = await FlutterAlipay.pay(res.data['order_string']);

            switch (payResult.resultStatus) {
              case '9000':
                PublicWidget.showToast('支付成功');
                break;
              case '8000':
                PublicWidget.showToast('正在处理中');
                break;
              case '4000':
                PublicWidget.showToast('订单支付失败');
                break;
              case '5000':
                PublicWidget.showToast('重复请求');
                break;
              case '6001':
                PublicWidget.showToast('已取消支付');
                break;
              case '6002':
                PublicWidget.showToast('网络错误');
                break;
              default:
                PublicWidget.showToast('订单支付失败');
            }
          } catch (e) {
            print(e);
          }
        });
        break;
      case 'wxpay':
        return PublicWidget.serchButton('微信支付', ()async{
          await registerWxApi(appId: "wx2ec67c27eed18dc9",universalLink: "https://your.univerallink.com/link/");
          Response res = await Beecloud.pay(1,Beecloud.wxPay);
          print(res);
          // payWithWeChat(
          //       appId: result['appid'],
          //       partnerId: result['partnerid'],
          //       prepayId: result['prepayid'],
          //       packageValue: result['package'],
          //       nonceStr: result['noncestr'],
          //       timeStamp: result['timestamp'],
          //       sign: result['sign'],
          //     );
        });
      default:
        return Container();
    }
  }

  static List datas = [
    {'name': '列表', 'value': 'listview'},
    {'name': '搜索按钮', 'value': 'wxpay'},
    {'name': '提交按钮', 'value': 'alipay'},
    {'name': '输入框', 'value': 'listview'}
  ];

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GirdViewButton(
          datas: datas,
          onChange: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        ),
        PublicWidget.divider(),
        Expanded(child: show())
      ],
    );
    return BasePage(title: '例子', body: body).build();
  }
}
