class AppConfig {
  AppConfig._internal();
  static final AppConfig instance = AppConfig._internal();

  late String environment;

  void setEnvironment(String env) {
    environment = env;
  }
}