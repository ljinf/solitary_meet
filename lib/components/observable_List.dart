import 'dart:collection';

import 'package:flutter/foundation.dart';

class ObservableList<T> extends ChangeNotifier {
  final List<T> _list = [];

  UnmodifiableListView<T> get list => UnmodifiableListView(_list);

  void add(T value) {
    _list.add(value);
    notifyListeners();
  }

  void addAll(List<T> value) {
    _list.addAll(value);
    notifyListeners();
  }

  T get(int index) {
    return _list[index];
  }

  int length() {
    return _list.length;
  }

  int indexWhere(bool Function(T) test, [int start = 0]) {
    return _list.indexWhere(test, start);
  }

  void remove(T value) {
    _list.remove(value);
    notifyListeners();
  }

  void insert(int index, T value) {
    _list.insert(index, value);
    notifyListeners();
  }

  T removeAt(int index) {
    final value = _list.removeAt(index);
    notifyListeners();
    return value;
  }

  void sort(int Function(T, T) f) {
    _list.sort(f);
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}
