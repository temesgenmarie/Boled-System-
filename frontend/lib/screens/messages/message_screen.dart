import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/message_model.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/providers/messages_provider.dart';
import 'package:admin_app/widgets/modals/success_modal.dart';
import 'package:admin_app/widgets/modals/error_modal.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  MessageType _selectedType = MessageType.announcement;
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;
  DateTime? _scheduledTime;
  bool _sendToAll = true;
  Set<String> _selectedRecipients = {};

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _handleSendMessage() async {
    if (_bodyController.text.isEmpty) {
      showErrorModal(context, 'Message body is required');
      return;
    }

    final recipientIds = _sendToAll
        ? <String>[] // In real app, fetch all member IDs
        : _selectedRecipients.toList();

    final message = Message(
      id: const Uuid().v4(),
      type: _selectedType,
      subject: _subjectController.text.isEmpty ? null : _subjectController.text,
      body: _bodyController.text,
      recipientIds: recipientIds,
      sentAt: DateTime.now(),
      scheduledFor: _scheduledTime,
      isScheduled: _scheduledTime != null,
      status: 'pending',
    );

    try {
      await ref.read(messageHistoryProvider.notifier).sendMessage(message);
      showSuccessModal(context, 'Message sent successfully', () {
        _subjectController.clear();
        _bodyController.clear();
        _scheduledTime = null;
        _selectedRecipients.clear();
      });
    } catch (e) {
      showErrorModal(context, 'Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Send Message')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Message Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<MessageType>(
              segments: const [
                ButtonSegment(label: Text('Announcement'), value: MessageType.announcement),
                ButtonSegment(label: Text('Funeral'), value: MessageType.funeral),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<MessageType> newSelection) {
                setState(() => _selectedType = newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject (Optional)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Message Body *',
                hintText: 'Enter your message',
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            const Text(
              'Recipients',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Send to all members'),
              value: _sendToAll,
              onChanged: (value) => setState(() => _sendToAll = value ?? true),
            ),
            if (!_sendToAll)
              membersAsync.when(
                data: (members) {
                  return Column(
                    children: members
                        .map((member) => CheckboxListTile(
                              title: Text(member.fullName),
                              value: _selectedRecipients.contains(member.id),
                              onChanged: (value) {
                                setState(() {
                                  if (value ?? false) {
                                    _selectedRecipients.add(member.id);
                                  } else {
                                    _selectedRecipients.remove(member.id);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
              ),
            const SizedBox(height: 24),
            const Text(
              'Schedule (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Send at'),
              subtitle: Text(
                _scheduledTime?.toString() ?? 'Now',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _scheduledTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSendMessage,
                child: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
