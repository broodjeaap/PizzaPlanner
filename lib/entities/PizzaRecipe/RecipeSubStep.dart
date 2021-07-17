import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/RecipeStep.dart';
import 'package:pizzaplanner/util.dart';

@Entity(
  tableName: "RecipeSubStep",
  foreignKeys: [
    ForeignKey(childColumns: ["recipeStepId"], parentColumns: ["id"], entity: RecipeStep)
  ]
)
class RecipeSubStep {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int recipeStepId;

  final String name;
  final String description;

  RecipeSubStep(this.recipeStepId, this.name, this.description, {this.id});

  Future<void> insert() async {
    final database = await getDatabase();
    final recipeSubStepDao = database.recipeSubStepDao;
    await recipeSubStepDao.insertRecipeSubStep(this);
  }
}