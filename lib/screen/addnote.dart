import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:noteapp_riverpod/notifier/model.dart';
import 'package:noteapp_riverpod/notifier/notifier.dart';
import 'package:noteapp_riverpod/screen/home.dart';
import 'package:noteapp_riverpod/screen/viewnote.dart';

class Addnote extends ConsumerStatefulWidget {
  const Addnote({super.key});

  @override
  ConsumerState<Addnote> createState() => _AddnoteState();
}

class _AddnoteState extends ConsumerState<Addnote> {
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _storycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(AppNotifierProvider);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM d, yyyy hh:mm a').format(now);

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
         color: Colors.blue[400],
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
      backgroundColor: Colors.white,
     
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [ 
           IconButton(onPressed: () {
              final title = _titlecontroller.text;
              final story = _storycontroller.text;
              final date = formattedDate;
              if (title.isNotEmpty || story.isNotEmpty) {
                final note = Note(story: story, title: title, date: date);
                ref.read(AppNotifierProvider.notifier).addNote(note);
                _titlecontroller.clear();
                _storycontroller.clear();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Viewnote()));
              }}, icon: Icon(Icons.save_alt))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          children: [
            TextField(
              maxLines: null,
              controller: _titlecontroller,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(fontSize: 19, color: Colors.blue),
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration( 
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 3,horizontal: 7),
                  child:  Text(formattedDate,style: TextStyle(color: Colors.blue),)),
              ],
            ),
            TextField(
              maxLines: null,
              controller: _storycontroller,
              decoration: InputDecoration(
                hintText: "Story",
                hintStyle: TextStyle( color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
