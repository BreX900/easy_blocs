
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

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
  String toString() => "Data2(data1: $data1, data2: $data2)";

  static Data2<Q, W> combiner<Q, W>(Q data1, W data2) => Data2(data1, data2);
  static ValueObservable<Data2<Q, W>> combineLatest<Q, W>(Stream<Q> stream1, Stream<W> stream2) {
    return Observable.combineLatest2<Q, W, Data2<Q, W>>(stream1, stream2, combiner).shareValueSeeded(Data2(
      stream1 is ValueObservable<Q> ? stream1.value : null,
      stream2 is ValueObservable<W> ? stream2.value : null,
    ));
  }
}

class Data3<Q, W, E> {
  final Q data1;
  final W data2;
  final E data3;

  const Data3(this.data1, this.data2, this.data3);

  bool get hasData => data1 != null && data2 != null;

  @override
  int get hashCode => hashValues(data1, data2);

  @override
  bool operator ==(other) {
    return other is Data3<Q, W, E> && other.data1 == data1 && other.data2 == data2 && data3 == other.data3;
  }

  @override
  String toString() => "Data3(data1: $data1, data2: $data2, data3: $data3)";

  static Data3<Q, W, E> combiner<Q, W, E>(Q data1, W data2, E data3) => Data3(data1, data2, data3);
  static ValueObservable<Data3<Q, W, E>> combineLatest<Q, W, E>(
      Stream<Q> stream1, Stream<W> stream2, Stream<E> stream3,
      ) {
    return Observable.combineLatest3<Q, W, E, Data3<Q, W, E>>(stream1, stream2, stream3, combiner).shareValueSeeded(Data3(
      stream1 is ValueObservable<Q> ? stream1.value : null,
      stream2 is ValueObservable<W> ? stream2.value : null,
      stream3 is ValueObservable<E> ? stream3.value : null,
    ));
  }
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