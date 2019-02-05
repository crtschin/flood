import 'dart:math';

import 'package:aqueduct/src/db/managed/context.dart';
import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:faker/faker.dart';
import 'package:flood/flood.dart';
import 'package:flood/src/generation_scheme.dart';
import 'package:flood/src/test/channel/channel.dart';
import 'package:flood/src/test/model/model.dart';

export 'package:aqueduct/aqueduct.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';

class Harness extends TestHarness<DbChannel> with TestHarnessORMMixin {
  Flood filler;
  List<GenerationScheme> heroes;
  List<GenerationScheme> heroesAndVillains;
  List<GenerationScheme> all;

  @override
  Future onSetUp() async {
    await resetData();

    filler = Flood(context);
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

    heroes = [heroScheme];
    heroesAndVillains = [heroScheme, villainScheme, rivalryScheme];
    all = [heroScheme, villainScheme, rivalryScheme, battleScheme, fanScheme];
  }

  @override
  Future onTearDown() async {}

  @override
  ManagedContext get context => channel.context;
}
