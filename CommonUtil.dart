import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_html/flutter_html.dart';

//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:oktoast/oktoast.dart';
import 'package:xianzhiyoupin/common/CommonInsert.dart';
import 'package:xianzhiyoupin/common/style/colors.dart';
import 'package:xianzhiyoupin/common/style/fonts.dart';
import 'package:xianzhiyoupin/page/LoginPage.dart';
import 'package:xianzhiyoupin/page/my/accountandsafty/SetPayPasswordPage.dart';

import '../BaseCommon.dart';
//import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

class CommonUtil {
  static const DEBUG = true;

  static final EventBus eventBus = new EventBus();

  static const Local_Icon_Prefix = "asset/images/";

//  static String getImage(String image,{String type : ".png"}) {
//    return Local_Icon_prefix + image + type;
//  }

  static double statusBarHeight = 0.0;

//  static Future initStatusBarHeight() async {
//    statusBarHeight = await FlutterStatusbarManager.getHeight;
//  }

  static Future openPage(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }

  static Future openPageReplacement(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => widget));
  }

  static closePage(BuildContext context) {
    Navigator.pop(context);
  }

  static bool statusDeviceIsAndroidTablet = false;

  static initStatusDeviceIsAndroidTablet(value) {
    statusDeviceIsAndroidTablet = value;
  }

  static isPhoneNo(String phone) {
    if (phone == null) return false;

    phone = phone.trim();

    RegExp exp = RegExp(r'^1[0-9]{10}$');
    return exp.hasMatch(phone);
  }

  static isPasswordValid(String password) {
    if (password == null) return false;

    password = password.trim();
    RegExp exp = new RegExp(r'^[0-9a-zA-Z_]{6,16}$');
    return exp.hasMatch(password);
  }

  static isChineseValid(String chinese) {
    if (chinese == null) return false;

    chinese = chinese.trim();
    RegExp exp = RegExp(r'^[\u4e00-\u9fa5]{1,10}$');
    return exp.hasMatch(chinese);
  }

  static isBankAccountValid(String account) {
    if (account == null) return false;

    account = account.trim();
    RegExp exp = RegExp(r'^([1-9]{1})(\d{14}|\d{18})$');
    return exp.hasMatch(account);
  }

  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                  onWillPop: () => new Future.value(false),
                  child: Center(
                    child: new CupertinoActivityIndicator(),
                  )));
        });
  }

  ///各类协议弹窗
  static Future<Null> showHtmlDialog(
      BuildContext context, String content, Function disAgree, Function agree) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 300,
                      height: 450,
                      decoration: BoxDecoration(
                          color: MyColors.grey_6f6,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        children: <Widget>[
                          content != ""
                              ? Expanded(
                                  child: SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: HtmlWidget(content),
                                  ),
                                )
                              : Container(
                                  height: double.maxFinite,
                                ),
                          SizedBox(height: 10),
                          SeparatorWidget(left: 0, right: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    disAgree();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 30),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: MyColors.white_ff,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8)),
                                    ),
                                    child: Text("不同意",
                                        style:
                                            TextStyle(color: MyColors.grey_99)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      agree();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MyColors.white_ff,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(8)),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      alignment: Alignment.center,
                                      child: Text("同意",
                                          style: TextStyle(
                                              color: MyColors.red_00)),
                                    )),
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ));
        });
  }

  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static String getChatTime(int timeStamp, {bool deal: true}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    if (BaseCommon.easeNowTime != null) {
      if ((timeStamp - BaseCommon.easeNowTime).abs() < 120000) {
        return null;
      }
    }
    if (deal) {
      BaseCommon.easeNowTime = timeStamp;
    }
    String timeHead = "";
    if (dateTime.day == DateTime.now().day) {
      if (dateTime.hour < 12) {
        timeHead = "上午";
      } else if (dateTime.hour < 18) {
        timeHead = "下午";
      } else {
        timeHead = "晚上";
      }
    } else if (dateTime.day == DateTime.now().subtract(Duration(days: 1)).day) {
      timeHead = "昨天";
    } else if (dateTime.year == DateTime.now().year) {
      timeHead = (dateTime.month.toString().padLeft(2, "0")) +
          "-" +
          (dateTime.day.toString().padLeft(2, "0"));
    } else {
      timeHead = (dateTime.month.toString().padLeft(2, "0")) +
          "-" +
          (dateTime.day.toString().padLeft(2, "0"));
      timeHead = dateTime.year.toString() + "-" + timeHead;
    }
    return timeHead +
        " " +
        (dateTime.hour.toString().padLeft(2, "0")) +
        ":" +
        (dateTime.minute.toString().padLeft(2, "0"));
  }

  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    } else {
      return '片刻之间';
    }
  }

  //金额要么留小数点两位，要么不留小数点 返回的是String
  static String formatNumber(double num) {
    //获取钱
    String formatNum = '0.0';
    if (num != null) {
      String str = num.toString();
      // 分开截取
      List<String> sub = str.split('.');
      //判断小数点后是否为0
      if (double.parse(sub[1]) == 0.0) {
        formatNum = sub[0];
      } else {
        formatNum = num.toStringAsFixed(2);
      }
    }
    return formatNum;
  }

