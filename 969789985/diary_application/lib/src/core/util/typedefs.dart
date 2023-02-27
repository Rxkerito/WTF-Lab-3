import 'dart:io';

import 'package:flutter/material.dart';

import '../domain/models/local/tag/tag_model.dart';

typedef FId = String;

typedef Callback = void Function();

typedef FileFromFuture = Future<File> Function(String filename);
typedef TagFromFirebase = TagModel Function(FId);

