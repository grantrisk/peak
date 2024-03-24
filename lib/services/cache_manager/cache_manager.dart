import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// CustomCacheManager is a singleton class designed to manage cache operations
/// such as caching data and retrieving cached data.
class CustomCacheManager {
  // The static _instance variable holds the single instance of the class.
  // It is initialized immediately and only once, using the private constructor _internal.
  static final CustomCacheManager _instance = CustomCacheManager._internal();

  // The factory constructor CustomCacheManager() checks if _instance is already created.
  // If so, it returns the same instance every time it's called, ensuring this class
  // can only have one instance throughout the application.
  factory CustomCacheManager() {
    return _instance;
  }

  // The private constructor _internal() is used to initialize the singleton instance.
  // Its privacy ensures that instance creation can only be controlled within the class itself,
  // preventing external instantiation.
  CustomCacheManager._internal();

  // _cacheManager is an instance of CacheManager from the flutter_cache_manager package,
  // configured with custom settings like cache key, stale period, and maximum number of cache objects.
  final _cacheManager = CacheManager(Config(
    'peakCacheKey', // Unique key for cache identification
    stalePeriod: const Duration(
        days: 1), // Time after which cached files are considered stale
    maxNrOfCacheObjects: 100, // Maximum number of objects the cache can hold
  ));

  /// Takes a key and data (as String), converts the data into bytes,
  /// and uses the _cacheManager to store these bytes in the cache.
  Future<void> cacheData(String key, String data) async {
    Uint8List bytes = utf8.encode(data); // Convert string to bytes
    await _cacheManager.putFile(
      key,
      bytes,
      eTag: DateTime.now()
          .toIso8601String(), // Use current time as ETag for cache validation
      fileExtension: "json",
    );
  }

  /// Attempts to retrieve cached data for a given key.
  /// If the data exists, it returns the data as a String. Otherwise, it returns null.
  Future<dynamic> getCachedData(String key) async {
    final fileInfo = await _cacheManager.getFileFromCache(key);
    if (fileInfo != null) {
      return fileInfo.file.readAsString(); // Read the file content as String
    }
    return null; // Return null if the file does not exist in cache
  }

  /// Deletes a cached file for a given key.
  deleteCache(String peakUserKey) {
    _cacheManager.removeFile(peakUserKey);
  }
}
