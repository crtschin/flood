import 'package:aqueduct/aqueduct.dart';
import 'package:flood/src/dependancy_graph.dart';
import 'package:flood/src/generation_scheme.dart';
import 'package:flood/src/query_creator.dart';

/// The main container for specifying and executing the generation methods
///
/// This will use the supplied [ManagedContext] to insert objects into the
/// database using the [GenerationScheme]s. This will only generate objects
/// which have a registered [GenerationScheme], as such may fail when a
/// [GenerationScheme] has not been given for every table in the database.
///
/// Existing data in the database is not used when generating new data.
class Flood {
  ManagedContext context;
  Map<ManagedEntity, GenerationScheme> objects = Map();

  Flood(ManagedContext this.context) {}

  register(GenerationScheme objectMapping) {
    objects[objectMapping.entity] = objectMapping;
  }

  registerAll(Iterable<GenerationScheme> objectMapping) {
    objects.addEntries(objectMapping.map((obj) => MapEntry(obj.entity, obj)));
  }

  Future<Map<ManagedEntity, List<ManagedObject>>> fill() async {
    DependancyGraph<GenerationScheme> graph = createRelationshipGraph();
    Iterable<GenerationScheme> order =
        graph.findOrder().map((node) => node.value).toList();
    var creator = QueryCreator(generated: Map());
    return creator.create(context, order);
  }

  /// Create a directed graph from the relationships between columns
  ///
  /// Map all relationships in a directed graph, where the attributes
  /// containing the @Relate annotation will be lower in the graph
  DependancyGraph<GenerationScheme> createRelationshipGraph() {
    DependancyGraph<GenerationScheme> graph =
        DependancyGraph<GenerationScheme>();

    // Loop over each of the registered objects
    for (MapEntry<ManagedEntity, GenerationScheme> entry in objects.entries) {
      ManagedEntity entity = entry.key;

      // Loop over the relationships of the object
      for (MapEntry<String, ManagedRelationshipDescription> rel
          in entity.relationships.entries) {
        ManagedRelationshipDescription relationship = rel.value;
        ManagedEntity otherEntity = relationship.inverse.entity;

        // If the related object is also registered, add the relationship to
        // the graph
        if (objects.containsKey(otherEntity)) {
          if (relationship.isBelongsTo) {
            graph.addRelationship(objects[otherEntity], objects[entity]);
          }
        }
      }
    }
    return graph;
  }
}
