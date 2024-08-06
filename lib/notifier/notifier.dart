import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noteapp_riverpod/notifier/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotifier extends StateNotifier<List<Note>> {
  AppNotifier() : super([]) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final noteJson = prefs.getStringList('notes') ?? [];
    final notes =
        noteJson.map((note) => Note.fromJson(jsonDecode(note))).toList();
    state = notes;
  }

  Future<void> addNote(Note note) async {
    state = [...state, note];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final noteJson = state.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList('notes', noteJson);
  }

  Future<void> deleteNote(Note note) async {
    state = [...state.where((n) => n != note).toList()];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final noteJson = state.map((note) => jsonEncode(note.toJson())).toList();
    await prefs.setStringList('notes', noteJson);
  }

  Future<void> updateNote(Note oldNote, Note newNote) async {
    final index = state.indexWhere((n) => n == oldNote);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        newNote,
        ...state.sublist(index + 1),
      ];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final noteJson = state.map((note) => jsonEncode(note.toJson())).toList();
      await prefs.setStringList('notes', noteJson);
    }
  }
}

final AppNotifierProvider =
    StateNotifierProvider<AppNotifier, List<Note>>((ref) {
  return AppNotifier();
});
