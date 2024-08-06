import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteapp_riverpod/notifier/model.dart';
import 'package:noteapp_riverpod/notifier/notifier.dart';
import 'package:noteapp_riverpod/screen/addnote.dart';
import 'package:noteapp_riverpod/screen/home.dart';

const Color kPrimaryColor = Colors.blue;
const Color kSecondaryColor = Colors.white;
const Color kBackgroundColor = Colors.white;
const Color kCardColor = Colors.white;
const double kTitleFontSize = 18.0;
const double kSubtitleFontSize = 14.0;
const double kDateFontSize = 12.0;
const double kTextFontSize = 16.0;

class Viewnote extends ConsumerStatefulWidget {
  const Viewnote({super.key});

  @override
  ConsumerState<Viewnote> createState() => _ViewnoteState();
}

class _ViewnoteState extends ConsumerState<Viewnote> {
  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(AppNotifierProvider);

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
         color: Colors.grey,
         child: Row(  
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Home()));
              }, icon: Icon(Icons.home,color: Colors.white,size: 30,)),
             
              FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Addnote()),
              );
            },
            child: Text("Add"),
          ),
        
          IconButton(onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Viewnote()));
          }, icon: Icon(Icons.view_agenda,color: Colors.white,size: 30,)),
           ],
         ),
      ),
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Text('Notes'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                 
                  color: kCardColor,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(
                      note.title,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: kTitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.story,
                          style: TextStyle(
                            fontSize: kSubtitleFontSize,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                          child: Text(
                            note.date,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: kDateFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditNoteScreen(note: note),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: kPrimaryColor),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Note'),
                                content: Text('Are you sure you want to delete this note?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(AppNotifierProvider.notifier)
                                          .deleteNote(note);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red[500]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  NoteDetailScreen({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        backgroundColor: kSecondaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: kPrimaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: note),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(
                fontSize: kTitleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              note.date,
              style: TextStyle(
                fontSize: kDateFontSize,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.story,
                  style: TextStyle(
                    fontSize: kTextFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditNoteScreen extends ConsumerStatefulWidget {
  final Note note;

  EditNoteScreen({required this.note, Key? key}) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends ConsumerState<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _storyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _storyController = TextEditingController(text: widget.note.story);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          TextButton(
            onPressed: () {
              final updatedTitle = _titleController.text;
              final updatedStory = _storyController.text;

              if (updatedTitle.isNotEmpty && updatedStory.isNotEmpty) {
                final updatedNote = Note(
                  story: updatedStory,
                  title: updatedTitle,
                  date: widget.note.date,
                );
                ref.read(AppNotifierProvider.notifier).updateNote(widget.note, updatedNote);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Saved"),
                    backgroundColor: kPrimaryColor,
                  ),
                );
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title",
                border: UnderlineInputBorder(),
                hintStyle: TextStyle(fontSize: kTextFontSize),
              ),
              style: TextStyle(fontSize: kTextFontSize),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _storyController,
                decoration: InputDecoration(
                  hintText: "Story",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintStyle: TextStyle(fontSize: kTextFontSize),
                ),
                style: TextStyle(fontSize: kTextFontSize),
                maxLines: null, // Allow the story to expand vertically
              ),
            ),
          ],
        ),
      ),
    );
  }
}
