import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';


class SubmitButton extends StatelessWidget {
  final SubmitController bloc;
  final Widget child;

  SubmitButton({Key key,
    @required this.child, @required this.bloc,
  }) : assert(bloc != null), super(key: key);

  @override
  Widget build(BuildContext _) {
    return CacheStreamBuilder<bool>(
        stream: bloc.outSubmit,
        builder: (context, snap) {

          return RaisedButton(
            onPressed: snap.data ? bloc.submit : null,
            child: child,
          );
        }
    );
  }
}


abstract class SubmitController {
  Stream<bool> get outSubmit;
  Future<void> submit();
}