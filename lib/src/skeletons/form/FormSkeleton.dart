//import 'package:easy_blocs/src/skeletons/Skeleton.dart';
//import 'package:easy_blocs/src/skeletons/form/field/FieldBone.dart';
//import 'package:flutter/material.dart';
//import 'package:rxdart/rxdart.dart';
//
//
//class FormSkeleton extends Skeleton implements FormBone {
//  final GlobalKey<FormState> formKey;
//
//  final List<FieldBone> _fields = [];
//
//  final PublishSubject _eventController = PublishSubject();
//  Stream get outEvent => _eventController.stream;
//  void addEvent(event) => _eventController.add(event);
//
//  FormSkeleton({GlobalKey<FormState> formKey}) : this.formKey = formKey??GlobalKey<FormState>();
//
//  @override
//  void dispose() {
//    _eventController.close();
//    super.dispose();
//  }
//
//  void addField(FieldBone field) {
//    if (!_fields.contains(field)) {
//      _fields.add(field);
//    }
//  }
//  void removeField(FieldBone field) {
//    _fields.remove(field);
//  }
//
////  ValueChanged<String> onFieldSubmitted(BuildContext context, FieldBone field) {
////    return (String value) {
////      final indexNextManager = _fields.indexOf(field)+1;
////      final nextFocusNode = indexNextManager < _fields.length
////          ? _fields[indexNextManager].focusNode
////          : focusButton?.focusNode;
////
////      if (nextFocusNode != null)
////        Future.delayed(Duration(milliseconds: 300),
////                () => FocusScope.of(context).requestFocus(nextFocusNode));
////    };
////  }
//}
//
//
//abstract class FormBone extends Bone {
//  GlobalKey<FormState> get formKey;
//
//  Stream get outEvent;
//
//  void addField(FieldBone field);
//  void removeField(FieldBone field);
//
////  ValueChanged<String> onFieldSubmitted(BuildContext context, FieldBone field);
//}








