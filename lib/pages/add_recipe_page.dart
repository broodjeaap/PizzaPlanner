import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive/hive.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/ingredient.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_step.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/recipe_substep.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class AddRecipePage extends StatefulWidget {
  final PizzaRecipe? pizzaRecipe;
  
  const AddRecipePage({this.pizzaRecipe});
  
  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage> {
  late PizzaRecipe pizzaRecipe;
  
  bool nameValidation = false;
  bool descriptionValidation = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.pizzaRecipe == null){
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
      pizzaRecipe = widget.pizzaRecipe!;
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
              initialValue: widget.pizzaRecipe?.name,
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
              initialValue: widget.pizzaRecipe?.description,
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
                    if (pizzaRecipe.isInBox){
                      pizzaRecipe.save();
                    } else {
                      final pizzaRecipesBox = await Hive.openBox<PizzaRecipe>("PizzaRecipes");
                      pizzaRecipesBox.add(pizzaRecipe);
                    }
                  },
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                )
            )
          ],
        ),
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
                  Navigator.pushNamed(context, "/recipes/add/edit_step", arguments: recipeStep).then(
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