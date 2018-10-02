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
    var dep = p.dependencies['self_hosted_lib'];
    expect(dep, const isInstanceOf<ExternalHostedReference>());

    var exDep = dep as ExternalHostedReference;
    expect(exDep.name, 'custom_lib');
    expect(exDep.url, 'https://pub.mycompany.org');
    expect(exDep.versionConstraint.toString(), '^0.1.0');
  });

  test('sdk dependency', () {
    var pubspecString = 'name: my_test_lib\n'
        'version: 0.1.0\n'
        'description: for testing\n'
        'dependencies:\n'
        '    flutter:\n'
        '        sdk: flutter\n';
    var p = new PubSpec.fromYamlString(pubspecString);
    var dep = p.dependencies['flutter'];
    expect(dep, const isInstanceOf<SdkReference>());

    var sdkDep = dep as SdkReference;
    expect(sdkDep.sdk, 'flutter');
  });
}