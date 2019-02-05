/// Fills a database using the Aqueduct ORM
///
/// Every table that needs to be filled, requires an instance of
/// [GenerationScheme]. This specifies the functions to use to fill the
/// instances of the model. The order in which objects are created is
/// determined using a [DependancyGraph] containing all of the schemes to be
/// used for generation.
library flood;

export 'src/flood.dart';
export 'src/generation_scheme.dart';

import 'src/test/model/model.dart';
