import 'package:flutter/material.dart';

class AddSchoolRequest {
  AddSchoolRequest({
    required this.schoolName,
    required this.address,
    required this.code,
    required this.boardId,
    this.createdById,
  });

  final String schoolName;
  final String address;
  final String code;
  final int boardId;
  final int? createdById;
}

class AddSchoolDialog extends StatefulWidget {
  const AddSchoolDialog({super.key, this.initial, this.title, this.confirmLabel});

  final AddSchoolRequest? initial;
  final String? title;
  final String? confirmLabel;

  @override
  State<AddSchoolDialog> createState() => _AddSchoolDialogState();
}

class _AddSchoolDialogState extends State<AddSchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _boardCtrl = TextEditingController();
  final _createdByCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _nameCtrl.text = initial.schoolName;
      _addressCtrl.text = initial.address;
      _codeCtrl.text = initial.code;
      _boardCtrl.text = initial.boardId.toString();
      if (initial.createdById != null) {
        _createdByCtrl.text = initial.createdById.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _codeCtrl.dispose();
    _boardCtrl.dispose();
    _createdByCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'Add School'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'School name',
                  hintText: 'Sunshine Public School',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter a school name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: '456 Park Avenue, Mumbai',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter an address' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  hintText: 'SPS001',
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? 'Enter a code' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _boardCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Board ID',
                  hintText: '1',
                ),
                validator: (v) {
                  final trimmed = (v ?? '').trim();
                  if (trimmed.isEmpty) return 'Enter a board ID';
                  final parsed = int.tryParse(trimmed);
                  if (parsed == null) return 'Board ID must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _createdByCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Created by (optional)',
                  hintText: 'Admin user ID',
                ),
                validator: (v) {
                  final trimmed = (v ?? '').trim();
                  if (trimmed.isEmpty) return null;
                  if (int.tryParse(trimmed) == null) {
                    return 'Must be a number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final boardId = int.parse(_boardCtrl.text.trim());
            final createdByText = _createdByCtrl.text.trim();
            final createdById =
                createdByText.isEmpty ? null : int.tryParse(createdByText);
            Navigator.of(context).pop(
              AddSchoolRequest(
                schoolName: _nameCtrl.text.trim(),
                address: _addressCtrl.text.trim(),
                code: _codeCtrl.text.trim(),
                boardId: boardId,
                createdById: createdById,
              ),
            );
          },
          child: Text(widget.confirmLabel ?? 'Add'),
        ),
      ],
    );
  }
}
