import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';

/// Abstract class for the Notes repository
abstract class NotesRepository {
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
  });

  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  });

  Future<Either<Failure, void>> deleteNote(String id);

  Future<Either<Failure, List<Note>>> getAllNotes();
}
