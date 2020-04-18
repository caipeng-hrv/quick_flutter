// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..uid = json['uid'] as num
    ..isLogin = json['isLogin'] as bool
    ..token = json['token'] as String
    ..account = json['account'] as String
    ..mail = json['mail'] as String
    ..mobile = json['mobile'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'isLogin': instance.isLogin,
      'token': instance.token,
      'account': instance.account,
      'mail': instance.mail,
      'mobile': instance.mobile
    };
