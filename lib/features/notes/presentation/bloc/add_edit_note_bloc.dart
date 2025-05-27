import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_edit_note_event.dart';
part 'add_edit_note_state.dart';
part 'add_edit_note_bloc.freezed.dart';

class AddEditNoteBloc extends Bloc<AddEditNoteEvent, AddEditNoteState> {
  AddEditNoteBloc({
    required CreateNote createNote,
    required UpdateNote updateNote,
    Note? initialNote,
  }) : _createNote = createNote,
       _updateNote = updateNote,
       super(
         initialNote != null
             ? AddEditNoteState(
               initialNote: initialNote,
               title: initialNote.title,
               description: initialNote.content,
               isFormValid: true,
             )
             : const AddEditNoteState(),
       ) {
    on<_TitleChanged>(_onTitleChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_SaveNotePressed>(_onSaveNotePressed);
  }

  final CreateNote _createNote;
  final UpdateNote _updateNote;

  void _onTitleChanged(_TitleChanged event, Emitter<AddEditNoteState> emit) {
    emit(
      state.copyWith(
        title: event.title,
        isFormValid: event.title.isNotEmpty,
        status: AddEditNoteStatus.initial,
      ),
    );
  }

  void _onDescriptionChanged(
    _DescriptionChanged event,
    Emitter<AddEditNoteState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        status: AddEditNoteStatus.initial,
      ),
    );
  }

  Future<void> _onSaveNotePressed(
    _SaveNotePressed event,
    Emitter<AddEditNoteState> emit,
  ) async {
    if (!state.isFormValid) {
      // TODO Martin show validation error
      return;
    }

    emit(state.copyWith(status: AddEditNoteStatus.saving));

    final noteToSave = Note(
      id: state.initialNote?.id ?? '',
      title: state.title,
      content: state.description,
      createdAt: state.initialNote?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (state.isEditing) {
      final failureOrSuccess = await _updateNote(
        UpdateNoteParams(
          id: noteToSave.id,
          title: noteToSave.title,
          content: noteToSave.content,
        ),
      );
      failureOrSuccess.fold(
        (failure) => emit(
          state.copyWith(
            status: AddEditNoteStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(state.copyWith(status: AddEditNoteStatus.success)),
      );
    } else {
      final failureOrSuccess = await _createNote(
        CreateNoteParams(title: noteToSave.title, content: noteToSave.content),
      );
      failureOrSuccess.fold(
        (failure) => emit(
          state.copyWith(
            status: AddEditNoteStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(state.copyWith(status: AddEditNoteStatus.success)),
      );
    }
  }
}
