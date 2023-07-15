# {{APP_NAME}}
 Flutter project codebase for the {{APP_NAME}} app

|                  |                                           |
|------------------|-------------------------------------------|
| Architecture     | MVVM                                      |
| Folder Structure | Feature-based folder structure            |
| Service Locator  | [Get_it](https://pub.dev/packages/get_it) |
| Navigation       | Navigator 1.0                             |


# Setup

## Configuration
> 🚨 Ignoring this setup may cause compile time errors. 

Configuration and environment information are provided to the rest of the app via static access on the `EnvironmentConfig` class (_lib/main/environment_config.dart_). The values of the fields are stored in a json file **excluded** from version control and passed in at compile time using `dart-define`. 

1. Create a new configuration file at _lib/main_ as _env_prod.json_. You may have multiple configurations files (_env_staging.json_, _env_dev.json_, etc), based on your needs.
2. Copy the code below into your json and edit the values to match your app and environment.

```
{
    // REQUIRED
    "ENV_NAME": "Development",  // Name or description of this environment
    "IS_PROD": false, // Wether this build is for testing or going live
    "APP_NAME": "Litrogen Dev", // Name of the app. This will affect the launcher name of both android and iOS builds.
    "PACKAGE_NAME": "com.mycompany.myapp", // Reverse id for the application
    "PACKAGE_NAME_SUFFIX": ".dev", // Use this to create different flavors of the build. Leave empty for production.
    // FOR REST NETWORK SERVICE
    "API_URL": "example-server-1029.io", // Server url. Do not include the http method 
    "API_VERSION": "v1" // Server url version. Provide any unencoded path for the API_URL. E.g "api", "api/v1" 
}
```
3. Make sure to exclude the file from version control by adding its path to _.gitignore_

For more information on using `dart-define` for environment variables, see [here](https://itnext.io/secure-your-flutter-project-the-right-way-to-set-environment-variables-with-compile-time-variables-67c3163ff9f4)


Run the project by calling 
```
flutter run -t "lib/main/main.dart" --dart-define-from-file=PATH_TO_CONFIG_JSON
```

Build apks or aab bundle using similar command
```
flutter build apk -t "lib/main/main.dart" --dart-define-from-file=PATH_TO_CONFIG_JSON
```
```
flutter build appbundle -t "lib/main/main.dart" --dart-define-from-file=PATH_TO_CONFIG_JSON
```

Remember to configure your IDE to run with these commands to enjoy a seamless debugging experience. A version of these commands have been added to _.vscode/launch.json_ which you can edit to match your preferences.
>❗ Do not commit any of the config json files into version control

## Theming 
### App Colors 
### App Styles 
### Setting and Changing Themes

# Services

# 
