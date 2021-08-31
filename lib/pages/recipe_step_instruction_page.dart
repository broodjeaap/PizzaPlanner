import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeStepInstructionPageArguments {
  final PizzaEvent pizzaEvent;
  final RecipeStep recipeStep;

  RecipeStepInstructionPageArguments(this.pizzaEvent, this.recipeStep);
}

class RecipeStepInstructionPage extends StatefulWidget {
  late final PizzaEvent pizzaEvent;
  late final RecipeStep recipeStep;

  RecipeStepInstructionPage(RecipeStepInstructionPageArguments arguments) {
    this.pizzaEvent = arguments.pizzaEvent;
    this.recipeStep = arguments.recipeStep;
  }


  @override
  RecipeStepInstructionState createState() => RecipeStepInstructionState();
}

class RecipeStepInstructionState extends State<RecipeStepInstructionPage> {
  final PageController controller = PageController();
  int page = 0;
  RecipeSubStep? currentSubStep;
  
  @override
  void initState() {
    super.initState();
    
    if (this.widget.recipeStep.subSteps.isNotEmpty) {
      this.currentSubStep = this.widget.recipeStep.subSteps.first;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var nextButtonText = "Start";
    if (this.page == this.widget.recipeStep.subSteps.length){ // -1 because of description page
      nextButtonText = "Finished";
    } else if (this.page > 0){
      nextButtonText = "Next step";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.recipeStep.name),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(16),
        child:  Column(
            children: <Widget>[
              Expanded(
                flex: 90,
                child: PageView(
                    controller: this.controller,
                    onPageChanged: (newPage) => setState(() {
                      this.page = newPage;
                      if (this.widget.recipeStep.subSteps.isNotEmpty && this.page != 0) {
                        this.currentSubStep = this.widget.recipeStep.subSteps.elementAt(newPage-1);
                      }
                    }),
                    children: <Widget>[
                      Markdown(
                        data: this.widget.recipeStep.description,
                        onTapLink: (text, url, title) {
                          launch(url!);
                        },
                      )
                    ] + this.widget.recipeStep.subSteps.map((subStep) {
                      return Markdown(
                        data: subStep.description,
                        onTapLink: (text, url, title) {
                          launch(url!);
                        },
                      );
                    }).toList()
                )
              ),
              Expanded(
                flex: 10,
                child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 15,
                          child: Container(
                              width: double.infinity,
                              color: Colors.blue,
                              child: TextButton(
                                child: Text("Back", style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  if (page == 0){
                                    return;
                                  }
                                  if (this.currentSubStep != null){
                                    this.currentSubStep?.completedOn = null;
                                    this.widget.pizzaEvent.save();
                                  }
                                  this.controller.previousPage(duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                },
                              )
                          )
                      ),
                      Expanded(
                          flex: 5,
                          child: Container() 
                      ),
                      Expanded(
                          flex: 35,
                          child: Container(
                              width: double.infinity,
                              color: Colors.blue,
                              child: TextButton(
                                child: Text(nextButtonText, style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  if (this.page == this.widget.recipeStep.subSteps.length){
                                    this.widget.recipeStep.completeStepNow();
                                    this.widget.pizzaEvent.save();
                                    Navigator.pop(context);
                                    return;
                                  } else if (this.currentSubStep != null){
                                    this.currentSubStep?.completeNow();
                                    this.widget.pizzaEvent.save();
                                  }
                                  this.controller.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                },
                              )
                          )
                      ),
                    ]
                ),
              )
            ]
        )
      )
    );
  }
}