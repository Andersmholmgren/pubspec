import 'package:pubspec2/pubspec2.dart';
import 'package:test/test.dart';

main() {
  test('executables ', () {
    var pubspecString = '''name: my_test_lib
version: 0.1.0
description: for testing
dependencies:
  meta: ^1.0.0

executables:
  polymer-new-element: new_element
  useful-script:
  dcli_install: dcliinstall
''';
    var p = new PubSpec.fromYamlString(pubspecString);
    var exec = p.executables['dcli_install']!;
    expect(exec, TypeMatcher<Executable>());
    //expect(exec.name, equals('dcli_install'));
    expect(exec.script, equals('dcliinstall'));

    exec = p.executables['polymer-new-element']!;
    expect(exec, TypeMatcher<Executable>());
    //expect(exec.name, equals('polymer-new-element'));
    expect(exec.script, equals('new_element'));

    exec = p.executables['useful-script']!;
    expect(exec, TypeMatcher<Executable>());
    // expect(exec.name, equals('useful-script'));
    expect(exec.script, isNull);

    expect(
        p.executables.keys,
        unorderedEquals(
            ['polymer-new-element', 'useful-script', 'dcli_install']));
  });
}