//  //金额格式化 逗号
//  static String formatNum(num) {
//    var point = 2;
//    if (num != null) {
//      String str = double.parse(num.toString()).toString();
//      // 分开截取
//      List<String> sub = str.split('.');
//      // 处理值
//      List val = List.from(sub[0].split(''));
//      // 处理点
//      List<String> points = List.from(sub[1].split(''));
//      //处理分割符
//      for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
//        // 除以三没有余数、不等于零并且不等于1 就加个逗号
//        if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
//      }
//      // 处理小数点
//      for (int i = 0; i <= point - points.length; i++) {
//        points.add('0');
//      }
//      //如果大于长度就截取
//      if (points.length > point) {
//        // 截取数组
//        points = points.sublist(0, point);
//      }
//      // 判断是否有长度
//      if (points.length > 0) {
//        return '${val.join('')}.${points.join('')}';
//      } else {
//        return val.join('');
//      }
//    } else {
//      return "0.0";
//    }
//  }

  static String hidePhone(String value) {
    if (value != '') {
      value = value.substring(0, value.length - (value.substring(3)).length) +
          "****" +
          value.substring(7);
    }

    return value;
  }

  static showMyToast(String msg,
      {ToastPosition myPosition = ToastPosition.bottom,
      Color myColor = MyColors.yellow_42}) {
    showToast(msg, position: myPosition, backgroundColor: myColor);
  }

  static showLoginDialog(context, title) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                content: Text('登陆之后才能' + title + '，你是否要先登陆？',
                    style: TextStyle(
                        fontSize: MyFonts.f_14, color: MyColors.black_33)),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('取消',
                          style: TextStyle(
                              fontSize: MyFonts.f_14,
                              color: MyColors.black_33)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  CupertinoDialogAction(
                      child: Text('确定',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/Login_Page');
                      })
                ]));
  }

  //第一次进入钱包，设置支付密码弹窗
  static showSetPaymentPasswordDialog(context, Function cancel, Function sure) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: Text('你还没有设置支付密码',
                    style: TextStyle(
                        fontSize: MyFonts.f_16, color: MyColors.black_33)),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('取消',
                          style: TextStyle(
                              fontSize: MyFonts.f_14,
                              color: MyColors.black_33)),
                      onPressed: () {
                        cancel();
                      }),
                  CupertinoDialogAction(
                      child: Text('去设置',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        sure();
                      })
                ]));
  }

  ///底部两按钮弹窗
  static showMyDialog(context, String text, Function fun,
      {Function cancelFunction}) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: Text(text ?? "",
                    style: TextStyle(
                        fontSize: MyFonts.f_14, color: MyColors.black_33)),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('取消',
                          style: TextStyle(
                              fontSize: MyFonts.f_14,
                              color: MyColors.black_33)),
                      onPressed: () {
                        if (cancelFunction == null) {
                          Navigator.pop(context);
                        } else {
                          cancelFunction();
                        }
                      }),
                  CupertinoDialogAction(
                      child: Text('确定',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        fun();
                      })
                ]));
  }

  ///账号失效弹窗
  static userFailureDialog(context, String text) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                title: Text(text ?? "",
                    style: TextStyle(
                        fontSize: MyFonts.f_16, color: MyColors.black_33)),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('确定',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        LocalStorage.setLogoutState();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => route == null);
                      })
                ]));
  }

  ///进入app时弹出协议
  static showAgreementDialog(
      context, Widget content, Function disAgree, Function agree) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                //title: ,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('不同意',
                          style: TextStyle(
                              fontSize: MyFonts.f_14,
                              color: MyColors.black_33)),
                      onPressed: () {
                        disAgree();
                      }),
                  CupertinoDialogAction(
                      child: Text('同意',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        agree();
                      })
                ]));
  }

  ///警告弹窗（底部一按钮）
  static showAlertDialog(context, String text, Function function) {
    showCupertinoDialog(
        context: context,
        builder: (_) => WillPopScope(
            onWillPop: () async {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
                title: Text(text ?? "",
                    style: TextStyle(
                        fontSize: MyFonts.f_16, color: MyColors.black_33)),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('确定',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        if (function != null) {
                          function();
                        }
                      })
                ])));
  }

  //提交订单时存在仅支持余额支付的商品弹窗
  static showOnlyBalanceDialog(context) {
    showCupertinoDialog(
        context: context,
        builder: (_) => Material(
              color: Colors.transparent,
              child: CupertinoAlertDialog(
                  title: Container(
                    padding: EdgeInsets.only(bottom: 20, left: 24, right: 24),
                    child: Text('提示',
                        style: TextStyle(
                            color: MyColors.black_33, fontSize: MyFonts.f_16)),
                  ),
                  content: Text('您结算的商品中存在仅支持余额支付的商品，本次订单只支持余额支付',
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: MyFonts.f_14, color: MyColors.black_33)),
                  actions: <Widget>[
                    CupertinoDialogAction(
                        child: Text('我知道了',
                            style: TextStyle(
                                fontSize: MyFonts.f_16,
                                color: MyColors.black_33)),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]),
            ));
  }

  static String getPlatForm() {
    String _platForm = '';

    if (Platform.isAndroid) {
      _platForm = 'Android';
    } else if (Platform.isIOS) {
      _platForm = 'IOS';
    }

    return _platForm;
  }

  static String getDate(String date) {
    if (date != '') {
      if (DateTime.now().year != int.parse(date.substring(0, 4))) {
        return date.substring(0, 10);
      } else {
        return date.substring(5, 10);
      }
    } else
      return '';
  }

