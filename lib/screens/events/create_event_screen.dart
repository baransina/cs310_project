import 'package:flutter/material.dart';

import '../../models/study_event.dart';
import '../../theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  static const List<int> _durations = [30, 60, 90, 120, 180];

  String _course = myCourses.first;
  String _location = campusLocations.first;
  late DateTime _date;
  late TimeOfDay _time;
  int _duration = 90;
  int _maxParticipants = 6;
  EventVisibility _visibility = EventVisibility.course;
  String? _timeError;

  @override
  void initState() {
    super.initState();
    final next = DateTime.now().add(const Duration(hours: 1));
    _date = DateTime(next.year, next.month, next.day);
    _time = TimeOfDay(hour: next.hour, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  DateTime get _start =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(context: context, initialTime: _time);
    if (pickedTime == null) return;

    setState(() {
      _date = pickedDate;
      _time = pickedTime;
      _timeError = null;
    });
  }

  void _submit() {
    final formOk = _formKey.currentState!.validate();
    final timeOk = _start.isAfter(DateTime.now());
    setState(() => _timeError = timeOk ? null : 'Pick a time in the future');
    if (!formOk || !timeOk) return;

    final title = _titleController.text.trim();
    final event = StudyEvent(
      eventId: 'e${DateTime.now().millisecondsSinceEpoch}',
      hostId: currentUserId,
      hostName: currentUserName,
      title: title.isEmpty ? '$_course Study Session' : title,
      courseCode: _course,
      location: _location,
      dateTime: _start,
      durationMinutes: _duration,
      maxParticipants: _maxParticipants,
      visibility: _visibility,
      note: _noteController.text.trim(),
      attendeeIds: [currentUserId],
    );
    Navigator.pop(context, event);
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 6),
        child: Text(text, style: AppText.label),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        leadingWidth: 90,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        centerTitle: true,
        title: const Text('Host a session', style: AppText.section),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.page, 0, AppSpacing.page, AppSpacing.lg),
            children: [
              _label('Course'),
              DropdownButtonFormField<String>(
                initialValue: _course,
                decoration: appInputDecoration(),
                items: [
                  for (final c in myCourses)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => setState(() => _course = v!),
              ),

              _label('Title (optional)'),
              TextFormField(
                controller: _titleController,
                decoration: appInputDecoration(hint: '$_course Study Session'),
                validator: (v) => (v != null && v.trim().length > 40)
                    ? 'Max 40 characters'
                    : null,
              ),

              _label('Location'),
              DropdownButtonFormField<String>(
                initialValue: _location,
                decoration: appInputDecoration(),
                items: [
                  for (final l in campusLocations)
                    DropdownMenuItem(value: l, child: Text(l)),
                ],
                onChanged: (v) => setState(() => _location = v!),
              ),

              _label('Date & time'),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                child: InputDecorator(
                  decoration: appInputDecoration().copyWith(
                    errorText: _timeError,
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                  child: Text(
                    '${formatDay(_start)} · ${formatTime(_start)}',
                    style: AppText.body,
                  ),
                ),
              ),

              _label('Duration'),
              DropdownButtonFormField<int>(
                initialValue: _duration,
                decoration: appInputDecoration(),
                items: [
                  for (final m in _durations)
                    DropdownMenuItem(value: m, child: Text('$m minutes')),
                ],
                onChanged: (v) => setState(() => _duration = v!),
              ),

              _label('Max participants'),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                        child: Text('People including you', style: AppText.small)),
                    IconButton(
                      onPressed: _maxParticipants > 2
                          ? () => setState(() => _maxParticipants--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$_maxParticipants', style: AppText.section),
                    IconButton(
                      onPressed: _maxParticipants < 20
                          ? () => setState(() => _maxParticipants++)
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              _label('Visible to'),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<EventVisibility>(
                  showSelectedIcon: false,
                  segments: [
                    const ButtonSegment(
                        value: EventVisibility.friends, label: Text('Friends')),
                    ButtonSegment(
                        value: EventVisibility.course,
                        label: Text('Everyone in $_course')),
                  ],
                  selected: {_visibility},
                  onSelectionChanged: (s) =>
                      setState(() => _visibility = s.first),
                ),
              ),

              _label('Note (optional)'),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration:
                    appInputDecoration(hint: 'Bring: laptop, lecture slides…'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.md + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
              ),
              child: const Text('Create session'),
            ),
          ),
        ),
      ),
    );
  }
}
