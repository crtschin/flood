import 'package:flood/flood.dart';
import 'package:flood/src/test/model/model.dart';

import 'harness/app.dart';

Future main() async {
  final harness = await Harness()
    ..install();

  group("Testing dependancy graph.", () {
    test("Checking if roots contains correct number of elements", () async {
      harness.filler.registerAll(harness.heroesAndVillains);
      DependancyGraph<GenerationScheme> graph =
          harness.filler.createRelationshipGraph();
      expect(
        graph.roots().length <= harness.heroesAndVillains.length,
        true,
      );
    });

    test("Checking if roots contains the expected elements", () async {
      harness.filler.registerAll(harness.heroesAndVillains);
      DependancyGraph<GenerationScheme> graph =
          harness.filler.createRelationshipGraph();
      expect(
        graph
            .roots()
            .map((node) => node.value.entity.instanceType.reflectedType)
            .toSet()
            .containsAll([Hero, Villain]),
        true,
      );
    });

    test("Checking if order contains same number of elements as graph",
        () async {
      harness.filler.registerAll(harness.heroesAndVillains);
      DependancyGraph<GenerationScheme> graph =
          harness.filler.createRelationshipGraph();
      expect(
        graph.findOrder().length,
        harness.heroesAndVillains.length,
      );
    });

    test("Checking if order contains correct order of elements in graph",
        () async {
      harness.filler.registerAll(harness.heroesAndVillains);
      DependancyGraph<GenerationScheme> graph =
          harness.filler.createRelationshipGraph();
      List<Type> typeOrder = graph
          .findOrder()
          .map((node) => node.value.entity.instanceType.reflectedType)
          .toList();
      expect(
        typeOrder.sublist(0, 2).toSet().containsAll([Hero, Villain]),
        true,
      );
      expect(
        typeOrder.sublist(2, 3).toSet().containsAll([Rivalry]),
        true,
      );
    });
  });

  group("Testing complete usage", () {
    test("Checking the number of generated values for small graph", () async {
      harness.filler.registerAll(harness.heroesAndVillains);
      var generated = await harness.filler.fill();
      for (var entry in generated.entries) {
        expect(harness.filler.objects[entry.key].numberToGenerate,
            entry.value.length);
      }
    });
    test("Checking the number of generated values for bigger graph", () async {
      harness.filler.registerAll(harness.all);
      var generated = await harness.filler.fill();
      for (var entry in generated.entries) {
        expect(harness.filler.objects[entry.key].numberToGenerate,
            entry.value.length);
      }
    });
  });
}
