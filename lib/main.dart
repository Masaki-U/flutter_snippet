import 'package:flutter/material.dart';
import 'package:flutter_snippet/example.dart';
import 'package:flutter_snippet/state_management/async/result.dart';

void main() {
  Result.success(345)
      .map((value) async => "dsfdg$value")
      .map((value) async => "dsfdg$value");
  runApp(const MyApp());
}
