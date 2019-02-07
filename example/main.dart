import 'dart:math';

import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:faker/faker.dart';
import 'package:flood/flood.dart';

import 'lib/db.dart';

class ExampleHarness extends TestHarness<DbChannel> with TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  Future seed() async {
    await initializeDb(context);
  }

  Future<Map<ManagedEntity, List<ManagedObject>>> initializeDb(
      ManagedContext context) async {
    Flood flood = Flood(context);
    Faker faker = Faker();
    GenerationScheme heroScheme = GenerationScheme(
      context.entityForType(Hero),
      {"name": () => "hero_" + faker.internet.userName()},
      5,
    );

    GenerationScheme villainScheme = GenerationScheme(
      context.entityForType(Villain),
      {"name": () => "villain_" + faker.internet.userName()},
      5,
    );

    GenerationScheme rivalryScheme = GenerationScheme(
      context.entityForType(Rivalry),
      {},
      10,
    );

    GenerationScheme battleScheme = GenerationScheme(
      context.entityForType(Battle),
      {"heroWon": Random().nextBool},
      20,
    );

    GenerationScheme fanScheme = GenerationScheme(
      context.entityForType(Fan),
      {"name": () => "fan_" + faker.internet.userName()},
      5,
    );

    flood.registerAll([
      heroScheme,
      villainScheme,
      rivalryScheme,
      battleScheme,
      fanScheme,
    ]);
    return flood.fill();
  }
}
