import 'dart:math';

import 'package:flutter/material.dart';

/// 此Widget会随机的给它内部的子widget分配一个位置
/// 并且不会限制子Widget的大小
///
/// 此Widget在本项目中未被使用
/// 保留此Widget做学习用
/// 

class BallView extends MultiChildLayoutDelegate {
  int childLength;

  BallView(this.childLength);

  @override
  void performLayout(Size size) {
    for (int i = 0; i < childLength; i++) {
      if (hasChild(i)) {
        //完全由子View自己控制大小，不做任何限制
        var childSize = layoutChild(i, new BoxConstraints());

        //定位 - 随机位置
        Offset position = getRandomPositionBySize(size, 50);
        positionChild(i, position);
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;
}

Offset getRandomPositionBySize(Size size, int offset) {
  Rect rect = Rect.fromLTRB(
      0.0 + offset, 0.0 + offset, size.width - offset, size.height - offset);

  Random random = new Random();
  var offsetX = random.nextInt(rect.width.toInt()) + 1;
  var offsetY = random.nextInt(rect.height.toInt()) + 1;

  return new Offset(offsetX.toDouble(), offsetY.toDouble());
}
