import 'dart:async';

import 'package:flutter/material.dart';


class RememberMeField extends StatelessWidget {
  final RememberMeController controller;
  final MaterialTapTargetSize materialTapTargetSize;

  const RememberMeField({Key key, @required this.controller, this.materialTapTargetSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: controller.outRememberMe,
      builder: (context, snap) {

        return Switch(
          value: snap.data,
          onChanged: controller.inRememberMe,
          materialTapTargetSize: materialTapTargetSize,
        );
      },
    );
  }
}


abstract class RememberMeController {
  Stream<bool> get outRememberMe;
  Future<void> inRememberMe(bool isRememberMe);
}