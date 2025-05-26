import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';

/// Use case for deleting a note
class DeleteNote with UseCase<void, DeleteNoteParams> {
  const DeleteNote(this.repository);

  final NotesRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteNoteParams params) async {
    return repository.deleteNote(params.id);
  }
}

class DeleteNoteParams {
  const DeleteNoteParams({required this.id});

  final String id;
}
