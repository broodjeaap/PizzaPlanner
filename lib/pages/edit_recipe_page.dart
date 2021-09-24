import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/edit_recipe_step_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class EditRecipePage extends StatefulWidget {
  static const String route = "/recipes/edit";
  late final PizzaRecipe? _pizzaRecipe;
  
  EditRecipePage({PizzaRecipe? pizzaRecipe}){
    _pizzaRecipe = pizzaRecipe; 
  }
  
  @override
  EditRecipePageState createState() => EditRecipePageState();
}

class EditRecipePageState extends State<EditRecipePage> {
  late PizzaRecipe pizzaRecipe;
  
  bool nameValidation = false;
  bool descriptionValidation = false;
  
  @override
  void initState() {
    super.initState();
    if (widget._pizzaRecipe == null){
      pizzaRecipe = PizzaRecipe(
        "",
        "",
        <Ingredient>[
          Ingredient("Flour", "g", 1.0)
        ],
        <RecipeStep>[
          RecipeStep("Step 1", "", "", "", 0, 1, <RecipeSubStep>[])
        ],
      );
    } else {
      pizzaRecipe = widget._pizzaRecipe!;
    }
    
  }

  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: const Text("Add Recipe"),
        resizeToAvoidBottomInset: true,
        body: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Recipe Name",
                  errorText: nameValidation ? """Name can't be empty""" : null
              ),
              initialValue: widget._pizzaRecipe?.name,
              onChanged: (String newName) {
                setState(() {
                  pizzaRecipe.name = newName;
                });
              },
            ),
            const Divider(),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Recipe Description",
                  errorText: descriptionValidation ? """Description can't be empty""" : null
              ),
              initialValue: widget._pizzaRecipe?.description,
              maxLines: 8,
              onChanged: (String newDescription) {
                setState(() {
                  pizzaRecipe.description = newDescription;
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
                                  return PreviewMarkdownDescription(pizzaRecipe.description);
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
            const Divider(),
            const Center(
                child: Text("Ingredients")
            ),
            const Divider(),
            Container(
                color: Colors.blue,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      pizzaRecipe.ingredients.add(
                          Ingredient("", "", 0.0)
                      );
                    });
                  },
                  child: const Text("Add Ingredient", style: TextStyle(color: Colors.white)),
                )
            ),
            const Divider(),
          ] + pizzaRecipe.ingredients.map((ingredient) => buildIngredientRow(ingredient)).toList() + [
            const Divider(),
            const Center(
                child: Text("Steps")
            ),
            Container(
                color: Colors.blue,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      pizzaRecipe.recipeSteps.add(
                          RecipeStep("Step ${pizzaRecipe.recipeSteps.length+1}", "", "", "minutes", 0, 1, <RecipeSubStep>[])
                      );
                    });
                  },
                  child: const Text("Add Step", style: TextStyle(color: Colors.white)),
                )
            ),
            const Divider()
          ] + pizzaRecipe.recipeSteps.map((recipeStep) => buildRecipeStepRow(recipeStep)).toList() + [
            const Divider(),
            Container(
                color: Colors.blue,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    showDialog(context: context, builder: (BuildContext context) {
                      return buildConfirmSaveDialog();
                    });
                  },
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                )
            )
          ],
        ),
    );
  }

  AlertDialog buildConfirmSaveDialog(){
    return AlertDialog(
        title: const Text("Save?"),
        content: const Text("Are you sure you want to save the Pizza Recipe?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              // Normalize ratios so they add up to 1
              final totalRatio = pizzaRecipe.ingredients.map<double>((ingredient) => ingredient.value).reduce((a, b) => a + b);
              for (final ingredient in pizzaRecipe.ingredients){
                ingredient.value = ingredient.value / totalRatio;
              }
              
              if (pizzaRecipe.isInBox){
                pizzaRecipe.save();
              } else {
                final pizzaRecipesBox = await Hive.openBox<PizzaRecipe>(PizzaRecipe.hiveName);
                pizzaRecipesBox.add(pizzaRecipe);
              }
              if (!mounted){
                return;
              }
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ]
    );
  }
  
  Widget buildIngredientRow(Ingredient ingredient){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 8,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "Name",
            ),
            initialValue: ingredient.name,
            onChanged: (String newName) {
              setState(() {
                ingredient.name = newName;
              });
            },
          ),
        ),
        Expanded(
          flex: 4,
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: "Value",
            ),
            keyboardType: TextInputType.number,
            initialValue: ingredient.value.toString(),
            onChanged: (String newValue) {
              setState(() {
                final newDouble = double.tryParse(newValue);
                if (newDouble == null){
                  return;
                }
                ingredient.value = newDouble;
              });
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(
                hintText: "Unit",
            ),
            initialValue: ingredient.unit,
            onChanged: (String newUnit) {
              setState(() {
                ingredient.unit = newUnit;
              });
            },
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              setState(() {
                pizzaRecipe.ingredients.remove(ingredient);
              });
            },
            child: const Text("X", style: TextStyle(color: Colors.red)),
          )
        )
      ]
    );
  }
  
  Widget buildRecipeStepRow(RecipeStep recipeStep){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Text(recipeStep.name)
        ),
        Expanded(
          flex: 4,
            child: Container(
              color: Colors.blue,
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, EditRecipeStepPage.route, arguments: recipeStep).then(
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
                pizzaRecipe.recipeSteps.remove(recipeStep);
              });
            },
            child: const Text("X", style: TextStyle(color: Colors.red)),
          )
        ),
      ],
    );
  }
}

class PreviewMarkdownDescription extends StatelessWidget {
  final String description;
  
  const PreviewMarkdownDescription(this.description);
  
  @override
  Widget build(BuildContext context){
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Markdown(
          data: description,
          onTapLink: (text, url, title) {
            launch(url!);
          }
        )
      )
    );
  }
}