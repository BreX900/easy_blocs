


import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:rxdart/rxdart.dart';

class CacheRepository {
  final HashMap<Type, dynamic> _cache = HashMap();




}



class Cl {
  PublishSubject<ModelBase> _subject = PublishSubject();
  Stream<ModelBase> get outModel => _subject;
}