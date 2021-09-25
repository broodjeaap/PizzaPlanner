import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/edit_recipe_page.dart';
import 'package:pizzaplanner/pages/edit_recipe_sub_step_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class EditRecipeStepPage extends StatefulWidget {
  static const String route = "/recipes/add/edit_step";
  final RecipeStep recipeStep;
  
  const EditRecipeStepPage(this.recipeStep);
  
  @override
  EditRecipeStepPageState createState() => EditRecipeStepPageState();
}

class EditRecipeStepPageState extends State<EditRecipeStepPage> {
  
  bool nameValidation = false;
  bool descriptionValidation = false;
  
  final waitUnits = ["minutes", "hours","days"].map<DropdownMenuItem<String>>((String unit) =>
      DropdownMenuItem<String>(
          value: unit,
          child: Text(unit)
      )
  ).toList();
  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
      title: Text("Edit: ${widget.recipeStep.name}"),
      body: ListView(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                hintText: "Recipe Name",
                errorText: nameValidation ? """Name can't be empty""" : null
            ),
            initialValue: widget.recipeStep.name,
            onChanged: (String newName) {
              setState(() {
                widget.recipeStep.name = newName;
              });
            },
          ),
          const Divider(),
          TextFormField(
            decoration: InputDecoration(
                hintText: "Recipe Description",
                errorText: descriptionValidation ? """Description can't be empty""" : null
            ),
            initialValue: widget.recipeStep.description,
            maxLines: 8,
            onChanged: (String newDescription) {
              setState(() {
                widget.recipeStep.description = newDescription;
              });
            },
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      color: Theme.of(context).buttonColor,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return PreviewMarkdownDescription(widget.recipeStep.description);
                              }
                          );
                        },
                        child: const Text("Preview", style: TextStyle(color: Colors.white)),
                      )
                  )
              ),
              const Expanded(
                  child: SizedBox()
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                      color: Theme.of(context).buttonColor,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          launch("https://guides.github.com/features/mastering-markdown/");
                        },
                        child: const Text("Markdown?", style: TextStyle(color: Colors.white)),
                      )
                  )
              )
            ],
          ),
          const Divider(),
          const Center(child: Text("Next step after:")),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Min",
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: widget.recipeStep.waitMin.toString(),
                  onChanged: (String newMin) {
                    setState(() {
                      widget.recipeStep.waitMin = int.tryParse(newMin) ?? 0;
                    });
                  },
                ),
              ),
              const Expanded(
                flex: 2,
                child: Center(child: Text("To")),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Max",
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: widget.recipeStep.waitMax.toString(),
                  onChanged: (String newMax) {
                    setState(() {
                      widget.recipeStep.waitMax = int.tryParse(newMax) ?? 0;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: DropdownButton<String>(
                  value: widget.recipeStep.waitUnit.isEmpty ? waitUnits.first.value : widget.recipeStep.waitUnit.toLowerCase(),
                  items: waitUnits,
                  onChanged: (String? newUnit){
                    if (newUnit == null){
                      return;
                    }
                    setState(() {
                      widget.recipeStep.waitUnit = newUnit;
                    });
                  },
                )
              ),
            ],
          ),
          const Divider(),
          const Center(child: Text("Sub Steps")),
          Container(
              color: Theme.of(context).buttonColor,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    widget.recipeStep.subSteps.add(
                        RecipeSubStep("Sub step ${widget.recipeStep.subSteps.length+1}", "")
                    );
                  });
                },
                child: const Text("Add Sub Step", style: TextStyle(color: Colors.white)),
              )
          ),
          const Divider()
        ] + widget.recipeStep.subSteps.map((subStep) => buildSubStepRow(subStep)).toList()
      )
    );
  }
  
  Widget buildSubStepRow(RecipeSubStep subStep){
    return Row(
      children: <Widget>[
        Expanded(
            flex: 10,
            child: Text(subStep.name)
        ),
        Expanded(
            flex: 4,
            child: Container(
                color: Theme.of(context).buttonColor,
                child: TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pushNamed(context, EditRecipeSubStepPage.route, arguments: subStep).then(
                            (_) {
                          setState((){});
                        }
                    );
                  },
                  child: const Text("Edit", style: TextStyle(color: Colors.white)),
                )
            )
        ),
        Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.recipeStep.subSteps.remove(subStep);
                });
              },
              child: const Text("X", style: TextStyle(color: Colors.red)),
            )
        ),
      ],
    );
  }
}