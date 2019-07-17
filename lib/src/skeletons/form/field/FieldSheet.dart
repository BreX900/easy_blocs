class FieldSheet<V> {
  final V value;

  const FieldSheet({this.value});

  FieldSheet<V> copyWith({
    V value,
  }) {
    return FieldSheet(
      value: value??this.value,
    );
  }
}