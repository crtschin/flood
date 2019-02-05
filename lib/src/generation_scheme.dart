import 'dart:mirrors';

import 'package:aqueduct/aqueduct.dart';
import 'dart:math';

typedef ValueGenerator = Object Function();

/// A generation scheme for [ManagedObject]s of the given [ManagedEntity].
///
/// Will contain a mapping of the generation functions to use for each
/// of the fields. Each generation function should not take any parameters and
/// should generate a value which is usable by the Aqueduct ORM.
class GenerationScheme {
  ManagedEntity entity;
  Map<String, ValueGenerator> generationPlan;
  Map<String, ManagedEntity> relations = Map();
  int numberToGenerate = 0;

  GenerationScheme(
    ManagedEntity this.entity,
    Map<String, ValueGenerator> this.generationPlan,
    int this.numberToGenerate,
  ) {
    for (MapEntry<String, ManagedRelationshipDescription> entry
        in entity.relationships.entries) {
      ManagedRelationshipDescription relation = entry.value;
      if (relation.isBelongsTo) {
        relations[entry.key] = relation.destinationEntity;
      }
    }
  }

  /// Fill an instance of the type represented by this scheme
  ///
  /// Requires [generated] to contain instances available for the relationships
  /// of this [ManagedEntity].
  fillObject(InstanceMirror objectMirror,
      Map<ManagedEntity, List<ManagedObject>> generated) {
    /// Set properties using the [ValueGenerator] for each field
    for (var entry in generationPlan.entries) {
      objectMirror.setField(Symbol(entry.key), entry.value());
    }

    /// Set the related object using the already generated [ManagedObjects]
    var random = Random();
    for (var entry in relations.entries) {
      var otherGenerated = generated[entry.value];
      var randomOther = random.nextInt(otherGenerated.length);
      objectMirror.setField(Symbol(entry.key), otherGenerated[randomOther]);
    }
  }
}
