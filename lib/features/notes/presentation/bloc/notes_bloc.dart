import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/core/core.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_event.dart';
part 'notes_state.dart';
part 'notes_bloc.freezed.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({required this.getNotes, required this.deleteNote})
    : super(const NotesState()) {
    {
      on<_GetAllNotes>(_onGetAllNotes);
      on<_DeleteNote>(_onDeleteNote);
      on<_RefreshNotes>(_onRefreshNotes);
    }
  }

  final GetNotes getNotes;
  final DeleteNote deleteNote;

  Future<void> _onGetAllNotes(
    _GetAllNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: NotesListStatus.loading));

    final failureOrNotes = await getNotes(NoParams());
    failureOrNotes.fold(
      (failure) => emit(
        state.copyWith(
          status: NotesListStatus.failure,
          errorMessage: mapFailureToMessage(failure, 'load notes'),
        ),
      ),
      (notes) {
        final status =
            notes.isEmpty ? NotesListStatus.empty : NotesListStatus.success;
        emit(state.copyWith(status: status, notes: notes));
      },
    );
  }

  Future<void> _onDeleteNote(
    _DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: NotesListStatus.loading));

    final failureOrSuccess = await deleteNote(
      DeleteNoteParams(id: event.noteId),
    );

    failureOrSuccess.fold(
      (failure) => emit(
        state.copyWith(
          status: NotesListStatus.failure,
          errorMessage: mapFailureToMessage(failure, 'delete note'),
        ),
      ),
      (deleted) => add(const _GetAllNotes()),
    );
  }

  Future<void> _onRefreshNotes(_RefreshNotes _, Emitter<NotesState> _) async =>
      add(const _GetAllNotes());

  @visibleForTesting
  String mapFailureToMessage(Failure failure, String action) {
    switch (failure) {
      case ServerFailure(:final message):
        return 'Unable to $action due to server failure: $message';
      case CacheFailure(:final message):
        return 'Unable to $action due to cache failure: $message';
      case GeneralFailure(:final message):
        return 'Something went wrong while trying to $action: $message';
    }
  }
}
