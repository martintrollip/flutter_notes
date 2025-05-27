import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/errors/failures.dart';
import 'package:flutter_notes/features/notes/data/datasources/datasources.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_notes/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImplementation implements NotesRepository {
  NotesRepositoryImplementation({required this.remoteDatasource});

  final RemoteDatasource remoteDatasource;

  @override
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
  }) async {
    try {
      return Right(
        await remoteDatasource.createNote(title: title, content: content),
      );
    } on HttpException catch (e) {
      return Future.value(Left(ServerFailure(message: e.message)));
    } on Exception catch (e) {
      return Future.value(Left(GeneralFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await remoteDatasource.deleteNote(id);
      return const Right(null);
    } on HttpException catch (e) {
      return Future.value(Left(ServerFailure(message: e.message)));
    } on Exception catch (e) {
      return Future.value(Left(GeneralFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      final notes = await remoteDatasource.getAllNotes();
      return Right(notes);
    } on HttpException catch (e) {
      return Future.value(Left(ServerFailure(message: e.message)));
    } on Exception catch (e) {
      return Future.value(Left(GeneralFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      final note = await remoteDatasource.updateNote(
        id: id,
        title: title,
        content: content,
      );
      return Right(note);
    } on HttpException catch (e) {
      return Future.value(Left(ServerFailure(message: e.message)));
    } on Exception catch (e) {
      return Future.value(Left(GeneralFailure(message: e.toString())));
    }
  }
}
