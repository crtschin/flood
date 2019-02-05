import 'dart:mirrors';

import 'package:aqueduct/aqueduct.dart';
import 'package:flood/src/generation_scheme.dart';

/// Will create the actual queries ran
///
/// Contains an internal [registry] of all objects generated using this
/// instance. Because the [registry] is used to establish the relationships
/// between tables, either the same instance needs to be used when generating
/// objects for the same environment, or the [registry] needs to be passed on.
class QueryCreator {
  Map<ManagedEntity, List<ManagedObject>> registry;

  QueryCreator({
    Map<ManagedEntity, List<ManagedObject>> generated,
  }) {
    if (generated == null)
      this.registry = Map();
    else
      this.registry = generated;
  }

  /// Generate all of the objects in the given [order].
  ///
  /// Returns the current state of the internal [registry], which is updated
  /// using the generated objects.
  Future<Map<ManagedEntity, List<ManagedObject>>> create(
      ManagedContext context, Iterable<GenerationScheme> order) async {
    // Generate the objects for each of the generation schemes
    for (var scheme in order) {
      if (!this.registry.containsKey(scheme.entity)) {
        this.registry[scheme.entity] = [];
      }
      this.registry[scheme.entity].addAll(await Future.wait(
          generateObjects(context, scheme, scheme.numberToGenerate)));
    }
    return this.registry;
  }

  /// Generates a single [ManagedObject] using the given [scheme]
  ///
  /// The information of how the [ManagedObject]'s values should be filled,
  /// is implemented in [GenerationScheme.fillObject]
  Future<ManagedObject> generateObject(
      ManagedContext context, GenerationScheme scheme) async {
    Query query = Query.forEntity(scheme.entity, context);
    InstanceMirror instance = reflect(query.values);
    scheme.fillObject(instance, this.registry);
    return query.insert();
  }

  List<Future<ManagedObject>> generateObjects(
      ManagedContext context, GenerationScheme scheme, int n) {
    return List.generate(n, (i) => generateObject(context, scheme));
  }
}
