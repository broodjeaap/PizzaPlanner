import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeStepInstructionPageArguments {
  final PizzaEvent pizzaEvent;
  final RecipeStep recipeStep;

  RecipeStepInstructionPageArguments(this.pizzaEvent, this.recipeStep);
}

class RecipeStepInstructionPage extends StatefulWidget {
  static const String route = "/event/recipe_step";
  
  late final PizzaEvent pizzaEvent;
  late final RecipeStep recipeStep;

  RecipeStepInstructionPage(RecipeStepInstructionPageArguments arguments) {
    pizzaEvent = arguments.pizzaEvent;
    recipeStep = arguments.recipeStep;
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
    
    if (widget.recipeStep.subSteps.isNotEmpty) {
      currentSubStep = widget.recipeStep.subSteps.first;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var nextButtonText = "Start";
    if (page == widget.recipeStep.subSteps.length){ // -1 because of description page
      nextButtonText = "Finished";
    } else if (page > 0){
      nextButtonText = "Next step";
    }
    
    return PizzaPlannerScaffold(
        title: Text(widget.recipeStep.name),
        body: Column(
            children: <Widget>[
              Expanded(
                  flex: 90,
                  child: PageView(
                      controller: controller,
                      onPageChanged: (newPage) => setState(() {
                        page = newPage;
                        if (widget.recipeStep.subSteps.isNotEmpty && page != 0) {
                          currentSubStep = widget.recipeStep.subSteps.elementAt(newPage-1);
                        }
                      }),
                      children: <Widget>[
                        Markdown(
                          data: widget.recipeStep.description,
                          onTapLink: (text, url, title) {
                            launch(url!);
                          },
                        )
                      ] + widget.recipeStep.subSteps.map((subStep) {
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
                              color: Theme.of(context).buttonColor,
                              child: TextButton(
                                onPressed: () {
                                  if (page == 0){
                                    return;
                                  }
                                  if (currentSubStep != null){
                                    currentSubStep?.completedOn = null;
                                    widget.pizzaEvent.save();
                                  }
                                  controller.previousPage(duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                },
                                child: const Text("Back", style: TextStyle(color: Colors.white)),
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
                              color: Theme.of(context).buttonColor,
                              child: TextButton(
                                onPressed: () {
                                  if (page == widget.recipeStep.subSteps.length){
                                    widget.recipeStep.completeStepNow();
                                    widget.pizzaEvent.save();
                                    Navigator.pop(context);
                                    return;
                                  } else if (currentSubStep != null){
                                    currentSubStep?.completeNow();
                                    widget.pizzaEvent.save();
                                  }
                                  controller.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.ease);
                                },
                                child: Text(nextButtonText, style: const TextStyle(color: Colors.white)),
                              )
                          )
                      ),
                    ]
                ),
              )
            ]
        ),
    );
  }
}