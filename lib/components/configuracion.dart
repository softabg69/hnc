abstract class BaseConfig {
  String get baseUrlServicios;
  String get baseUrlWeb;
  String get googleWeb;
  String get googleAndroid;
  String get googleIos;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrlServicios => 'https://oesvrhnc.azurewebsites.net/datos/';
  @override
  String get baseUrlWeb => 'https://hnc.coeptalis.es/';
  @override
  String get googleWeb =>
      '92137133788-jsk6aabm84gtnpb6t9h62ab9lce01q6q.apps.googleusercontent.com';
  @override
  String get googleAndroid =>
      '177362842463-mq4d4dfb0t5j6hvs1s1mr9oh8d5hak1c.apps.googleusercontent.com';
  @override
  String get googleIos => '';
}

class ProdConfig implements BaseConfig {
  @override
  String get baseUrlServicios => 'https://oesvrhnc.azurewebsites.net/datos/';
  @override
  String get baseUrlWeb => 'https://hnc.coeptalis.es/';
  @override
  String get googleWeb =>
      '92137133788-jsk6aabm84gtnpb6t9h62ab9lce01q6q.apps.googleusercontent.com';
  @override
  String get googleAndroid =>
      '177362842463-mq4d4dfb0t5j6hvs1s1mr9oh8d5hak1c.apps.googleusercontent.com';
  @override
  String get googleIos => '';
}

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String PROD = 'PROD';

  BaseConfig? config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
