import 'package:flutter/material.dart';
import 'package:pizzaplanner/pages/nav_drawer.dart';

class PizzaPlannerScaffold extends StatelessWidget {
  late final Widget _body;
  late final Widget _appBarTitle;
  late final bool _resizeToAvoidBottomInset;
  late final EdgeInsets _edgeInsets;
  late final FloatingActionButton? _floatingActionButton;
  PizzaPlannerScaffold({
    required Widget body,
    required Widget title,
    bool resizeToAvoidBottomInset = false,
        EdgeInsets edgeInsets = const EdgeInsets.all(16),
        FloatingActionButton? floatingActionButton 
      }){
    _body = body;
    _appBarTitle = title;
    _resizeToAvoidBottomInset = resizeToAvoidBottomInset;
    _edgeInsets = edgeInsets;
    _floatingActionButton = floatingActionButton;
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        padding: _edgeInsets,
        child: _body
      ),
      appBar: AppBar(
        title: _appBarTitle,
      ), 
      resizeToAvoidBottomInset: _resizeToAvoidBottomInset,
      drawer: NavDrawer(),
      floatingActionButton: _floatingActionButton,
    );
  }
}