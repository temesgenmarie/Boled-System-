import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/message_model.dart';
import 'package:admin_app/providers/messages_provider.dart';

class MessageHistoryScreen extends ConsumerStatefulWidget {
  const MessageHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageHistoryScreen> createState() =>
      _MessageHistoryScreenState();
}

class _MessageHistoryScreenState extends ConsumerState<MessageHistoryScreen> {
  MessageType? _filterType;

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messageHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Message History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<MessageType?>(
              segments: const [
                ButtonSegment(label: Text('All'), value: null),
                ButtonSegment(label: Text('Announcement'), value: MessageType.announcement),
                ButtonSegment(label: Text('Funeral'), value: MessageType.funeral),
              ],
              selected: {_filterType},
              onSelectionChanged: (Set<MessageType?> newSelection) {
                setState(() => _filterType = newSelection.first);
                ref.read(messageHistoryProvider.notifier).fetchHistory(
                      type: _filterType,
                    );
              },
            ),
          ),
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                final filtered = _filterType == null
                    ? messages
                    : messages.where((m) => m.type == _filterType).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No messages found'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final message = filtered[index];
                    return ListTile(
                      title: Text(message.subject ?? 'No Subject'),
                      subtitle: Text(
                        '${message.type.name} • ${message.sentAt.toString().split('.')[0]}',
                      ),
                      trailing: Chip(
                        label: Text(message.status),
                        backgroundColor: message.status == 'sent'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      onTap: () => _showMessageDetail(context, message),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageDetail(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Type: ${message.type.name}'),
              const SizedBox(height: 8),
              Text('Subject: ${message.subject ?? 'N/A'}'),
              const SizedBox(height: 8),
              Text('Body: ${message.body}'),
              const SizedBox(height: 8),
              Text('Recipients: ${message.recipientIds.length}'),
              const SizedBox(height: 8),
              Text('Sent: ${message.sentAt}'),
              const SizedBox(height: 8),
              Text('Status: ${message.status}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
