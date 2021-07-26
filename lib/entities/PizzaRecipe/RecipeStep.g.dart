// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecipeStep.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeStepAdapter extends TypeAdapter<RecipeStep> {
  @override
  final int typeId = 2;

  @override
  RecipeStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeStep(
      fields[0] as String,
      fields[6] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
      (fields[7] as List).cast<RecipeSubStep>(),
    )..waitValue = fields[5] as int?;
  }

  @override
  void write(BinaryWriter writer, RecipeStep obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.waitDescription)
      ..writeByte(2)
      ..write(obj.waitUnit)
      ..writeByte(3)
      ..write(obj.waitMin)
      ..writeByte(4)
      ..write(obj.waitMax)
      ..writeByte(5)
      ..write(obj.waitValue)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.subSteps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
