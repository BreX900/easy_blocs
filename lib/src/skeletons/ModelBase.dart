

abstract class ModelBase {
  String get id;

  Map<String, dynamic> toJson();
  String toString() {
    final map = toJson();
    return "$runtimeType(${map.keys.map((key) {
      return "$key: ${map[key]}";
    }).join(", ")})";
  }
}