import 'package:flutter/material.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerState createState() => new _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerWidget> {
  List<Asset> images = List<Asset>();
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#FF298BEE",
          actionBarTitle: "最多选九张",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
          autoCloseOnSelectionLimit: true,
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('选择照片'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("从相册中选择"),
              onPressed: loadAssets,
            ),
            RaisedButton(
              child: Text("拍摄"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}
