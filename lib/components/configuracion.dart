abstract class BaseConfig {
  String get baseUrlServicios;
  String get baseUrlWeb;

  bool get esDesarrollo => true;
}

class DevConfig implements BaseConfig {
  @override
  String get baseUrlServicios => 'https://tinyHNC.azurewebsites.net';
  @override
  String get baseUrlWeb => 'https://hnc.coeptalis.es/';
  @override
  bool get esDesarrollo => true;
}

class ProdConfig implements BaseConfig {
  @override
  String get baseUrlServicios => 'https://oesvrhnc.azurewebsites.net';
  @override
  String get baseUrlWeb => 'https://app.helpncare.es/';
  @override
  bool get esDesarrollo => false;
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
