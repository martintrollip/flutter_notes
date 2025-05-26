import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';

/// Use case for updating a note
class UpdateNote with UseCase<Note, UpdateNoteParams> {
  const UpdateNote(this.repository);

  final NotesRepository repository;

  @override
  Future<Either<Failure, Note>> call(UpdateNoteParams params) async {
    return repository.updateNote(
      id: params.id,
      title: params.title,
      content: params.content,
    );
  }
}

class UpdateNoteParams {
  const UpdateNoteParams({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id;
  final String title;
  final String content;
}
