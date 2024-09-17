enum Environment { dev, prod }

abstract class AppEnvironment {
  static late String baseApiUrl;
  static late Environment _environment;
  static Environment get environment => _environment;
  static setupEnv(Environment env) {
    _environment = env;
    switch (_environment) {
      case Environment.dev:
        {
          baseApiUrl = 'http://10.30.0.42/Dashboard/qr_warehouse/testing';
          break;
        }
      case Environment.prod:
        {
          baseApiUrl = 'http://10.30.0.42/Dashboard/qr_warehouse';
          break;
        }
    }
  }
}
