abstract class JsonRule {
  Map<String, dynamic> toJson();

  String toString() => toJson().toString();
}