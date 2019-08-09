
import 'package:flutter/cupertino.dart';

class Data2<Q, W> {
  final Q data1;
  final W data2;

  const Data2(this.data1, this.data2);
  
  bool get hasData => data1 != null && data2 != null;
  
  @override
  int get hashCode => hashValues(data1, data2);

  @override
  bool operator ==(other) {
    return other is Data2<Q, W> && other.data1 == data1 && other.data2 == data2;
  }

  @override
  String toString() => "(data1: $data1, data2: $data2)";
}

class Data3<Q, W, E> {
  final Q data1;
  final W data2;
  final E data3;

  const Data3(this.data1, this.data2, this.data3);
}

class Data4<Q, W, E, R> {
  final Q data1;
  final W data2;
  final E data3;
  final R data4;

  const Data4(this.data1, this.data2, this.data3, this.data4);
}

class Data5<Q, W, E, R, T> {
  final Q data1;
  final W data2;
  final E data3;
  final R data4;
  final T data5;

  const Data5(this.data1, this.data2, this.data3, this.data4, this.data5);
}