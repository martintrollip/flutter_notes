import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';

/// Use case for getting notes
class GetNotes with UseCase<List<Note>, NoParams> {
  const GetNotes(this.repository);

  final NotesRepository repository;

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) async {
    return repository.getAllNotes();
  }
}
