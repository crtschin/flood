import 'package:aqueduct/aqueduct.dart';

class Hero extends ManagedObject<_Hero> implements _Hero {}

class Villain extends ManagedObject<_Villain> implements _Villain {}

class Rivalry extends ManagedObject<_Rivalry> implements _Rivalry {}

class Battle extends ManagedObject<_Battle> implements _Battle {}

class Fan extends ManagedObject<_Fan> implements _Fan {}

class _Hero {
  @primaryKey
  int id;

  @Column(unique: true)
  String name;

  ManagedSet<Rivalry> rivalries;
}

class _Villain {
  @primaryKey
  int id;

  @Column(unique: true)
  String name;

  ManagedSet<Rivalry> rivalries;
}

class _Rivalry {
  @primaryKey
  int id;

  @Relate(#rivalries)
  Villain villain;

  @Relate(#rivalries)
  Hero hero;

  ManagedSet<Battle> battles;
  ManagedSet<Fan> fans;
}

class _Battle {
  @primaryKey
  int id;

  bool heroWon;

  @Relate(#battles)
  Rivalry rivalry;
}

class _Fan {
  @primaryKey
  int id;

  String name;

  @Relate(#fans)
  Rivalry rivalry;
}
