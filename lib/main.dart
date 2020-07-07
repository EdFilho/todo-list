import 'package:flutter/material.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/themes/app_theme.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Todo List',
      home: HomePage(),
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
    )
  );
}