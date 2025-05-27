// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/add_edit_note_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/constants.dart';
import 'notes_usecases.mocks.dart';

void main() {
  late MockCreateNote createNote;
  late MockUpdateNote updateNote;
  late AddEditNoteBloc addEditNoteBloc;

  setUp(() {
    createNote = MockCreateNote();
    updateNote = MockUpdateNote();
  });

  group('AddEditNoteBloc', () {
    group('constructor', () {
      test('initial state is correct for a new note', () {
        addEditNoteBloc = AddEditNoteBloc(
          createNote: createNote,
          updateNote: updateNote,
        );
        expect(addEditNoteBloc.state, const AddEditNoteState());
      });

      test('initial state is correct for an existing note', () {
        addEditNoteBloc = AddEditNoteBloc(
          createNote: createNote,
          updateNote: updateNote,
          initialNote: tNote,
        );
        expect(
          addEditNoteBloc.state,
          AddEditNoteState(
            initialNote: tNote,
            title: tNote.title,
            description: tNote.content,
            isFormValid: true,
          ),
        );
      });
    });

    group('TitleChanged', () {
      blocTest<AddEditNoteBloc, AddEditNoteState>(
        'emits state with updated title and validates form',
        build: () {
          return AddEditNoteBloc(
            createNote: createNote,
            updateNote: updateNote,
          );
        },
        act: (bloc) {
          bloc.add(const AddEditNoteEvent.titleChanged('New Title'));
        },
        expect:
            () => [
              const AddEditNoteState(
                title: 'New Title',
                isFormValid: true,
                status: AddEditNoteStatus.initial,
              ),
            ],
      );

      blocTest<AddEditNoteBloc, AddEditNoteState>(
        'emits state with updated title and invalidates form for empty title',
        build: () {
          return AddEditNoteBloc(
            createNote: createNote,
            updateNote: updateNote,
            initialNote: tNote.copyWith(title: 'Non-empty'),
          );
        },
        act: (bloc) => bloc.add(const AddEditNoteEvent.titleChanged('')),
        expect:
            () => [
              AddEditNoteState(
                initialNote: tNote.copyWith(title: 'Non-empty'),
                title: '',
                description: tNote.content,
                isFormValid: false,
                status: AddEditNoteStatus.initial,
              ),
            ],
      );
    });

    group('DescriptionChanged', () {
      blocTest<AddEditNoteBloc, AddEditNoteState>(
        'emits state with updated description',
        build: () {
          return AddEditNoteBloc(
            createNote: createNote,
            updateNote: updateNote,
          );
        },
        act: (bloc) {
          bloc.add(
            const AddEditNoteEvent.descriptionChanged('New Description'),
          );
        },
        expect:
            () => [
              const AddEditNoteState(
                description: 'New Description',
                status: AddEditNoteStatus.initial,
              ),
            ],
      );
    });

    group('SaveNote', () {
      const newTitle = 'New Title';
      const newDescription = 'New Content';

      group('when creating a new note', () {
        setUp(() {
          addEditNoteBloc =
              AddEditNoteBloc(createNote: createNote, updateNote: updateNote)
                ..add(const AddEditNoteEvent.titleChanged(newTitle))
                ..add(
                  const AddEditNoteEvent.descriptionChanged(newDescription),
                );
        });

        blocTest<AddEditNoteBloc, AddEditNoteState>(
          'emits [saving, success] when note creation is successful',
          setUp: () {
            when(createNote.call(any)).thenAnswer(
              (_) async => Right(
                tNote.copyWith(title: newTitle, content: newDescription),
              ),
            );
          },
          build: () => addEditNoteBloc,
          act: (bloc) => bloc.add(const AddEditNoteEvent.save()),
          expect:
              () => [
                const AddEditNoteState(
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.saving,
                ),
                const AddEditNoteState(
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.success,
                ),
              ],
          verify: (_) {
            verify(
              createNote.call(
                const CreateNoteParams(
                  title: newTitle,
                  content: newDescription,
                ),
              ),
            ).called(1);
          },
        );

        blocTest<AddEditNoteBloc, AddEditNoteState>(
          'emits [saving, error] when note creation fails',
          setUp: () {
            when(createNote.call(any)).thenAnswer(
              (_) async =>
                  const Left(ServerFailure(message: 'Creation Failed')),
            );
          },
          build: () => addEditNoteBloc,
          act: (bloc) => bloc.add(const AddEditNoteEvent.save()),
          expect:
              () => [
                const AddEditNoteState(
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.saving,
                ),
                const AddEditNoteState(
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.error,
                  errorMessage: 'Creation Failed',
                ),
              ],
          verify: (_) {
            verify(
              createNote.call(
                const CreateNoteParams(
                  title: newTitle,
                  content: newDescription,
                ),
              ),
            ).called(1);
          },
        );
      });

      group('when updating an existing note', () {
        final updatedNote = tNote.copyWith(
          title: newTitle,
          content: newDescription,
        );
        setUp(() {
          addEditNoteBloc =
              AddEditNoteBloc(
                  createNote: createNote,
                  updateNote: updateNote,
                  initialNote: tNote,
                )
                ..add(const AddEditNoteEvent.titleChanged(newTitle))
                ..add(
                  const AddEditNoteEvent.descriptionChanged(newDescription),
                );
        });

        blocTest<AddEditNoteBloc, AddEditNoteState>(
          'emits [saving, success] when note update is successful',
          setUp: () {
            when(
              updateNote.call(any),
            ).thenAnswer((_) async => Right(updatedNote));
          },
          build: () => addEditNoteBloc,
          act: (bloc) => bloc.add(const AddEditNoteEvent.save()),
          expect:
              () => [
                AddEditNoteState(
                  initialNote: tNote,
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.saving,
                ),
                AddEditNoteState(
                  initialNote: tNote,
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.success,
                ),
              ],
          verify: (_) {
            verify(
              updateNote.call(
                UpdateNoteParams(
                  id: tNote.id,
                  title: newTitle,
                  content: newDescription,
                ),
              ),
            ).called(1);
          },
        );

        blocTest<AddEditNoteBloc, AddEditNoteState>(
          'emits [saving, error] when note update fails',
          setUp: () {
            when(updateNote.call(any)).thenAnswer(
              (_) async => const Left(ServerFailure(message: 'Update Failed')),
            );
          },
          build: () => addEditNoteBloc,
          act: (bloc) => bloc.add(const AddEditNoteEvent.save()),
          expect:
              () => [
                AddEditNoteState(
                  initialNote: tNote,
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.saving,
                ),
                AddEditNoteState(
                  initialNote: tNote,
                  title: newTitle,
                  description: newDescription,
                  isFormValid: true,
                  status: AddEditNoteStatus.error,
                  errorMessage: 'Update Failed',
                ),
              ],
          verify: (_) {
            verify(
              updateNote.call(
                UpdateNoteParams(
                  id: tNote.id,
                  title: newTitle,
                  content: newDescription,
                ),
              ),
            ).called(1);
          },
        );
      });

      blocTest<AddEditNoteBloc, AddEditNoteState>(
        'does not emit new states if form is invalid',
        build: () {
          return AddEditNoteBloc(createNote: createNote, updateNote: updateNote)
            ..add(const AddEditNoteEvent.titleChanged(''));
        },
        act: (bloc) => bloc.add(const AddEditNoteEvent.save()),
        expect: () => <AddEditNoteState>[],
        verify: (_) {
          verifyNever(createNote.call(any));
          verifyNever(updateNote.call(any));
        },
        skip: 1,
      );
    });
  });
}
