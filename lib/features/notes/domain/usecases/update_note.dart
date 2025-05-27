import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_note.freezed.dart';

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

@freezed
abstract class UpdateNoteParams with _$UpdateNoteParams {
  factory UpdateNoteParams({
    required String id,
    required String title,
    required String content,
  }) = _UpdateNoteParams;
}
