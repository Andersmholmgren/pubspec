import 'dart:io';

import 'package:pubspec/pubspec.dart';
import 'package:test/test.dart';

main() {
  test('external hosted dependency', () {
    var pubspecString = 'name: my_test_lib\n'
        'version: 0.1.0\n'
        'description: for testing\n'
        'dependencies:\n'
        '    meta: ^1.0.0\n'
        '    self_hosted_lib:\n'
        '        hosted:\n'
        '            name: custom_lib\n'
        '            url: https://pub.mycompany.org\n'
        '            version: ^0.1.0';
    var p = new PubSpec.fromYamlString(pubspecString);
    var dep = p.dependencies['self_hosted_lib']!;
    expect(dep, TypeMatcher<ExternalHostedReference>());

    var exDep = dep as ExternalHostedReference;
    expect(exDep.name, 'custom_lib');
    expect(exDep.url, 'https://pub.mycompany.org');
    expect(exDep.versionConstraint.toString(), '^0.1.0');
  });

  /// According to https://www.dartlang.org/tools/pub/dependencies#version-constraints:
  ///
  /// The string any allows any version. This is equivalent to an empty
  /// version constraint, but is more explicit.
  test('dependency without the version constraint is "any" version', () {
    var pubspecString = 'name: my_test_lib\n'
        'version: 0.1.0\n'
        'description: for testing\n'
        'dependencies:\n'
        '    meta:\n';
    var p = new PubSpec.fromYamlString(pubspecString);
    var dep = p.dependencies['meta']!;
    expect(dep, TypeMatcher<HostedReference>());

    var exDep = dep as HostedReference;
    expect(exDep.versionConstraint.toString(), 'any');
  });

  test('sdk dependency', () {
    var pubspecString = 'name: my_test_lib\n'
        'version: 0.1.0\n'
        'description: for testing\n'
        'dependencies:\n'
        '    flutter:\n'
        '        sdk: flutter\n';
    var p = new PubSpec.fromYamlString(pubspecString);
    var dep = p.dependencies['flutter']!;
    expect(dep, TypeMatcher<SdkReference>());

    var sdkDep = dep as SdkReference;
    expect(sdkDep.sdk, 'flutter');
  });

  test('load from file', () async {
    final fromDir = await PubSpec.load(Directory('.'));
    final fromFile = await PubSpec.loadFile('./pubspec.yaml');
    expect(fromFile.toJson(), equals(fromDir.toJson()));
  });

  group('git dependency', () {
    test('fromYamlString', () {
      final pubspecString = 'name: my_test_lib\n'
          'version: 0.1.0\n'
          'description: for testing\n'
          'dependencies:\n'
          '    meta: ^1.0.0\n'
          '    git_lib:\n'
          '        git:\n'
          '            url: git://github.com/foo/bar.git\n'
          '            ref: master\n'
          '            path: packages/batz';
      final pubspec = new PubSpec.fromYamlString(pubspecString);

      var dep = pubspec.dependencies['git_lib']!;
      expect(dep, TypeMatcher<GitReference>());

      var gitDep = dep as GitReference;
      expect(gitDep.url, 'git://github.com/foo/bar.git');
      expect(gitDep.ref, 'master');
      expect(gitDep.path, 'packages/batz');
    });

    test('toJson url', () {
      final subject = GitReference('git://github.com/foo/bar.git');

      var jsonObj = subject.toJson();

      expect(jsonObj['git'], 'git://github.com/foo/bar.git');
    });

    test('toJson url, ref', () {
      final subject = GitReference('git://github.com/foo/bar.git', 'master');

      var jsonObj = subject.toJson();

      expect(jsonObj['git']['url'], 'git://github.com/foo/bar.git');
      expect(jsonObj['git']['ref'], 'master');
    });

    test('toJson url, ref, path', () {
      final subject = GitReference(
        'git://github.com/foo/bar.git',
        'master',
        'packages/batz',
      );

      var jsonObj = subject.toJson();

      expect(jsonObj['git']['url'], 'git://github.com/foo/bar.git');
      expect(jsonObj['git']['ref'], 'master');
      expect(jsonObj['git']['path'], 'packages/batz');
    });
  });
}
