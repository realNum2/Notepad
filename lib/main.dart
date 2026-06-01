import 'dart:ui';

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
  final TextEditingController _textController = TextEditingController();

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
        _notes[selectedNote] = Note(id: _selectedIndex!, title: _titleController.text, text: _textController.text);
      });
    }
  }

  void _selectNote(Note note) {
    setState(() {
      _selectedIndex = note.id;

      _titleController.text = note.title;
      _textController.text = note.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
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
                    // Text(
                    //   String.fromCharCode(61440),
                    //   style: TextStyle(
                    //     fontFamily: 'AppIcons',
                    //     fontSize: 40
                    //   ),
                    // )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_notes[index].title.isEmpty 
                      ? 'New Note' 
                      : _notes[index].title),
                      onTap: () {
                        _selectNote(_notes[index]);
                      },
                    );
                  },
              ),
              ),
            ],
          ),
        ),
      ),

          Expanded(child: Container(
            color: lightMainBG,
            child: _selectedIndex == null 
            ? Center(child: Text('Select or create new note'),)
            : Column(children: [Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                    hintText: 'Note Title', 
                  ),
                )
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                    hintText: 'Note text...',
                    border: InputBorder.none,
                  ),
                )
                )])
            )
          ),
        ],
      ),
          
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
