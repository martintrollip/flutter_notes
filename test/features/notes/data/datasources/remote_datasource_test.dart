// ignore_for_file: lines_longer_than_80_chars, avoid_print

import 'package:flutter_notes/features/notes/data/datasources/remote_datasource.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late RemoteDatasourceImpl dataSource;
  late List<Note> notesListForDataSource;

  const tUuid = Uuid();
  final tNow = DateTime.now();

  Note createTestNote1() => Note(
    id: tUuid.v4(),
    title: 'Test Note 1',
    content: 'Content 1',
    createdAt: tNow,
    updatedAt: tNow,
  );

  Note createTestNote2() => Note(
    id: tUuid.v4(),
    title: 'Test Note 2',
    content: 'Content 2',
    createdAt: tNow.subtract(const Duration(days: 1)),
    updatedAt: tNow.subtract(const Duration(days: 1)),
  );

  setUp(() {
    notesListForDataSource = [];
    dataSource = RemoteDatasourceImpl(source: notesListForDataSource);
  });

  group('getAllNotes', () {
    test(
      'should return all notes from the source list when no server error occurs',
      () async {
        // Arrange
        final note1 = createTestNote1();
        final note2 = createTestNote2();
        notesListForDataSource.addAll([note1, note2]);
        List<Note>? resultNotes;
        Exception? caughtException;

        // Act
        try {
          resultNotes = await dataSource.getAllNotes();
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException == null) {
          expect(resultNotes, equals([note1, note2]));
        } else {
          print(
            'getAllNotes success path test encountered a simulated error: $caughtException',
          );
          expect(caughtException, isA<Exception>());
          expect(
            caughtException.toString(),
            contains('Simulated server error'),
          );
        }
      },
    );

    test(
      'should return an empty list if the source is empty and no server error occurs',
      () async {
        // Arrange
        List<Note>? resultNotes;
        Exception? caughtException;

        // Act
        try {
          resultNotes = await dataSource.getAllNotes();
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException == null) {
          expect(resultNotes, isEmpty);
        } else {
          print(
            'getAllNotes empty list test encountered a simulated error: $caughtException',
          );
          expect(caughtException, isA<Exception>());
          expect(
            caughtException.toString(),
            contains('Simulated server error'),
          );
        }
      },
    );
  });

  group('createNote', () {
    const tTitle = 'New Note Title';
    const tContent = 'New Note Content';

    test(
      'should add the new note to the source list and return it when no server error occurs',
      () async {
        // Arrange
        Note? createdNote;
        Exception? caughtException;

        // Act
        try {
          createdNote = await dataSource.createNote(
            title: tTitle,
            content: tContent,
          );
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException == null && createdNote != null) {
          expect(createdNote.title, tTitle);
          expect(createdNote.content, tContent);
          expect(notesListForDataSource, contains(createdNote));
          expect(notesListForDataSource.length, 1);
        } else {
          print(
            'createNote success path test encountered a simulated error: $caughtException',
          );
          if (caughtException != null) {
            expect(caughtException, isA<Exception>());
            expect(
              caughtException.toString(),
              contains('Simulated server error'),
            );
          }
          if (caughtException == null && createdNote == null) {
            fail('createdNote was null without an exception being caught.');
          }
        }
      },
    );
  });

  group('updateNote', () {
    late Note noteToUpdateInList;

    setUp(() {
      noteToUpdateInList = createTestNote1();
      notesListForDataSource.add(noteToUpdateInList);
    });

    test(
      'should update the existing note in the source list and return it when no server error occurs',
      () async {
        // Arrange
        final updatedDetails = noteToUpdateInList.copyWith(
          title: 'Updated Title',
          content: 'Updated Content',
        );
        Note? resultNote;
        Exception? caughtException;

        // Act
        try {
          resultNote = await dataSource.updateNote(updatedDetails);
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException == null && resultNote != null) {
          expect(resultNote.id, noteToUpdateInList.id);
          expect(resultNote.title, 'Updated Title');
          expect(resultNote.content, 'Updated Content');
          expect(
            resultNote.updatedAt,
            isNot(equals(noteToUpdateInList.updatedAt)),
          );

          final noteInSource = notesListForDataSource.firstWhere(
            (n) => n.id == noteToUpdateInList.id,
          );
          expect(noteInSource.title, 'Updated Title');
          expect(noteInSource.content, 'Updated Content');
        } else {
          print(
            'updateNote success path test encountered a simulated error: $caughtException',
          );
          if (caughtException != null) {
            expect(caughtException, isA<Exception>());
            expect(
              caughtException.toString(),
              contains('Simulated server error'),
            );
          }
          if (caughtException == null && resultNote == null) {
            fail('resultNote was null without an exception being caught.');
          }
        }
      },
    );

    test(
      'should throw an Exception if the note to update is not found and no server error occurs first',
      () async {
        // Arrange
        final nonExistentNote = createTestNote1().copyWith(
          id: 'non-existent-id',
        );
        Exception? caughtException;

        // Act
        try {
          await dataSource.updateNote(nonExistentNote);
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException != null) {
          if (caughtException.toString().contains(
            'Note with ID ${nonExistentNote.id} not found',
          )) {
            expect(
              caughtException.toString(),
              contains('Note with ID ${nonExistentNote.id} not found'),
            );
          } else {
            print(
              'updateNote not found test encountered a simulated server error: $caughtException',
            );
            expect(
              caughtException.toString(),
              contains('Simulated server error'),
            );
          }
        } else {
          fail(
            'Expected an Exception for note not found, but none was thrown.',
          );
        }
      },
    );
  });

  group('deleteNote', () {
    late Note noteToDeleteFromList;

    setUp(() {
      noteToDeleteFromList = createTestNote1();
      notesListForDataSource.add(noteToDeleteFromList);
    });

    test(
      'should remove the note from the source list when no server error occurs',
      () async {
        // Arrange
        final initialCount = notesListForDataSource.length;
        Exception? caughtException;

        // Act
        try {
          await dataSource.deleteNote(noteToDeleteFromList.id);
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException == null) {
          expect(
            notesListForDataSource
                .where((n) => n.id == noteToDeleteFromList.id)
                .isEmpty,
            isTrue,
          );
          expect(notesListForDataSource.length, initialCount - 1);
        } else {
          print(
            'deleteNote success path test encountered a simulated error: $caughtException',
          );
          expect(caughtException, isA<Exception>());
          expect(
            caughtException.toString(),
            contains('Simulated server error'),
          );
          expect(
            notesListForDataSource // Note should still be there if error was before logic
                .where((n) => n.id == noteToDeleteFromList.id)
                .isNotEmpty,
            isTrue,
          );
        }
      },
    );

    test(
      'should throw an Exception if the note to delete is not found and no server error occurs first',
      () async {
        // Arrange
        const nonExistentId = 'non-existent-id';
        Exception? caughtException;

        // Act
        try {
          await dataSource.deleteNote(nonExistentId);
        } on Exception catch (e) {
          caughtException = e;
        }

        // Assert
        if (caughtException != null) {
          if (caughtException.toString().contains(
            'Note with ID $nonExistentId not found',
          )) {
            expect(
              caughtException.toString(),
              contains('Note with ID $nonExistentId not found'),
            );
          } else {
            print(
              'deleteNote not found test encountered a simulated server error: $caughtException',
            );
            expect(
              caughtException.toString(),
              contains('Simulated server error'),
            );
          }
        } else {
          fail(
            'Expected an Exception for note not found, but none was thrown.',
          );
        }
      },
    );
  });

  group('Simulated Server Error', () {
    test(
      'any method should be capable of throwing a "Simulated server error" Exception',
      () async {
        var errorCaught = false;
        const attempts = 25;

        for (var i = 0; i < attempts; i++) {
          final freshList = <Note>[createTestNote1()];
          final freshDataSource = RemoteDatasourceImpl(source: freshList);
          try {
            await freshDataSource.getAllNotes();
          } on Exception catch (e) {
            if (e.toString().contains('Simulated server error')) {
              errorCaught = true;
              break;
            }
          }
        }

        if (!errorCaught) {
          print(
            'Warning: Simulated server error was not caught in $attempts attempts. This is probabilistic.',
          );
        }
        expect(
          errorCaught,
          isTrue,
          reason:
              "Expected to catch a 'Simulated server error' within $attempts attempts, but didn't. This is due to the 10% chance and may occasionally fail this assertion.",
        );
      },
    );
  });
}
