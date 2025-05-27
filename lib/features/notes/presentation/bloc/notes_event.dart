part of 'notes_bloc.dart';

@freezed
abstract class NotesEvent with _$NotesEvent {
  const factory NotesEvent.getAllNotes() = _GetAllNotes;
  const factory NotesEvent.deleteNote({required String noteId}) = _DeleteNote;
  const factory NotesEvent.refreshNotes() = _RefreshNotes;
}
