**一个便于快速开发flutterApp的项目**

1. `git clone https://github.com/caipeng-hrv/quick_flutter.git`

2. 生成android应用签名

   `cd init`

   `sh qianming.sh`

3. 修改配置文件init/config.json,添加应用图标到icons目录下，运行init.dart(此步骤可修改init.dart文件确定要修改信息)

   `dart init.dart`

4. 用json文件生成实体类，在jsons目录下添加对应的json文件,在根目录运行

   `flutter packages pub run json_model`

**常用插件**

- MyListview 自定义的listview
- SlideButton 可滑动的组件，配合MyListview使用
- GirdViewButton 多个button组件(单选)
- MyDropdownButton 下拉列表组件
- ImagePicker 相册组件
- TimePicker 日历

