import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:flutter/material.dart';

InputDecoration mergeInputDecoration(InputDecoration decoration, InputDecoration defaultDecoration,
    bool loadDefaultDecoration, {
      Translations hintText,
    }) {
  if (loadDefaultDecoration == false)
    return decoration;
  return decoration.copyWith(
    prefixIcon: decoration.prefixIcon??defaultDecoration.prefixIcon,
    hintText: decoration.hintText??hintText?.text,
  );
}