import 'dart:collection';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class CacheManager extends BaseCacheManager {
  final String cacheKey;
  static HashMap<String, CacheManager> _instances = HashMap();

  CacheManager({
    @required this.cacheKey,
    Duration maxAgeCacheObject = const Duration(days: 30),
    int maxNrOfCacheObjects = 200,
    FileFetcher fileFetcher,
  }) : assert(cacheKey != null), super(cacheKey,
    maxAgeCacheObject: maxAgeCacheObject,
    maxNrOfCacheObjects: maxNrOfCacheObjects,
    fileFetcher: fileFetcher,
  );

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, cacheKey);
  }


  factory CacheManager.favorite({
    Duration maxAgeCacheObject = const Duration(days: 30), int maxNrOfCacheObjects = 50,
  }) {
    return CacheManager.cacheKey("CacheManager#Favorite", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  @deprecated
  factory CacheManager.infinity({
    Duration maxAgeCacheObject = const Duration(days: 30), int maxNrOfCacheObjects = 200,
  }) {
    return CacheManager.cacheKey("CacheManager#Infinity", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  factory CacheManager.month({
    Duration maxAgeCacheObject = const Duration(days: 30), int maxNrOfCacheObjects = 256,
  }) {
    return CacheManager.cacheKey("CacheManager#Mont", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }
  factory CacheManager.monthTwo({
    Duration maxAgeCacheObject = const Duration(days: 30), int maxNrOfCacheObjects = 128,
  }) {
    return CacheManager.cacheKey("CacheManager#MontTwo", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }
  factory CacheManager.monthThree({
    Duration maxAgeCacheObject = const Duration(days: 30), int maxNrOfCacheObjects = 64,
  }) {
    return CacheManager.cacheKey("CacheManager#MontThree", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  factory CacheManager.week({
    Duration maxAgeCacheObject = const Duration(days: 7), int maxNrOfCacheObjects = 100,
  }) {
    return CacheManager.cacheKey("CacheManager#Week", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  factory CacheManager.twoDay({
    Duration maxAgeCacheObject = const Duration(days: 2), int maxNrOfCacheObjects = 200,
  }) {
    return CacheManager.cacheKey("CacheManager#TwoDay", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  factory CacheManager.day({
    Duration maxAgeCacheObject = const Duration(days: 1), int maxNrOfCacheObjects = 200,
  }) {
    return CacheManager.cacheKey("CacheManager#day", (cacheKey) => CacheManager(
      cacheKey: cacheKey,
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  factory CacheManager.cacheKey(String cacheKey, CacheManager builder(String cacheKey)) {

    if (!_instances.containsKey(cacheKey))
      _instances[cacheKey] = builder(cacheKey);

    return _instances[cacheKey];
  }
}