# 0.1.4
Added support for 'executables' map in the pubspec.
Exported Executable.

# Changelog
## 0.1.3
Demoved the dependency on the stuff package has it had a dependency on mirrors. The result is that you couldn't do a native compile of any package dependent on pubspec. Copied the class Json_utils.dart from stuff package to make this possible.

## 0.1.1

- load from file
- replace deprecated isInstanceOf

## 0.1.0

- Dart 2

## 0.0.11

- additional constructor

## 0.0.10

- tidied a few things

## 0.0.9

- Bug Fix. publish_to was serialising to publishTo

## 0.0.8

- upgraded some dependencies

## 0.0.7

- add publish_to

## 0.0.6

- tidy dependencies

## 0.0.3

- Added property `allDependencies` which combines `dependencies` with
  `devDependencies`

## 0.0.2

- Added == and hashCode to dependency reference classes

## 0.0.1

- Initial version, created by Stagehand
