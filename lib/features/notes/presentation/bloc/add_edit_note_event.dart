part of 'add_edit_note_bloc.dart';

@freezed
abstract class AddEditNoteEvent with _$AddEditNoteEvent {
  const factory AddEditNoteEvent.titleChanged(String title) = _TitleChanged;
  const factory AddEditNoteEvent.descriptionChanged(String description) =
      _DescriptionChanged;
  const factory AddEditNoteEvent.save() = _SaveNotePressed;
}
