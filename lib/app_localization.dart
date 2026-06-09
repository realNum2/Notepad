import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'addNote': 'New File',
      'saveNote': 'Save File',
      'newNote': 'New File',
      'selectNote': 'Select or create new file',
      'deleteNote': 'Delete File?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'undone': 'This action cannot be undone.',
      'titleHint': 'Enter file title',
      'textHint': 'Start typing...',
    },
    'ru': {
      'addNote': 'Добавить',
      'saveNote': 'Сохранить',
      'newNote': 'Новый Файл',
      'selectNote': 'Выберите или создайте файл',
      'deleteNote': 'Удалить Файл?',
      'cancel': 'Отмена',
      'delete': 'Удалить',
      'undone': 'Это действие нельзя отменить.',
      'titleHint': 'Заголовок Файла',
      'textHint': 'Начните печатать...',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

const LocalizationsDelegate<AppLocalizations> appLocalizationsDelegate = _AppLocalizationsDelegate();
