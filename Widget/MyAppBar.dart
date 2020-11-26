import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:tik3c/src/themes/theme.dart';

///
/// @author [zoro]
/// 【通用的APPBar】
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar(
    this.context,
    this.routeName, {
    this.title,
    this.backHint: false,
    this.centerTitle: true,
    this.bgColor: MyColors.PRIMARY,
    this.textBgColor: MyColors.TEXT_PRIMARY,
    this.elevation: 0,
    this.leftWidget,
    this.centerWidget,
    this.rightWidgetList,
    this.leftFunction,
    this.centerFunction,
  });

  BuildContext context;
  String routeName; //用于打点
  String title;
  bool backHint; //左侧组件隐藏，默认false
  bool centerTitle; //中间内容是否居中，默认为true
  Color bgColor; //背景颜色,默认黑色
  Color textBgColor; //文字颜色,默认白色
  double elevation; //阴影。默认为0

  Widget leftWidget; //左侧组件，用于重写
  Widget centerWidget; //中间组件，用于重写情况，如果指定这个，则[title]无效
  List<Widget> rightWidgetList; //右侧组件列表
  Function leftFunction; //左侧点击事件，若为空则默认返回上一个页面
  Function centerFunction; //中间组件点击事件

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _getLeading(),
      title: _getTitle(),
      actions: _getRight(),
      backgroundColor: Colors.black,
      centerTitle: centerTitle,
      elevation: elevation,
    );
  }

  ///左侧组件
  Widget _getLeading() {
    if (backHint) return Container();
    if (leftWidget != null) return leftWidget;
    return InkWell(
      onTap: () {
        if (leftFunction != null)
          leftFunction();
        else
          Navigator.pop(context);
      },
      child: leftWidget != null
          ? leftWidget
          : Icon(Icons.arrow_back_ios_outlined, size: 20),
    );
  }

  ///中间组件
  Widget _getTitle() {
    if (centerWidget != null) return centerWidget;
    return InkWell(
        onTap: () {
          if (centerFunction != null) centerFunction();
        },
        child: Container(
            child: Text(title ?? '',
                style: TextStyle(color: Colors.white, fontSize: 16))));
  }

  ///右侧组件列表
  List<Widget> _getRight() {
    return rightWidgetList ?? [];
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
