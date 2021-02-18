// Copyright (c) 2015, Anders Holmgren. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:pubspec2/pubspec2.dart';

main() async {
  // specify the directory
  var myDirectory = new Directory('myDir');;

  // load pubSpec
  var pubSpec = await PubSpec.load(myDirectory);

  // change the dependencies to a single path dependency on project 'foo'
  var newPubSpec = pubSpec.copy(
      dependencies: { 'foo': new PathReference('../foo')});

  // save it
  await newPubSpec.save(myDirectory);
}