import 'dart:convert';
import 'dart:ui';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown_quill/markdown_quill.dart';
import 'package:flutter/material.dart';
import 'package:my_app/note.dart';
// import 'app_colors.dart';


// _________________________________________________________
// CONSTANTS
// _________________________________________________________

  const Color accent = Color(0xFF6c5ce7);
  const Color accentHover = Color(0xFF5a4bd1);
  const Color accentActive = Color(0xFF483cb8);
  const Color error = Color(0xFFFF3B30);
  const Color sucess = Color(0xFF34C759);
  const Color buttonText = Color(0xFFFFFFFF);

  // ------Light Theme------
  const Color lightMainBG = Color(0xFFEDEDED);
  const Color lightSecondBG = Color(0xFFE1E1E1);
  const Color lightThirdBg = Color(0xFFD5D5D5);
  const Color lightBorder = Color(0xFFC5C5C5);
  const Color lightMainText = Color(0xFF151515);
  const Color lightSecondText = Color(0xFF4F4F4F);
  const Color lightDisabledText = Color(0xFF999999);
  const Color lightHover = Color(0xFFC0C0C0);
  const Color lightActive = Color(0xFFE0E0E0);

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
  }


// _________________________________________________________
// APP
// _________________________________________________________

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sans3',
        // useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: accent,),
        scaffoldBackgroundColor: lightMainBG,
        primaryColor: accent,
      ),
      home: const MyHomePage(title: 'Notes mini app'),
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

  void _addNote() {
    String noteID = DateTime.now().millisecondsSinceEpoch.toString();
    Note newNote = Note(id: noteID, title: '', text: '');
    
    setState(() {
      _notes.add(newNote);
      _selectedIndex = noteID;
    });
  }

  void _saveNote() {
    final selectedNote = _notes.indexWhere((element) => element.id == _selectedIndex);
    if(selectedNote != -1) {
      setState(() {
        _notes[selectedNote] = Note(id: _selectedIndex!, title: _titleController.text, text: jsonEncode(_textController.document.toDelta().toJson()));
      });
    }
  }

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

  void _deleteNote() {
    final deletedNote = _notes.indexWhere((element) => element.id == _selectedIndex);
    
    
    setState(() {
      _notes.removeAt(deletedNote);
      _selectedIndex = null;
    });
  }

  void _export() {}

  void _numderList() {
  final selected = _textController.selection;

  final isNum = _textController.getSelectionStyle().attributes.containsKey(Attribute.ol.key);

  _textController.formatSelection(
    isNum ? Attribute.clone(Attribute.ol, null) : Attribute.ol,
  );
  }

  void _dotList() {
  final selected = _textController.selection;

  final isDot = _textController.getSelectionStyle().attributes.containsKey(Attribute.ul.key);

  _textController.formatSelection(
    isDot ? Attribute.clone(Attribute.ul, null) : Attribute.ul,
  );
  }

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
              border: Border.all(color: lightBorder.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(25),
              color: lightSecondBG.withOpacity(0.6),
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
                      backgroundColor: accent,
                      foregroundColor: buttonText,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19.0))
                  ).copyWith(backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return accentHover;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return accentActive;
                    }
                    return accent;
                  })),
                  onPressed: _addNote,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(AppIcons.add),
                    SizedBox(width: 8),
                    Text('Add Note')
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
                      selectedTileColor: lightActive,
                      textColor: lightMainText,
                      selectedColor: lightMainText,
                      onTap: () {
                        _selectNote(_notes[index]); 
                      },

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(19.0)
                      ),

                      titleTextStyle: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: lightMainText,
                      ),

                      subtitleTextStyle: const TextStyle(
                        fontSize: 14.0,
                        color: lightSecondText
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
            ],
          ),
        ),
          ),
      
          
          Expanded(
  child: Container(
    color: lightMainBG,
    child: _selectedIndex == null
      ? Center(child: Text('Select or create new note'))
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
                        color: lightSecondBG,
                        border: Border.all(color: lightBorder.withOpacity(0.6)),
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
                        color: lightSecondBG,
                        border: Border.all(color: lightBorder.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: IconButton(onPressed: _export, icon: Icon(AppIcons.export)),
                    ),
                    const SizedBox(width: 8.0),
                    // Кнопка удаления
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: lightSecondBG,
                        border: Border.all(color: lightBorder.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: IconButton(
                        icon: Icon(AppIcons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete?'),
                                content: Text('Are you sure?'),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: lightThirdBg,
                                      foregroundColor: lightMainText,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: error,
                                      foregroundColor: buttonText,
                                    ),
                                    onPressed: _deleteNote,
                                    child: Text('Delete'),
                                  ),
                                ],
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
                  hintText: "Enter note title",
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightBorder),
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
        backgroundColor: accent,
        hoverColor: accentHover,
        focusColor: accentActive,
        foregroundColor: buttonText,
        icon: const Icon(AppIcons.save), // Иконка
        label: const Text('Save Note'), // Текст
      ),
    );
  }
}
