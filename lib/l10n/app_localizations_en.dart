// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'API Example App';

  @override
  String get homeTitle => 'Home';

  @override
  String get favTitle => 'Favorites';

  @override
  String get searchButton => 'Search';

  @override
  String get noResults => 'No results found';

  @override
  String get helloWorld => 'Hello World!';
}
