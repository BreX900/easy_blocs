import 'package:easy_blocs/src/checker/controllers/SubmitController.dart';
import 'package:easy_blocs/src/rxdart_cache/CacheStreamBuilder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


typedef Future<void> SubmitLogger(SubmitEvent event);


class SubmitButton extends StatelessWidget {
  final SubmitController controller;
  final SubmitLogger logger;
  final Widget child;

  SubmitButton({Key key,
    @required this.controller, this.logger,
    @required this.child,
  }) : assert(controller != null), super(key: key);

  @override
  Widget build(BuildContext _) {
    return CacheStreamBuilder<SubmitData>(
        stream: controller.outData,
        builder: (context, snap) {
          return RaisedButton(
            onPressed: snap.data.event == SubmitEvent.WAITING ? controller.onSubmit : null,
            child: child,
          );
        }
    );
  }
}


