part of 'add_edit_note_bloc.dart';

enum AddEditNoteStatus { initial, loading, saving, success, error }

@freezed
abstract class AddEditNoteState with _$AddEditNoteState {
  const factory AddEditNoteState({
    Note? initialNote,
    @Default('') String title,
    @Default('') String description,
    @Default(false) bool isFormValid,
    @Default(AddEditNoteStatus.initial) AddEditNoteStatus status,
    String? errorMessage,
  }) = _AddEditNoteState;

  const AddEditNoteState._();

  bool get isEditing => initialNote != null;
}
