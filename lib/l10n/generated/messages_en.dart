// ignore_for_file: non_constant_identifier_names

import 'messages.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String who_is_here(Object name) {
    return 'Who was here $name';
  }
}
