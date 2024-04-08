
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SharedPrefs {
  static SharedPrefs? _singleton;
  static SharedPreferences? _sharedPreferences;
  static final Lock _lock = Lock();

  SharedPrefs._();

  static Future<SharedPrefs?> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          var singleton = SharedPrefs._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  Future _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool>? putObject(String key, Object value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setString(key, value == {} ? "" : json.encode(value));
  }

  static Map? getObject(String key) {
    if (_sharedPreferences == null) return null;
    String? data = _sharedPreferences!.getString(key);
    return (data == null || data.isEmpty) ? null : json.decode(data);
  }

  static T getObj<T>(String key, T Function(Map v) f, {required T defValue}) {
    Map? map = getObject(key);
    return map == null ? defValue : f(map);
  }

  static Future<bool>? putObjectList(String key, List<Object> list) {
    if (_sharedPreferences == null) return null;
    List<String>? dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _sharedPreferences!.setStringList(key, dataList);
  }

  static List<T> getObjList<T>(String key, T Function(Map v) f, {List<T> defValue = const []}) {
    List<Map>? dataList = getObjectList(key);
    List<T>? list = dataList?.map((value) {
      return f(value);
    }).toList();
    return list ?? defValue;
  }

  static List<Map>? getObjectList(String key) {
    if (_sharedPreferences == null) return null;
    List<String>? dataLis = _sharedPreferences!.getStringList(key);
    return dataLis?.map((value) {
      Map dataMap = json.decode(value);
      return dataMap;
    }).toList();
  }

  static String getString(String key, {String defValue = ''}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences!.getString(key) ?? defValue;
  }

  static Future<bool>? putString(String key, String? value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setString(key, value!);
  }

  static bool getBool(String key, {bool defValue = false}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences!.getBool(key) ?? defValue;
  }

  static Future<bool>? putBool(String key, bool value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setBool(key, value);
  }

  static int getInt(String key, {int defValue = 0}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences!.getInt(key) ?? defValue;
  }

  static Future<bool>? putInt(String key, int value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setInt(key, value);
  }

  static double getDouble(String key, {double defValue = 0.0}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences!.getDouble(key) ?? defValue;
  }

  static Future<bool>? putDouble(String key, double value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setDouble(key, value);
  }

  static List<String> getStringList(String key, {List<String> defValue = const []}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences!.getStringList(key) ?? defValue;
  }

  static Future<bool>? putStringList(String key, List<String> value) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setStringList(key, value);
  }

  static dynamic getDynamic(String key, {Object? defValue}) {
    if (_sharedPreferences == null) return defValue;
    return _sharedPreferences!.get(key) ?? defValue;
  }

  static dynamic putDynamic(String key, {Object? defValue}) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.setString(key, defValue == {} ? "" : json.encode(defValue));
  }

  static bool? haveKey(String key) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.getKeys().contains(key);
  }

  static Set<String>? getKeys() {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.getKeys();
  }

  static Future<bool>? remove(String key) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.remove(key);
  }

  static Future<bool>? clear() {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences!.clear();
  }

  static bool isInitialized() {
    return _sharedPreferences != null;
  }
}