//
//  ///压缩图片
//  static Future<File> dealImg(File file)async{
//    CompressFormat imgFormat = CompressFormat.jpeg;//设置处理图片的格式--默认为jpeg
//    String format = file.path.split("/").last.split(".").last;//获取图片的格式
//
//    if(format=="png"){
//      imgFormat = CompressFormat.png;
//    }
//
//    print('压缩前图片文件大小:' + file.lengthSync().toString());
//    File imageFile = await FlutterImageCompress.compressAndGetFile(
//        file.absolute.path,
//        Directory.systemTemp.path +"/"+ file.path.split("/").last,
//        quality: 90,
//        minWidth: 1000,
//        minHeight: 1000,
//        format: imgFormat
//    );
//    print('压缩后图片文件大小:' + imageFile.lengthSync().toString());
//    print("====$imageFile=====") ;
//    return imageFile;
//  }

  ///是否为游客操作
  static isTouristMode(context, Function function) {
    if (LocalStorage.get(BaseCommon.TOKEN) == null) {
      showMyDialog(
        context,
        "执行此功能需先登录，前往登录？",
        () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => route == null);
        },
      );
    } else {
      function();
    }
  }

  ///更新弹窗（不强制更新）
  static showUpdateDialog(context, String title, Widget content) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 300,
                        height: 450,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: double.maxFinite,
                                      color: MyColors.white,
                                      height: 120,
                                    )),
                                LocalImageSelecter.getImage('pop_update'),
                                Positioned(
                                    bottom: 27,
                                    child: Container(
                                      width: 300,
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: MyFonts.f_14,
                                            color: MyColors.black_33),
                                      ),
                                      alignment: Alignment.center,
                                    ))
                              ],
                            ),
                            Container(
                              child: content,
                              color: MyColors.white,
                            )
                          ],
                        ))
                  ],
                ),
                onWillPop: () async {
                  return Future.value(false);
                },
              ));
        });
  }
}
