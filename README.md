# Flood
A data-generator for databases using Aqueduct.

## Usage

An example for a **Hero** model containing a *name* field. This function could then be called in for example, any **Harness** with the **TestHarnessORMMixin**.

```dart
import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:faker/faker.dart';
import 'package:flood/flood.dart';

class ExampleHarness extends TestHarness<DbChannel> with TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  Future seed() async {
    await initializeDb(context);
  }

  initializeDb(ManagedContext context) async {
    // An instance of GenerationScheme needs to be created for each model
    var heroScheme = GenerationScheme(
      // The ManagedEntity instance for the Hero model
      context.entityForType(Hero),
      
      // The generation method to use for the name field
      {"name": () => "hero_" + faker.internet.userName()},
      
      // Number of objects to create
      5,
    );
    var flood = Flood(context);
    // Register the GenerationScheme.
    flood.register(heroScheme);
    return await flood.fill();
  }
}

```

## Features and bugs

Please file feature requests and bugs at the issue tracker.
