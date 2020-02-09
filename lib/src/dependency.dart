// Copyright (c) 2015, Anders Holmgren. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library pubspec.dependency;

import 'dart:convert';

import 'package:pub_semver/pub_semver.dart';

import 'json_utils.dart';

abstract class DependencyReference extends Jsonable {
  DependencyReference();

  factory DependencyReference.fromJson(json) {
    if (json is Map) {
      if (json.length != 1) {
        throw new StateError('expecting only one entry for dependency');
      }
      switch (json.keys.first as String) {
        case 'path':
          return new PathReference.fromJson(json);
        case 'git':
          return new GitReference.fromJson(json);
        case 'hosted':
          return new ExternalHostedReference.fromJson(json);
        case 'sdk':
          return new SdkReference.fromJson(json);
        default:
          throw new StateError('unexpected dependency type ${json.keys.first}');
      }
    } else if (json is String) {
      return new HostedReference.fromJson(json);
    } else if (json == null) {
      return new HostedReference(VersionConstraint.any);
    } else {
      throw new StateError('Unable to parse dependency $json');
    }
  }

  String toString() => json.encode(this);
}

class GitReference extends DependencyReference {
  final String url;
  final String ref;
  final String path;

  GitReference(this.url, [this.ref, this.path]);

  factory GitReference.fromJson(Map json) {
    final git = json['git'];
    if (git is String) {
      return new GitReference(git, null);
    } else if (git is Map) {
      Map m = git;
      return new GitReference(m['url'], m['ref'], m['path']);
    } else {
      throw new StateError('Unexpected format for git dependency $git');
    }
  }

  @override
  Map toJson() {
    if (ref == null && path == null) {
      return {'git': url.toString()};
    }

    var arguments = {'url': url.toString()};

    if (ref != null) arguments['ref'] = ref;
    if (path != null) arguments['path'] = path;

    return {'git': arguments};
  }

  bool operator ==(other) =>
      other is GitReference && other.url == url && other.ref == ref;

  int get hashCode => ref.hashCode;
}

class PathReference extends DependencyReference {
  final String path;

  PathReference(this.path);

  PathReference.fromJson(Map json) : this(json['path']);

  @override
  Map toJson() => {'path': path};

  bool operator ==(other) => other is PathReference && other.path == path;

  int get hashCode => path.hashCode;
}

class HostedReference extends DependencyReference {
  final VersionConstraint versionConstraint;

  HostedReference(this.versionConstraint);

  HostedReference.fromJson(String json)
      : this(new VersionConstraint.parse(json));

  @override
  String toJson() => "${versionConstraint.toString()}";

  bool operator ==(other) =>
      other is HostedReference && other.versionConstraint == versionConstraint;

  int get hashCode => versionConstraint.hashCode;
}

class ExternalHostedReference extends DependencyReference {
  final String name, url;
  final VersionConstraint versionConstraint;

  ExternalHostedReference(this.name, this.url, this.versionConstraint);

  ExternalHostedReference.fromJson(Map json)
      : this(json['hosted']['name'], json['hosted']['url'],
            new VersionConstraint.parse(json['hosted']['version']));

  bool operator ==(other) =>
      other is ExternalHostedReference &&
      other.name == name &&
      other.url == url &&
      other.versionConstraint == versionConstraint;

  @override
  toJson() {
    return {'name': name, 'url': url, 'version': versionConstraint.toString()};
  }
}

class SdkReference extends DependencyReference {
  final String sdk;

  SdkReference(this.sdk);

  SdkReference.fromJson(Map json) : this(json['sdk']);

  bool operator ==(other) => other is SdkReference && other.sdk == sdk;

  @override
  toJson() {
    return {'sdk': sdk};
  }
}
