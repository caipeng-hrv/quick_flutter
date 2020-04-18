import 'package:app/common/http_util.dart';
import 'package:app/component/slide_button.dart';
import 'package:app/config/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//快速创建一个新页面，复制，然后替换MyListview

class MyListview extends StatefulWidget {
  final Map searchParam;
  final Function card;
  final Function onTap;
  final String url;
  bool reload;

  MyListview(
      {Key key,
      @required this.searchParam,
      @required this.card,
      @required this.url,
      @required this.onTap,
      this.reload})
      : super(key: key);
  @override
  _MyListviewState createState() => _MyListviewState();
}

class _MyListviewState extends State<MyListview> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List _dataList = [];
  bool _isFirstLoad = true;
  Map _searchParam = Config.searchParam;

  _initParam() {
    _searchParam = {'limit': 10, 'offset': 0, 'total': 0};
    if (widget.searchParam.length > 0) {
      widget.searchParam.forEach((key, value) {
        if (value != null && value != '') {
          _searchParam[key] = value;
        }
      });
    }
  }

  Future _loadData([String actionType]) async {
    print('before:$_searchParam');
    Response res = await HttpUtil().getObjects(widget.url, _searchParam);
    if (res.statusCode == 200) {
      if (actionType != 'load') {
        _dataList = [];
        _dataList = res.data[widget.url + 's'];
      } else {
        _dataList.addAll(res.data[widget.url + 's']);
      }
      _searchParam['offset'] += res.data[widget.url + 's'].length;
      _searchParam['total'] = res.data['total'];
      if (mounted) {
        setState(() {});
      }
    } else {
      _dataList = [];
      _refreshController.loadFailed();
    }
  }

  Widget buildCtn() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      // padding: EdgeInsets.only(left: 5, right: 5),
      itemBuilder: (c, i) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            await widget.onTap(_dataList[i]);
          },
          child: SlideButton(
              buttons: <Widget>[],
              child: widget.card(_dataList[i]),
              singleButtonWidth: 70)),
      itemCount: _dataList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _initParam();
      _loadData();
    }
    if (widget.reload ?? false) {
      widget.reload = false;
      _initParam();
      _loadData();
    }
    return Scaffold(
        body: SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      child: buildCtn(),
      header: WaterDropHeader(),
      onRefresh: () async {
        _initParam();
        await _loadData();
        _refreshController.refreshCompleted();
      },
      onLoading: () async {
        if (_dataList.length != _searchParam['total']) {
          await _loadData('load');
        }
        _refreshController.loadComplete();
      },
    ));
  }
}
