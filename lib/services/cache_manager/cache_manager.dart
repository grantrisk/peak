import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static final CustomCacheManager _instance = CustomCacheManager._internal();

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._internal();

  final _cacheManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ));

  Future<void> cacheData(String key, String data) async {
    Uint8List bytes = utf8.encode(data); // Convert string to bytes
    await _cacheManager.putFile(
      key,
      bytes,
      eTag: DateTime.now().toIso8601String(),
      fileExtension: "json",
    );
  }

  Future<dynamic> getCachedData(String key) async {
    final fileInfo = await _cacheManager.getFileFromCache(key);
    if (fileInfo != null) {
      return fileInfo.file.readAsString();
    }
    return null;
  }
}
