import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/errors/failures.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_notes/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImplementation implements NotesRepository {
  @override
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
  }) {
    // TODO: implement createNote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() {
    // TODO: implement getAllNotes
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  }) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
