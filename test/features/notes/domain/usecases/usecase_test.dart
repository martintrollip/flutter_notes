// ignore_for_file: lines_longer_than_80_chars

import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([NotesRepository])
import 'usecase_test.mocks.dart';

void main() {
  late NotesRepository repository;

  final tNow = DateTime.now();
  const tTitle = 'Test Note Title';
  const tContent = 'Test Note Content';
  const tCreateParams = CreateNoteParams(title: tTitle, content: tContent);

  final tNote = Note(
    id: '1',
    title: tTitle,
    content: tContent,
    createdAt: tNow,
    updatedAt: tNow,
  );

  setUp(() {
    repository = MockNotesRepository();
  });

  group('CreateNote', () {
    late CreateNote usecase;

    setUp(() {
      usecase = CreateNote(repository);
    });

    test(
      'should create a note from the repository when called successfully',
      () async {
        // Arrange
        when(
          repository.createNote(title: tTitle, content: tContent),
        ).thenAnswer((_) async => Right(tNote));

        // Act
        final result = await usecase(tCreateParams);

        // Assert
        expect(result, Right<Failure, Note>(tNote));
        verify(repository.createNote(title: tTitle, content: tContent));
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should return a Failure from the repository when creation is unsuccessful',
      () async {
        // Arrange
        const tFailure = ServerFailure(message: 'Failed to create note');
        when(
          repository.createNote(title: tTitle, content: tContent),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tCreateParams);

        // Assert
        expect(result, const Left<Failure, Note>(tFailure));
        verify(repository.createNote(title: tTitle, content: tContent));
        verifyNoMoreInteractions(repository);
      },
    );
  });

  group('DeleteNote', () {
    late DeleteNote usecase;

    setUp(() {
      usecase = DeleteNote(repository);
    });

    test(
      'should delete a note from the repository when called successfully',
      () async {
        // Arrange
        const tId = '1';
        when(
          repository.deleteNote(tId),
        ).thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        final result = await usecase(DeleteNoteParams(id: tId));

        // Assert
        expect(result, const Right<Failure, void>(null));
        verify(repository.deleteNote(tId));
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should return a Failure from the repository when deletion is unsuccessful',
      () async {
        // Arrange
        const tId = '1';
        const tFailure = ServerFailure(message: 'Failed to delete note');
        when(
          repository.deleteNote(tId),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(DeleteNoteParams(id: tId));

        // Assert
        expect(result, const Left<Failure, void>(tFailure));
        verify(repository.deleteNote(tId));
        verifyNoMoreInteractions(repository);
      },
    );
  });

  group('UpdateNoe', () {
    late UpdateNote usecase;

    setUp(() {
      usecase = UpdateNote(repository);
    });

    test(
      'should update a note in the repository when called successfully',
      () async {
        // Arrange
        when(
          repository.updateNote(
            id: tNote.id,
            title: tNote.title,
            content: tNote.content,
          ),
        ).thenAnswer((_) async => Right(tNote));

        // Act
        final result = await usecase(
          UpdateNoteParams(
            id: tNote.id,
            title: tNote.title,
            content: tNote.content,
          ),
        );

        // Assert
        expect(result, Right<Failure, Note>(tNote));
        verify(
          repository.updateNote(
            id: tNote.id,
            title: tNote.title,
            content: tNote.content,
          ),
        );
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should return a Failure from the repository when update is unsuccessful',
      () async {
        // Arrange
        const tFailure = ServerFailure(message: 'Failed to update note');
        when(
          repository.updateNote(
            id: tNote.id,
            title: tNote.title,
            content: tNote.content,
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(
          UpdateNoteParams(
            id: tNote.id,
            title: tNote.title,
            content: tNote.content,
          ),
        );

        // Assert
        expect(result, const Left<Failure, Note>(tFailure));
        verify(
          repository.updateNote(
            id: tNote.id,
            title: tNote.title,
            content: tNote.content,
          ),
        );
        verifyNoMoreInteractions(repository);
      },
    );
  });

  group('GetNotes', () {
    late GetNotes usecase;

    setUp(() {
      usecase = GetNotes(repository);
    });

    test(
      'should get all notes from the repository when called successfully',
      () async {
        // Arrange
        when(
          repository.getAllNotes(),
        ).thenAnswer((_) async => Right<Failure, List<Note>>([tNote]));

        // Act
        final result = await usecase(NoParams());

        // Assert
        expect(result.getOrElse(() => throw Exception()), [tNote]);
        verify(repository.getAllNotes());
        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should return a Failure from the repository when getting notes is unsuccessful',
      () async {
        // Arrange
        const tFailure = ServerFailure(message: 'Failed to get notes');
        when(
          repository.getAllNotes(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(NoParams());

        // Assert
        expect(result, const Left<Failure, List<Note>>(tFailure));
        verify(repository.getAllNotes());
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
