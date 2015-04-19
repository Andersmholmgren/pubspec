// Copyright (c) 2015, Anders Holmgren. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library util.json;

import 'package:path/path.dart' as path;
import 'package:option/option.dart';

final _p = path.url;

abstract class Jsonable {
  toJson();
}

JsonBuilder get buildJson => new JsonBuilder();
JsonParser parseJson(Map j, {bool consumeMap: false}) =>
    new JsonParser(j, consumeMap);

class JsonBuilder {
  final Map json = {};

  void addOption(String fieldName, Option o) {
    o.map((v) => v.toJson()).map((j) {
      json[fieldName] = j;
    });
  }

  void addObject(String fieldName, o) {
    if (o != null) {
      json[fieldName] = o.toJson();
    }
  }

  void add(String fieldName, v) {
    if (v != null) {
      json[fieldName] = _transformValue(v);
    }
  }

  void addAll(Map map) {
    json.addAll(map);
  }

  _transformValue(value, [transform(v)]) {
    if (transform != null) {
      return transform(value);
    }
    if (value is Jsonable) {
      return value.toJson();
    }
    if (value is Map) {
      final result = {};
      (value as Map).forEach((k, v) {
        result[k] = _transformValue(v, null);
      });
      return result;
    }
    if (value is Iterable) {
      return (value as Iterable).map((v) => _transformValue(v, null)).toList();
    }
    return value.toString();
  }
}

_identity(v) => v;

class JsonParser {
  final Map _json;
  final bool _consumeMap;

  JsonParser(Map json, bool consumeMap)
      : this._json = consumeMap ? new Map.from(json) : json,
        this._consumeMap = consumeMap;

  List list(String fieldName, [create(i) = _identity]) {
    final List l = _getField(fieldName);
    return l != null ? l.map(create).toList(growable: false) : [];
  }

  single(String fieldName, [create(i) = _identity]) {
    final j = _getField(fieldName);
    return j != null ? create(j) : null;
  }

  Map mapValues(String fieldName, [create(i) = _identity]) {
    final Map m = _getField(fieldName);

    if (m == null) {
      return {};
    }

    Map result = {};
    m.forEach((k, v) {
      result[k] = create(v);
    });

    return result;
  }

  _getField(String fieldName) =>
      _consumeMap ? _json.remove(fieldName) : _json[fieldName];

  Map get unconsumed {
    if (!_consumeMap) {
      throw new StateError('unconsumed called on non consuming parser');
    }

    return _json;
  }
}
