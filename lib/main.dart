import 'dart:convert';
import 'dart:ui';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown_quill/markdown_quill.dart';
import 'package:flutter/material.dart';
import 'package:my_app/note.dart';
import 'app_colors.dart';
import 'app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:markdown/markdown.dart' as md;


// _________________________________________________________
// ICONS
// _________________________________________________________

  class AppIcons {
    static const String _fontFamily = 'Icons';

    static const IconData add = IconData(61440, fontFamily: _fontFamily);
    static const IconData delete = IconData(61447, fontFamily: _fontFamily);
    static const IconData export = IconData(61446, fontFamily: _fontFamily);
    static const IconData italic = IconData(61445, fontFamily: _fontFamily);
    static const IconData listDots = IconData(61444, fontFamily: _fontFamily);
    static const IconData listNumber = IconData(61443, fontFamily: _fontFamily);
    static const IconData save = IconData(61441, fontFamily: _fontFamily);
    static const IconData bold = IconData(61442, fontFamily: _fontFamily);
    static const IconData profile = IconData(61450, fontFamily: _fontFamily);
    static const IconData theme = IconData(61448, fontFamily: _fontFamily);
    static const IconData language = IconData(61449, fontFamily: _fontFamily);
    static const IconData import = IconData(61451, fontFamily: _fontFamily);
  }


