import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/controllers/FocusHandler.dart';
import 'package:easy_blocs/src/checker/controllers/FormHandler.dart';
import 'package:easy_blocs/src/checker/controllers/MixinFormHandler.dart';
import 'package:easy_blocs/src/checker/controllers/MixinHand.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


typedef void GetterFocusManager(BuildContext context);


class SubmitBloc with MixinHand, MixinFormHandler implements Bloc {
  final Hand hand;
  final FormHandler formHandler;

  @override @mustCallSuper
  void dispose() {
    hand.dispose();
    formHandler.dispose();
  }

  SubmitBloc({
    bool state: true, Hand hand, FormHandler formHandler
  }) : assert(state != null),
        this.hand = hand??Hand(), this.formHandler = formHandler??FormHandler();
}

