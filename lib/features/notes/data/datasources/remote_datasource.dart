import 'dart:math';

import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:uuid/uuid.dart';

abstract class RemoteDatasource {
  /// Fetches all notes from the remote server.
  /// Throws a [Exception] for all error codes.
  Future<List<Note>> getAllNotes();

  /// Creates a new note on the server.
  /// [title] and [content] are required.
  /// Returns the created [Note] (which should include the server-generated ID
  /// and timestamps).
  ///
  /// Throws a [Exception] for all error codes.
  Future<Note> createNote({required String title, required String content});

  /// Updates an existing note on the server.
  /// Takes a [Note] that contains the ID of the note to update and the new data
  ///
  /// Returns the updated [Note].
  /// Throws a [Exception] for all error codes.
  Future<Note> updateNote({
    required String id,
    required String title,
    required String content,
  });

  /// Deletes a note from the server by its [id].
  /// Throws a [Exception] for all error codes.
  Future<void> deleteNote(String id);
}

/// Implementation of [RemoteDatasource] that interacts with a "remote server"
///
/// Since this is a mock implementation, it does not actually perform network
/// requests and instead simulates the behavior of a remote datasource by adding
/// a delay and returning data from an in-memory store.
///
/// - Delays are randomly generated between 1000ms and 2500ms to simulate
/// network latency.
/// - Fails with a 10% chance to simulate server errors.
class RemoteDatasourceImpl implements RemoteDatasource {
  RemoteDatasourceImpl({this.source = const []});

  // In-memory store for notes
  final List<Note> source;
  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  @override
  Future<Note> createNote({
    required String title,
    required String content,
  }) async {
    await _simulateNetworkDelay();
    _simulatePotentialServerError();

    final now = DateTime.now();
    final newNote = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
    source.add(newNote);
    return newNote;
  }

  @override
  Future<void> deleteNote(String id) async {
    await _simulateNetworkDelay();
    _simulatePotentialServerError();

    final noteIndex = source.indexWhere((note) => note.id == id);
    if (noteIndex == -1) {
      throw Exception('Note with ID $id not found');
    }

    source.removeAt(noteIndex);
    return Future.value();
  }

  @override
  Future<List<Note>> getAllNotes() async {
    await _simulateNetworkDelay();
    _simulatePotentialServerError();
    return Future.value(List<Note>.from(source));
  }

  @override
  Future<Note> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    await _simulateNetworkDelay();
    _simulatePotentialServerError();

    final existingNoteIndex = source.indexWhere((n) => n.id == id);
    if (existingNoteIndex == -1) {
      throw Exception('Note with ID $id not found');
    }

    final existingNote = source[existingNoteIndex];
    final updatedNote = existingNote.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    source[existingNoteIndex] = updatedNote;
    return Future.value(updatedNote);
  }

  // Simulate a 10% chance of server error
  void _simulatePotentialServerError() {
    if (_random.nextInt(10) == 0) {
      throw Exception('Simulated server error');
    }
  }

  // Simulate a delay between 1000ms and 2500ms
  Future<void> _simulateNetworkDelay() async {
    final delay = Duration(milliseconds: 1000 + _random.nextInt(1000));
    await Future<void>.delayed(delay);
  }
}
