# Flood
A data-generator for databases using Aqueduct

## Usage

An example for a Hero model containing a *name* field. 

```dart
import 'package:flood/flood.dart';

initializeDb(ManagedContext context) async {
  // An instance of GenerationScheme needs to be created for each model
  var heroScheme = GenerationScheme(
    context.entityForType(Hero),
    {"name": () => "hero_" + faker.internet.userName()},
    5,
  );
  var flood = Flood(context);
  // It also needs to be registered.
  flood.register(heroScheme);
  return await flood.fill();
}
```

## Features and bugs

There is currently no way I know of to call this neatly inside of an application. The current way I've used it is outlined in the example folder, which makes use of the main.dart file in the bin folder.

Currently existing data in the database is not used when generating new data.

Please file feature requests and bugs at the issue tracker.
