import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/pages/scaffold.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const String route = "/privacy_policy";
  
  static const String privacyPolicy = """
## PizzaPlanner: Privacy policy

Welcome to the Pizza Planner app for Android!

This is an open source Android app developed by me. The source code is available on my Gitea repository under the MIT license; the app is also available on Google Play.

I know how irritating it is when apps collect your data without your knowledge.

I have not programmed this app to collect any personally identifiable information. All data (app preferences (like theme, etc.) and alarms) created by the you is stored on your device only, and can be simply erased by clearing the app's data or uninstalling it.

If you find any security vulnerability that has been inadvertently caused by me, or have any question regarding how the app protects your privacy, please send me an email and I will surely try to fix it/help you.

Yours sincerely,  
David    
david@broodjeaap.net  
https://gitea.broodjeaap.net/broodjeaap/PizzaPlanner
""";
  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
      title: const Text("Pick Recipe"),
      body: const Markdown(data: privacyPolicy)
    );
  }
}