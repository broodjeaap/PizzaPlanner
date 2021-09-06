import 'package:flutter/material.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/edit_recipe_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class EditRecipeSubStepPage extends StatefulWidget {
  final RecipeSubStep subStep;
  
  const EditRecipeSubStepPage(this.subStep);
  
  @override
  EditRecipeSubStepPageState createState() => EditRecipeSubStepPageState();
}

class EditRecipeSubStepPageState extends State<EditRecipeSubStepPage> {
  
  bool nameValidation = false;
  bool descriptionValidation = false;
  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: Text("Edit: ${widget.subStep.name}"),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Recipe Name",
                  errorText: nameValidation ? """Name can't be empty""" : null
              ),
              initialValue: widget.subStep.name,
              onChanged: (String newName) {
                setState(() {
                  widget.subStep.name = newName;
                });
              },
            ),
            const Divider(),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Recipe Description",
                  errorText: descriptionValidation ? """Description can't be empty""" : null
              ),
              initialValue: widget.subStep.description,
              maxLines: 12,
              onChanged: (String newDescription) {
                setState(() {
                  widget.subStep.description = newDescription;
                });
              },
            ),
            const Divider(),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                        color: Colors.blue,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return PreviewMarkdownDescription(widget.subStep.description);
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
                        color: Colors.blue,
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
          ],
        )
    );
  }
}