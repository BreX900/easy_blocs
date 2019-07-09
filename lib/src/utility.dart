import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:flutter/material.dart';

typedef V ValueGetterByObject<O, V>(O object);

InputDecoration inputDecorationWithHintText(
    InputDecoration decoration, InputDecoration defaultDecoration, Translations hintText,
) {
  if (decoration != null)
    return decoration;
  return decoration.copyWith(
    prefixIcon: decoration.prefixIcon??defaultDecoration.prefixIcon,
    hintText: decoration.hintText??hintText?.text,
  );
}