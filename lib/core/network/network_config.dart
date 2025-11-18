class NetworkConfig {
  NetworkConfig._internal();
  static final NetworkConfig instance = NetworkConfig._internal();

  late String environment;
  String get baseUrl {
    return 'https://opentdb.com';
  }

  void setEnvironment(String env) {
    environment = env;
  }
}