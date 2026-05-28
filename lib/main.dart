import 'package:flutter/material.dart';
import 'package:my_app/note.dart';
import 'app_colors.dart';


// _________________________________________________________
// CONSTANTS
// _________________________________________________________

  const Color accent = Color(0xFF007FFF);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Row(
        children: [
          Container(
            width: 256,
            color: lightSecondBG,

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: buttonText,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  ),
                  onPressed: _addNote,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(Icons.add),
                    Text('Add Note')
                  ],)
                ))
              ],
              )
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
        onPressed: () {},
        tooltip: 'Increment',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32)
        ),
        backgroundColor: accent,
        foregroundColor: buttonText,
        icon: const Icon(Icons.save), // Иконка
        label: const Text('Save Note'), // Текст
      ),
    );
  }
}
