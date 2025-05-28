part of 'notes_bloc.dart';

enum NotesListStatus { initial, loading, success, empty, failure }

@freezed
abstract class NotesState with _$NotesState {
  const factory NotesState({
    @Default(NotesListStatus.initial) NotesListStatus status,
    List<Note>? notes,
    String? errorMessage,
  }) = _NotesState;
}
