class EnvironmentConfig {
  static const isProd = bool.fromEnvironment('IS_PROD');
  static const appName = String.fromEnvironment('APP_NAME');
  static const apiUrl = String.fromEnvironment('API_URL');
  static const apiVersion = String.fromEnvironment('API_VERSION');
}
