import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteapp_riverpod/screen/home.dart';

void main(){
  runApp( 
    ProviderScope(child: NoteApp())
  );
}
class NoteApp extends StatelessWidget {
  const NoteApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
       debugShowCheckedModeBanner: false,
       home: Home(),
    );
  }
}