// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecipeSubStep.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeSubStepAdapter extends TypeAdapter<RecipeSubStep> {
  @override
  final int typeId = 3;

  @override
  RecipeSubStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeSubStep(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeSubStep obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeSubStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
