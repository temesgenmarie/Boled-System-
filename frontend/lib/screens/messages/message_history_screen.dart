import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/message_model.dart';
import 'package:admin_app/providers/messages_provider.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/theme/app_animations.dart';
import 'package:admin_app/widgets/animated_card.dart';
import 'package:admin_app/widgets/gradient_background.dart';

class MessageHistoryScreen extends ConsumerStatefulWidget {
  const MessageHistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageHistoryScreen> createState() =>
      _MessageHistoryScreenState();
}

class _MessageHistoryScreenState extends ConsumerState<MessageHistoryScreen> {
  MessageType? _filterType;
  String _timePeriod = 'all'; // all, 7days, month, year

  List<Message> _filterByTimePeriod(List<Message> messages) {
    final now = DateTime.now();
    switch (_timePeriod) {
      case '7days':
        return messages.where((m) {
          final diff = now.difference(m.sentAt).inDays;
          return diff <= 7;
        }).toList();
      case 'month':
        return messages.where((m) {
          final diff = now.difference(m.sentAt).inDays;
          return diff <= 30;
        }).toList();
      case 'year':
        return messages.where((m) {
          final diff = now.difference(m.sentAt).inDays;
          return diff <= 365;
        }).toList();
      default:
        return messages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messageHistoryProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message History'),
        elevation: 0,
      ),
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _timePeriod == 'all',
                      onTap: () => setState(() => _timePeriod = 'all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Last 7 Days',
                      isSelected: _timePeriod == '7days',
                      onTap: () => setState(() => _timePeriod = '7days'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'This Month',
                      isSelected: _timePeriod == 'month',
                      onTap: () => setState(() => _timePeriod = 'month'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'This Year',
                      isSelected: _timePeriod == 'year',
                      onTap: () => setState(() => _timePeriod = 'year'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Announcement',
                      isSelected: _filterType == MessageType.announcement,
                      onTap: () {
                        setState(() => _filterType == MessageType.announcement
                            ? _filterType = null
                            : _filterType = MessageType.announcement);
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Funeral',
                      isSelected: _filterType == MessageType.funeral,
                      onTap: () {
                        setState(() => _filterType == MessageType.funeral
                            ? _filterType = null
                            : _filterType = MessageType.funeral);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  var filtered = _filterByTimePeriod(messages);
                  if (_filterType != null) {
                    filtered = filtered.where((m) => m.type == _filterType).toList();
                  }

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 64,
                            color: AppTheme.textSecondary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final message = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedCard(
                          onTap: () => _showMessageDetail(context, message),
                          child: _MessageHistoryItem(message: message),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $error',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageDetail(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.type.name.toUpperCase()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(
                label: 'Member',
                value: message.memberName,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Type',
                value: message.type.name.toUpperCase(),
                color: message.type == MessageType.announcement
                    ? AppTheme.infoColor
                    : AppTheme.errorColor,
              ),
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Status',
                value: message.status.toUpperCase(),
                color: message.status == 'sent'
                    ? AppTheme.successColor
                    : AppTheme.warningColor,
              ),
              const SizedBox(height: 12),
              if (message.type == MessageType.announcement) ...[
                if (message.announcementPlace != null)
                  _DetailRow(label: 'Place', value: message.announcementPlace!),
                if (message.announcementTime != null) ...[
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Time', value: message.announcementTime!),
                ],
                if (message.announcementDay != null) ...[
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Day', value: message.announcementDay!),
                ],
              ] else ...[
                if (message.funeralChurch != null)
                  _DetailRow(label: 'Church', value: message.funeralChurch!),
                if (message.funeralPlace != null) ...[
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Place', value: message.funeralPlace!),
                ],
                if (message.funeralDeathType != null) ...[
                  const SizedBox(height: 12),
                  _DetailRow(label: 'Death Type', value: message.funeralDeathType!),
                ],
              ],
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Recipients',
                value: message.recipientIds.isEmpty
                    ? 'All Members'
                    : '${message.recipientIds.length} members',
              ),
              const SizedBox(height: 12),
              _DetailRow(
                label: 'Sent',
                value: message.sentAt.toString().split('.')[0],
              ),
              const SizedBox(height: 16),
              Text(
                'Message',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message.body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _MessageHistoryItem extends StatelessWidget {
  final Message message;

  const _MessageHistoryItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: message.type == MessageType.announcement
                    ? AppTheme.infoColor.withOpacity(0.1)
                    : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                message.type == MessageType.announcement
                    ? Icons.notifications_outlined
                    : Icons.favorite_outline,
                color: message.type == MessageType.announcement
                    ? AppTheme.infoColor
                    : AppTheme.errorColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.memberName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.body,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: message.status == 'sent'
                    ? AppTheme.successColor.withOpacity(0.1)
                    : AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                message.status.toUpperCase(),
                style: TextStyle(
                  color: message.status == 'sent'
                      ? AppTheme.successColor
                      : AppTheme.warningColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          message.sentAt.toString().split('.')[0],
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _DetailRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (color ?? AppTheme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color ?? AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
