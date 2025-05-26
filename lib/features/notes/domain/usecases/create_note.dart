import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';

/// Use case for creating a note
class CreateNote with UseCase<Note, CreateNoteParams> {
  const CreateNote(this.repository);

  final NotesRepository repository;

  @override
  Future<Either<Failure, Note>> call(CreateNoteParams params) async {
    return repository.createNote(title: params.title, content: params.content);
  }
}

class CreateNoteParams {
  const CreateNoteParams({required this.title, required this.content});

  final String title;
  final String content;
}
