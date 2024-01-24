// add_tornament_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tornament_temp/modals/tornament.dart';
import 'package:tornament_temp/state/tournament_provider.dart';

class AddTornamentScreen extends StatefulWidget {
  final Tournament? tournamentToEdit;

  const AddTornamentScreen({Key? key, this.tournamentToEdit}) : super(key: key);

  @override
  State<AddTornamentScreen> createState() => _AddTornamentScreenState();
}

class _AddTornamentScreenState extends State<AddTornamentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedType;
  String? _selectedSubType;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Populate form fields if editing a tournament
    if (widget.tournamentToEdit != null) {
      _titleController.text = widget.tournamentToEdit!.title;
      _venueController.text = widget.tournamentToEdit!.venue;
      _fromDate = widget.tournamentToEdit!.fromDate;
      _toDate = widget.tournamentToEdit!.toDate;
      _selectedType = widget.tournamentToEdit!.type;
      _selectedSubType = widget.tournamentToEdit!.subType;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:
          isFromDate ? _fromDate ?? DateTime.now() : _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = selectedDate;
        } else {
          _toDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tournamentToEdit != null
            ? 'Edit Tournament'
            : 'Add Tournament'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                onChanged: (value) => setState(() => _selectedType = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select some type';
                  }
                  return null;
                },
                items: ['Cricket', 'Badminton', 'Football']
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                hint: const Text('Select Tournament Type'),
              ),
              if (_selectedType == 'Cricket')
                DropdownButtonFormField<String>(
                  value: _selectedSubType,
                  onChanged: (value) =>
                      setState(() => _selectedSubType = value),
                  validator: (value) {
                    if (_selectedType != 'Football' &&
                        (value == null || value.isEmpty)) {
                      return 'Select sub type';
                    }
                    return null;
                  },
                  items: ['Tennis Ball', 'Leather Ball']
                      .map((subType) => DropdownMenuItem(
                          value: subType, child: Text(subType)))
                      .toList(),
                  hint: const Text('Select Cricket SubType'),
                ),
              if (_selectedType == 'Badminton')
                DropdownButtonFormField<String>(
                  value: _selectedSubType,
                  onChanged: (value) =>
                      setState(() => _selectedSubType = value),
                  validator: (value) {
                    if (_selectedType != 'Football' &&
                        (value == null || value.isEmpty)) {
                      return 'Select sub type';
                    }
                    return null;
                  },
                  items: ['Golden Point', 'Continue Point']
                      .map((subType) => DropdownMenuItem(
                          value: subType, child: Text(subType)))
                      .toList(),
                  hint: const Text('Select Badminton SubType'),
                ),
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Tournament Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: 'Venue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter venue';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: const Text('Select From Date'),
              ),
              Text(_fromDate != null
                  ? 'From Date: ${DateFormat('yyyy-MM-dd').format(_fromDate!)}'
                  : ''),
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: const Text('Select To Date'),
              ),
              Text(_toDate != null
                  ? 'To Date: ${DateFormat('yyyy-MM-dd').format(_toDate!)}'
                  : ''),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    final provider =
                        Provider.of<TournamentProvider>(context, listen: false);
                    final tournament = Tournament(
                      id: widget.tournamentToEdit?.id ??
                          '', // Pass the id when editing
                      type: _selectedType!,
                      title: _titleController.text,
                      fromDate: _fromDate!,
                      toDate: _toDate!,
                      venue: _venueController.text,
                      subType: _selectedSubType,
                    );
                    if (widget.tournamentToEdit != null) {
                      // Edit existing tournament
                      // provider.editTournament(tournament);
                    } else {
                      // Add new tournament
                      provider.addTournament(tournament);
                    }
                    Navigator.pop(
                        context); // Navigate back after adding/editing tournament
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
