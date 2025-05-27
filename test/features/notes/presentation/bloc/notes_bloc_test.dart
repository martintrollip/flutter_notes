// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/constants.dart';
import 'notes_usecases.mocks.dart' show MockDeleteNote, MockGetNotes;

void main() {
  late NotesBloc notesBloc;
  late GetNotes getNotes;
  late DeleteNote deleteNote;

  setUp(() {
    getNotes = MockGetNotes();
    deleteNote = MockDeleteNote();
    notesBloc = NotesBloc(getNotes: getNotes, deleteNote: deleteNote);
  });

  tearDown(() {
    notesBloc.close();
  });

  group('NotesBloc', () {
    test('initial state is correct', () {
      expect(notesBloc.state, const NotesState());
    });

    group('GetAllNotesEvent', () {
      blocTest<NotesBloc, NotesState>(
        'emits [loading, success] when GetNotes returns data',
        build: () {
          when(getNotes(NoParams())).thenAnswer((_) async => Right(tNotesList));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.getAllNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(status: NotesListStatus.success, notes: tNotesList),
            ],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [loading, empty] when GetNotes returns empty list',
        build: () {
          when(getNotes(NoParams())).thenAnswer((_) async => const Right([]));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.getAllNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              const NotesState(status: NotesListStatus.empty, notes: []),
            ],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [loading, failure] when GetNotes returns server failure',
        build: () {
          when(
            getNotes(NoParams()),
          ).thenAnswer((_) async => const Left(tFailureServer));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.getAllNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(
                status: NotesListStatus.failure,
                errorMessage: notesBloc.mapFailureToMessage(
                  tFailureServer,
                  'load notes',
                ),
              ),
            ],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [loading, failure] when GetNotes returns cache failure',
        build: () {
          when(
            getNotes(NoParams()),
          ).thenAnswer((_) async => const Left(tFailureCache));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.getAllNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(
                status: NotesListStatus.failure,
                errorMessage: notesBloc.mapFailureToMessage(
                  tFailureCache,
                  'load notes',
                ),
              ),
            ],
      );
      blocTest<NotesBloc, NotesState>(
        'emits [loading, failure] when GetNotes returns general failure',
        build: () {
          when(
            getNotes(NoParams()),
          ).thenAnswer((_) async => const Left(tFailureGeneral));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.getAllNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(
                status: NotesListStatus.failure,
                errorMessage: notesBloc.mapFailureToMessage(
                  tFailureGeneral,
                  'load notes',
                ),
              ),
            ],
      );
    });

    group('DeleteNoteEvent', () {
      final tDeleteParams = DeleteNoteParams(id: tNote.id);
      blocTest<NotesBloc, NotesState>(
        'emits [loading, loading, success] after successful deletion and re-fetching notes',
        build: () {
          when(
            deleteNote(tDeleteParams),
          ).thenAnswer((_) async => const Right(null));
          when(getNotes(NoParams())).thenAnswer((_) async => Right(tNotesList));
          return notesBloc;
        },
        act:
            (NotesBloc bloc) =>
                bloc.add(NotesEvent.deleteNote(noteId: tNote.id)),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(status: NotesListStatus.success, notes: tNotesList),
            ],
        verify: (_) {
          verify(deleteNote(tDeleteParams)).called(1);
          verify(getNotes(NoParams())).called(1);
        },
      );

      blocTest<NotesBloc, NotesState>(
        'emits [loading, failure] when DeleteNote returns failure',
        build: () {
          when(
            deleteNote(tDeleteParams),
          ).thenAnswer((_) async => const Left(tFailureServer));
          return notesBloc;
        },
        act:
            (NotesBloc bloc) =>
                bloc.add(NotesEvent.deleteNote(noteId: tNote.id)),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(
                status: NotesListStatus.failure,
                errorMessage: notesBloc.mapFailureToMessage(
                  tFailureServer,
                  'delete note',
                ),
              ),
            ],
        verify: (_) {
          verify(deleteNote(tDeleteParams)).called(1);
          verifyNever(getNotes(NoParams()));
        },
      );
    });

    group('RefreshNotesEvent', () {
      blocTest<NotesBloc, NotesState>(
        'emits [loading, success] when GetNotes returns data on refresh',
        build: () {
          when(getNotes(NoParams())).thenAnswer((_) async => Right(tNotesList));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.refreshNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(status: NotesListStatus.success, notes: tNotesList),
            ],
      );

      blocTest<NotesBloc, NotesState>(
        'emits [loading, failure] when GetNotes returns failure on refresh',
        build: () {
          when(
            getNotes(NoParams()),
          ).thenAnswer((_) async => const Left(tFailureServer));
          return notesBloc;
        },
        act: (NotesBloc bloc) => bloc.add(const NotesEvent.refreshNotes()),
        expect:
            () => [
              const NotesState(status: NotesListStatus.loading),
              NotesState(
                status: NotesListStatus.failure,
                errorMessage: notesBloc.mapFailureToMessage(
                  tFailureServer,
                  'load notes',
                ),
              ),
            ],
      );
    });
  });
}
