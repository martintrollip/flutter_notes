// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/errors/failures.dart';
import 'package:flutter_notes/features/notes/data/data.dart'
    show NotesRepositoryImplementation, RemoteDatasource;
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/constants.dart';
import 'remote_datasource.mocks.dart';

void main() {
  late NotesRepositoryImplementation repository;
  late RemoteDatasource remoteDatasource;

  setUp(() {
    remoteDatasource = MockRemoteDatasource();
    repository = NotesRepositoryImplementation(
      remoteDatasource: remoteDatasource,
    );
  });

  group('createNote', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          remoteDatasource.createNote(title: tTitle, content: tContent),
        ).thenAnswer((_) async => tNote);
        // act
        final result = await repository.createNote(
          title: tTitle,
          content: tContent,
        );
        // assert
        verify(remoteDatasource.createNote(title: tTitle, content: tContent));
        expect(result, equals(Right<Failure, Note>(tNote)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful due to HttpException',
      () async {
        // arrange
        when(
          remoteDatasource.createNote(title: tTitle, content: tContent),
        ).thenThrow(const HttpException('Something went wrong'));
        // act
        final result = await repository.createNote(
          title: tTitle,
          content: tContent,
        );
        // assert
        verify(remoteDatasource.createNote(title: tTitle, content: tContent));
        expect(
          result,
          equals(
            const Left<Failure, Note>(
              ServerFailure(message: 'Something went wrong'),
            ),
          ),
        );
      },
    );

    test(
      'should return general failure when the call to remote data source is unsuccessful due to other Exception',
      () async {
        // arrange
        when(
          remoteDatasource.createNote(title: tTitle, content: tContent),
        ).thenThrow(Exception('Something went wrong'));
        // act
        final result = await repository.createNote(
          title: tTitle,
          content: tContent,
        );
        // assert
        verify(remoteDatasource.createNote(title: tTitle, content: tContent));
        expect(
          result,
          equals(
            const Left<Failure, Note>(
              GeneralFailure(message: 'Exception: Something went wrong'),
            ),
          ),
        );
      },
    );
  });

  group('deleteNote', () {
    test(
      'should complete successfully when the call to remote data source is successful',
      () async {
        // arrange
        when(
          remoteDatasource.deleteNote(tId),
        ).thenAnswer((_) async => Future.value());
        // act
        final result = await repository.deleteNote(tId);
        // assert
        verify(remoteDatasource.deleteNote(tId));
        expect(result, equals(const Right<Failure, void>(null)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful due to HttpException',
      () async {
        // arrange
        when(
          remoteDatasource.deleteNote(tId),
        ).thenThrow(const HttpException('Something went wrong'));
        // act
        final result = await repository.deleteNote(tId);
        // assert
        verify(remoteDatasource.deleteNote(tId));
        expect(
          result,
          equals(
            const Left<Failure, void>(
              ServerFailure(message: 'Something went wrong'),
            ),
          ),
        );
      },
    );

    test(
      'should return general failure when the call to remote data source is unsuccessful due to other Exception',
      () async {
        // arrange
        when(
          remoteDatasource.deleteNote(tId),
        ).thenThrow(Exception('Something went wrong'));
        // act
        final result = await repository.deleteNote(tId);
        // assert
        verify(remoteDatasource.deleteNote(tId));
        expect(
          result,
          equals(
            const Left<Failure, void>(
              GeneralFailure(message: 'Exception: Something went wrong'),
            ),
          ),
        );
      },
    );
  });

  group('getAllNotes', () {
    test(
      'should return list of notes when the call to remote data source is successful',
      () async {
        // arrange
        when(
          remoteDatasource.getAllNotes(),
        ).thenAnswer((_) async => tNotesList);
        // act
        final result = await repository.getAllNotes();
        // assert
        verify(remoteDatasource.getAllNotes());
        expect(result, equals(Right<Failure, List<Note>>(tNotesList)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful due to HttpException',
      () async {
        // arrange
        when(
          remoteDatasource.getAllNotes(),
        ).thenThrow(const HttpException('Something went wrong'));
        // act
        final result = await repository.getAllNotes();
        // assert
        verify(remoteDatasource.getAllNotes());
        expect(
          result,
          equals(
            const Left<Failure, List<Note>>(
              ServerFailure(message: 'Something went wrong'),
            ),
          ),
        );
      },
    );

    test(
      'should return general failure when the call to remote data source is unsuccessful due to other Exception',
      () async {
        // arrange
        when(
          remoteDatasource.getAllNotes(),
        ).thenThrow(Exception('Something went wrong'));
        // act
        final result = await repository.getAllNotes();
        // assert
        verify(remoteDatasource.getAllNotes());
        expect(
          result,
          equals(
            const Left<Failure, List<Note>>(
              GeneralFailure(message: 'Exception: Something went wrong'),
            ),
          ),
        );
      },
    );
  });

  group('updateNote', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          remoteDatasource.updateNote(
            id: tId,
            title: tTitle,
            content: tContent,
          ),
        ).thenAnswer((_) async => tNote);
        // act
        final result = await repository.updateNote(
          id: tId,
          title: tTitle,
          content: tContent,
        );
        // assert
        verify(
          remoteDatasource.updateNote(
            id: tId,
            title: tTitle,
            content: tContent,
          ),
        );
        expect(result, equals(Right<Failure, Note>(tNote)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful due to HttpException',
      () async {
        // arrange
        when(
          remoteDatasource.updateNote(
            id: tId,
            title: tTitle,
            content: tContent,
          ),
        ).thenThrow(const HttpException('Something went wrong'));
        // act
        final result = await repository.updateNote(
          id: tId,
          title: tTitle,
          content: tContent,
        );
        // assert
        verify(
          remoteDatasource.updateNote(
            id: tId,
            title: tTitle,
            content: tContent,
          ),
        );
        expect(
          result,
          equals(
            const Left<Failure, Note>(
              ServerFailure(message: 'Something went wrong'),
            ),
          ),
        );
      },
    );

    test(
      'should return general failure when the call to remote data source is unsuccessful due to other Exception',
      () async {
        // arrange
        when(
          remoteDatasource.updateNote(
            id: tId,
            title: tTitle,
            content: tContent,
          ),
        ).thenThrow(Exception('Something went wrong'));
        // act
        final result = await repository.updateNote(
          id: tId,
          title: tTitle,
          content: tContent,
        );
        // assert
        verify(
          remoteDatasource.updateNote(
            id: tId,
            title: tTitle,
            content: tContent,
          ),
        );
        expect(
          result,
          equals(
            const Left<Failure, Note>(
              GeneralFailure(message: 'Exception: Something went wrong'),
            ),
          ),
        );
      },
    );
  });
}
