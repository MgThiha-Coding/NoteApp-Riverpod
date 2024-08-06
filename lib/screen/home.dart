import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteapp_riverpod/notifier/notifier.dart';
import 'package:noteapp_riverpod/screen/addnote.dart';
import 'package:noteapp_riverpod/notifier/model.dart';
import 'package:noteapp_riverpod/screen/viewnote.dart';

class Home extends ConsumerWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(AppNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          'NoteEase',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
        ),
      ),
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
      
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: GridView.builder(
          itemCount: notes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 180, // Set fixed height for each card
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final note = notes[index];
            return GestureDetector(
              onLongPress: (){
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
                              ));
              },
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditNoteScreen(note: note),
                  ),
                );
              },
              child: Card(
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox( height: 2,),
                         Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(4),
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
                        SizedBox( height: 5,),
                          Text(
                            note.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // Limit title to 2 lines
                          ),
                          Expanded(
                            child: Text(
                              note.story,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3, // Limit story to 3 lines
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
                    backgroundColor: Colors.orange,
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
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _storyController,
                decoration: InputDecoration(
                  hintText: "Story",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                maxLines: null, // Allow the story to expand vertically
               // Fill the available space
              ),
            ),
          ],
        ),
      ),
    );
  }
}
