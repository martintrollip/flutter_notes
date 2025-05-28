import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_note.freezed.dart';

/// Use case for deleting a note
class DeleteNote with UseCase<void, DeleteNoteParams> {
  const DeleteNote(this.repository);

  final NotesRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteNoteParams params) async {
    return repository.deleteNote(params.id);
  }
}

@freezed
abstract class DeleteNoteParams with _$DeleteNoteParams {
  factory DeleteNoteParams({required String id}) = _DeleteNoteParams;
}
