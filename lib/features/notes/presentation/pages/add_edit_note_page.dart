import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/add_edit_note_bloc.dart';
import 'package:flutter_notes/injection_container.dart';

class AddEditNotePage extends StatelessWidget {
  const AddEditNotePage({super.key, this.note});

  final Note? note;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddEditNoteBloc>(param1: note),
      child: const _AddEditNoteView(),
    );
  }
}

class _AddEditNoteView extends StatelessWidget {
  const _AddEditNoteView();

  @override
  Widget build(BuildContext context) {
    return AddEditNoteScaffoldListener(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<AddEditNoteBloc, AddEditNoteState>(
            builder: (_, state) {
              return Text(state.isEditing ? 'Edit Note' : 'Add Note');
            },
          ),
          actions: [
            BlocBuilder<AddEditNoteBloc, AddEditNoteState>(
              builder: (context, state) {
                if (state.status == AddEditNoteStatus.saving) {
                  return const _Loader();
                }
                return _SaveButton(
                  enable:
                      state.isFormValid &&
                      state.status != AddEditNoteStatus.saving,
                );
              },
            ),
          ],
        ),
        body: const _AddEditNoteForm(),
      ),
    );
  }
}

class _AddEditNoteForm extends StatefulWidget {
  const _AddEditNoteForm();

  @override
  State<_AddEditNoteForm> createState() => _AddEditNoteFormState();
}

class _AddEditNoteFormState extends State<_AddEditNoteForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final initialState = context.read<AddEditNoteBloc>().state;
    _titleController = TextEditingController(text: initialState.title);
    _descriptionController = TextEditingController(
      text: initialState.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEditNoteBloc, AddEditNoteState>(
      listenWhen: (previous, current) {
        return previous.title != current.title ||
            previous.description != current.description;
      },
      listener: (context, state) {
        if (state.title != _titleController.text) {
          _titleController.text = state.title;
        }
        if (state.description != _descriptionController.text) {
          _descriptionController.text = state.description;
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter note title',
                ),
                onChanged: (value) {
                  context.read<AddEditNoteBloc>().add(
                    AddEditNoteEvent.titleChanged(value),
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Enter note description',
                  alignLabelWithHint: true,
                ),
                onChanged: (value) {
                  context.read<AddEditNoteBloc>().add(
                    AddEditNoteEvent.descriptionChanged(value),
                  );
                },
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A button to save or update a note.
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.enable});

  final bool enable;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(16),
      icon: const Icon(Icons.save_outlined),
      tooltip: 'Save Note',
      onPressed:
          enable
              ? () {
                context.read<AddEditNoteBloc>().add(
                  const AddEditNoteEvent.save(),
                );
              }
              : null,
    );
  }
}

/// A simple loader widget to show while saving or updating a note.
class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

/// Show a snack bar with the result of saving or updating a note.
class AddEditNoteScaffoldListener
    extends BlocListener<AddEditNoteBloc, AddEditNoteState> {
  AddEditNoteScaffoldListener({super.child, super.key})
    : super(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == AddEditNoteStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.isEditing
                        ? 'Note updated successfully!'
                        : 'Note saved successfully!',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            if (Navigator.canPop(context)) {
              // context.read<NotesBloc>().add(const NotesEvent.refreshNotes());
              Navigator.of(context).pop(true);
            }
          } else if (state.status == AddEditNoteStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'An unknown error occurred.',
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
      );
}
