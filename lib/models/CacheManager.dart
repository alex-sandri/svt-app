import 'package:hive/hive.dart';

class CacheManager
{
  static Box _box;

  static dynamic get(String key) => _box.get(key);

  static Future<void> set(String key, dynamic value) => _box.put(key, value);

  static Future<void> delete(String key) => _box.delete(key);

  static Future<void> empty() async {
    await _box.deleteFromDisk();

    await CacheManager.init();
  }

  static Future<void> init() async => _box = await Hive.openBox("cache-v1");
}