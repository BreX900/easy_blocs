import 'package:easy_blocs/src/skeletons/form/field/FieldBone.dart';
import 'package:easy_blocs/src/skeletons/form/text/TextFieldSheet.dart';


abstract class TextFieldBone extends FieldBone<String, TextFieldSheet> {
  void inObscureText(bool isObscuredText);
}