// _________________________________________________________
// APP
// _________________________________________________________

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> langNotifier = ValueNotifier('en');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode> (
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {

        return ValueListenableBuilder<String>(
          valueListenable: langNotifier,
          builder: (context, currentLang, child) {
            
    

    return MaterialApp(
      locale: Locale(currentLang.isEmpty ? 'en' : currentLang, ''),
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      localizationsDelegates: const [
        appLocalizationsDelegate,               // Ваш кастомный делегат
        GlobalMaterialLocalizations.delegate,   // ДОБАВИТЬ: Переводы для Material-виджетов
        GlobalWidgetsLocalizations.delegate,    // ДОБАВИТЬ: Переводы для базовых виджетов
        GlobalCupertinoLocalizations.delegate,  // ДОБАВИТЬ: Переводы для Cupertino (iOS) стилей
      ],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: const [AppColors.light],
        fontFamily: 'Sans3',
        scaffoldBackgroundColor: AppColors.light.primaryBG,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: const [AppColors.dark],
        fontFamily: 'Sans3',
        scaffoldBackgroundColor: AppColors.dark.primaryBG, 
      ),
      themeMode: currentMode,
      home: Builder(
        builder: (context) => MyHomePage(title: 'Notes mini app'),
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _titleController = TextEditingController();
  final QuillController _textController = QuillController.basic();

  List<Note> _notes = [];
  String? _selectedIndex;


// _________________________________________________________
// ADD NOTE
// _________________________________________________________
  void _addNote() {
    String noteID = DateTime.now().millisecondsSinceEpoch.toString();
    Note newNote = Note(id: noteID, title: '', text: '');
    
    setState(() {
      _notes.add(newNote);
      _selectedIndex = noteID;
    });
  }


// _________________________________________________________
// SAVE NOTE
// _________________________________________________________
  void _saveNote() {
    final selectedNote = _notes.indexWhere((element) => element.id == _selectedIndex);
    if(selectedNote != -1) {
      setState(() {
        _notes[selectedNote] = Note(id: _selectedIndex!, title: _titleController.text, text: jsonEncode(_textController.document.toDelta().toJson()));
      });
    }
  }


// _________________________________________________________
// SELECT NOTE
// _________________________________________________________
  void _selectNote(Note note) {
    setState(() {
      _selectedIndex = note.id;

      _titleController.text = note.title;

      if (note.text.isNotEmpty) {
            _textController.document = Document.fromJson(
                jsonDecode(note.text) as List
            );
        } else {
            _textController.document = Document();
        }
    });
  }


// _________________________________________________________
// DELETE NOTE
// _________________________________________________________
  void _deleteNote() {
    final deletedNote = _notes.indexWhere((element) => element.id == _selectedIndex);
    
    
    setState(() {
      _notes.removeAt(deletedNote);
      _selectedIndex = null;
    });
  }


// _________________________________________________________
// EXPORT
// _________________________________________________________
  void _export() async {
    final delta = _textController.document.toDelta();
    final markdownString = DeltaToMarkdown().convert(delta);

    final String defaultName = _titleController.text.isNotEmpty 
      ? "${_titleController.text}.md" 
      : "note.md";

      try {
    // Открываем диалог сохранения (возвращает String? путь на ПК)
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Экспорт заметки в Markdown',
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: ['md'],
      );

      // Если пользователь закрыл окно сохранения
      if (outputPath == null) return;

      // На ПК пишем строку напрямую в файл по полученному пути
      final file = File(outputPath);
      await file.writeAsString(markdownString);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Файл успешно сохранен на диск!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения файла: $e')),
      );
    }
  }

// _________________________________________________________
// IMPORT
// _________________________________________________________
  void _import() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['md'],
    );

  if (result == null) return;

    final file = File(result.files.single.path!);
    final markdownString = await file.readAsString();

    final mdToDelta = MarkdownToDelta(markdownDocument: md.Document());
    final delta = mdToDelta.convert(markdownString);

    setState(() {
        _addNote();
        _textController.document = Document.fromJson(delta.toJson());
        _titleController.text = result.files.single.name.replaceAll('.md', '');
    });
  }


// _________________________________________________________
// NUM LIST
// _________________________________________________________
  void _numderList() {
  final selected = _textController.selection;

  final isNum = _textController.getSelectionStyle().attributes.containsKey(Attribute.ol.key);

  _textController.formatSelection(
    isNum ? Attribute.clone(Attribute.ol, null) : Attribute.ol,
  );
  }


// _________________________________________________________
// DOT LIST
// _________________________________________________________
  void _dotList() {
  final selected = _textController.selection;

  final isDot = _textController.getSelectionStyle().attributes.containsKey(Attribute.ul.key);

  _textController.formatSelection(
    isDot ? Attribute.clone(Attribute.ul, null) : Attribute.ul,
  );
  }


// _________________________________________________________
// BOLD
// _________________________________________________________
  void _makeBold() {
    final selected = _textController.selection;

    if (selected.isCollapsed) {
    return; 
  }

  final isBold = _textController.getSelectionStyle().attributes.containsKey(Attribute.bold.key);

  _textController.formatSelection(
    isBold ? Attribute.clone(Attribute.bold, null) : Attribute.bold,
  );
  }


// _________________________________________________________
// ITALIC
// _________________________________________________________
  void _makeItalic() {
    final selected = _textController.selection;

    if (selected.isCollapsed) {
    return; 
  }

  final isItalic = _textController.getSelectionStyle().attributes.containsKey(Attribute.italic.key);

  _textController.formatSelection(
    isItalic ? Attribute.clone(Attribute.italic, null) : Attribute.italic,
  );
  }


// _________________________________________________________
// THEME
// _________________________________________________________
  void _themeToggle() {
    if (themeNotifier.value == ThemeMode.light) {
        themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }


// _________________________________________________________
// LANGUAGE
// _________________________________________________________
  void _langToggle() {
    if (langNotifier.value == 'ru') {
      langNotifier.value = 'en';
    } else {
      langNotifier.value = 'ru';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          
          Padding(
            padding: EdgeInsets.all(12),
            child: 
          Container(
            
            padding: EdgeInsets.all(6.0),
            width: 256,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.border.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(25),
              color: context.colors.secondBG.withOpacity(0.6),
              
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  spreadRadius: 0,
                  blurRadius: 16,
                  offset: Offset(0, 4)
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  spreadRadius: 0,
                  blurRadius: 24,
                  offset: Offset(0, 8)
                ),
              ]
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.accent,
                      foregroundColor: Color(0xFFFFFFFF),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19.0))
                  ).copyWith(backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return context.colors.accentHover;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return context.colors.accentActive;
                    }
                    return context.colors.accent;
                  })),
                  onPressed: _addNote,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(AppIcons.add),
                    SizedBox(width: 8),
                    Text(context.l1n('addNote'))
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(6, 4, 4, 4),

                      selected: _notes[index].id == _selectedIndex,
                      selectedTileColor: context.colors.active,
                      textColor: context.colors.primaryText,
                      selectedColor: context.colors.primaryText,
                      onTap: () {
                        _selectNote(_notes[index]); 
                      },

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(19.0)
                      ),

                      titleTextStyle: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primaryText,
                      ),

                      subtitleTextStyle: TextStyle(
                        fontSize: 14.0,
                        color: context.colors.secondText
                      ),

                      title: Text(_notes[index].title.isEmpty 
                      ? 'New Note' 
                      : _notes[index].title),
                      subtitle: Text(() {
                        try {
                            if (_notes[index].text.isEmpty) return 'Note Text';
                            return Document.fromJson(jsonDecode(_notes[index].text) as List)
                                .toPlainText()
                                .trim();
                        } catch (e) {
                            return 'Note Text';
                        }
                    }()));
                  },
              ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.colors.thirdBG,
                  borderRadius: BorderRadius.circular(19)

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: _themeToggle, icon: Icon(AppIcons.theme), iconSize: 24, color: context.colors.primaryText,),
                    IconButton(onPressed: _langToggle, icon: Icon(AppIcons.language), iconSize: 24, color: context.colors.primaryText,),
                    IconButton(onPressed: (){}, icon: Icon(AppIcons.profile), iconSize: 24, color: context.colors.disabledText,)
                  ],
                ),
              ),
            ],
          ),
        ),
          ),
      
          
          Expanded(
            child: Container(
              color: context.colors.primaryBG,
              child: _selectedIndex == null
                ? Center(child: Text(context.l1n('selectNote')))
                : Column(
                    children: [
                      // Toolbar
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Кнопки форматирования
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: context.colors.secondBG,
                                  border: Border.all(color: context.colors.border.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(onPressed: _makeBold, icon: Icon(AppIcons.bold), iconSize: 14),
                                    IconButton(onPressed: _makeItalic, icon: Icon(AppIcons.italic), iconSize: 14),
                                    IconButton(onPressed: _numderList, icon: Icon(AppIcons.listNumber), iconSize: 14),
                                    IconButton(onPressed: _dotList, icon: Icon(AppIcons.listDots), iconSize: 14),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              // Кнопка экспорта
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: context.colors.secondBG,
                                  border: Border.all(color: context.colors.border.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                child: IconButton(onPressed: _export, icon: Icon(AppIcons.export)),
                              ),

                              const SizedBox(width: 8.0),
                              // Кнопка экспорта
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: context.colors.secondBG,
                                  border: Border.all(color: context.colors.border.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                child: IconButton(onPressed: _import, icon: Icon(AppIcons.import)),
                              ),

                              const SizedBox(width: 8.0),
                              // Кнопка удаления
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: context.colors.secondBG,
                                  border: Border.all(color: context.colors.border.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                child: IconButton(
                                  icon: Icon(AppIcons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(16.0),
                                            width: 512,
                                            // Высоту убрали, чтобы контент не обрезался при изменении шрифтов
                                            decoration: BoxDecoration(
                                              color: context.colors.secondBG,
                                              borderRadius: BorderRadius.circular(24.0),
                                              border: Border.all(color: context.colors.border.withOpacity(0.6)),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min, // Диалог сожмется под размер контента
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание иконки и текста по верхней линии
                                                  children: [
                                                    Icon(AppIcons.delete, size: 36),
                                                    const SizedBox(width: 8), // 8 пикселей между иконкой и текстом
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start, // Прижали тексты к левому краю
                                                        children: [
                                                          Text(
                                                            context.l1n('deleteNote'),
                                                            style: TextStyle(
                                                              color: context.colors.primaryText,
                                                              fontSize: 16.0,
                                                              decoration: TextDecoration.none,
                                                              fontWeight: FontWeight.bold, // Сделали заголовок выразительнее
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4), // Небольшой отступ между заголовком и подзаголовком
                                                          Text(
                                                            context.l1n('undone'),
                                                            style: TextStyle(
                                                              color: context.colors.secondText,
                                                              fontSize: 12.0,
                                                              decoration: TextDecoration.none,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 24), // 24 пикселя между блоком текста и кнопками
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: context.colors.thirdBG,
                                                        foregroundColor: context.colors.primaryText,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8), // Исправлена ошибка BorderRadiusGeometry
                                                        ),
                                                      ),
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text(context.l1n('cancel')),
                                                    ),
                                                    const SizedBox(width: 8), // 8 пикселей между кнопками
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: context.colors.error,
                                                        foregroundColor: Color(0xFFFFFFFF),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8), // Исправлена ошибка BorderRadiusGeometry
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _deleteNote();
                                                        Navigator.pop(context); // Закрываем диалог после удаления
                                                      },
                                                      child: Text(context.l1n('delete')),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Редактор
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: context.l1n('titleHint'),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: context.colors.border),
                            )
                          ),
                        ),
                      ),
                      
                      Expanded(
                        child: QuillEditor.basic(
                          controller: _textController,
                          config: const QuillEditorConfig(
                            placeholder: 'Start typing...'
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          ],),
          
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        tooltip: 'Increment',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32)
        ),
        backgroundColor: context.colors.accent,
        hoverColor: context.colors.accentHover,
        focusColor: context.colors.accentActive,
        foregroundColor: Color(0xFFFFFFFF),
        icon: const Icon(AppIcons.save), // Иконка
        label: Text(context.l1n('saveNote')), // Текст
      ),
    );
  }
}

extension LocalizationExtension on BuildContext {
  String l1n(String key) => AppLocalizations.of(this)?.translate(key) ?? key;
}