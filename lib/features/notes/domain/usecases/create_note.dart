import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_note.freezed.dart';

/// Use case for creating a note
class CreateNote with UseCase<Note, CreateNoteParams> {
  const CreateNote(this.repository);

  final NotesRepository repository;

  @override
  Future<Either<Failure, Note>> call(CreateNoteParams params) async {
    return repository.createNote(title: params.title, content: params.content);
  }
}

@freezed
abstract class CreateNoteParams with _$CreateNoteParams {
  const factory CreateNoteParams({
    required String title,
    required String content,
  }) = _CreateNoteParams;
}
