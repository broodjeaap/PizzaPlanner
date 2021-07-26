// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PizzaRecipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PizzaRecipeAdapter extends TypeAdapter<PizzaRecipe> {
  @override
  final int typeId = 0;

  @override
  PizzaRecipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PizzaRecipe(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List).cast<Ingredient>(),
      (fields[3] as List).cast<RecipeStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, PizzaRecipe obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.ingredients)
      ..writeByte(3)
      ..write(obj.recipeSteps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PizzaRecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
