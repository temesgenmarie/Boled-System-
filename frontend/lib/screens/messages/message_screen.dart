import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/message_model.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/providers/messages_provider.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/theme/app_animations.dart';
import 'package:admin_app/widgets/animated_button.dart';
import 'package:admin_app/widgets/gradient_background.dart';
import 'package:admin_app/widgets/modals/success_modal.dart';
import 'package:admin_app/widgets/modals/error_modal.dart';
import 'package:uuid/uuid.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen>
    with SingleTickerProviderStateMixin {
  MessageType _selectedType = MessageType.announcement;
  late TextEditingController _bodyController;
  late TextEditingController _placeController;
  late TextEditingController _timeController;
  late TextEditingController _dayController;
  late TextEditingController _churchController;
  late TextEditingController _deathInfoController;
  String? _selectedDeathType; // new or old
  String? _selectedMemberId;
  DateTime? _scheduledTime;
  bool _sendToAll = true;
  Set<String> _selectedRecipients = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _bodyController = TextEditingController();
    _placeController = TextEditingController();
    _timeController = TextEditingController();
    _dayController = TextEditingController();
    _churchController = TextEditingController();
    _deathInfoController = TextEditingController();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _placeController.dispose();
    _timeController.dispose();
    _dayController.dispose();
    _churchController.dispose();
    _deathInfoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSendMessage() async {
    if (_bodyController.text.isEmpty) {
      showErrorModal(context, 'Please fill all required fields');
      return;
    }

    if (!_sendToAll && _selectedMemberId == null) {
      showErrorModal(context, 'Please select a member or enable "Send to all members"');
      return;
    }

    if (!_sendToAll && _selectedRecipients.isEmpty) {
      showErrorModal(context, 'Please select at least one recipient');
      return;
    }

    final recipientIds = _sendToAll
        ? <String>[]  // Empty list means send to all
        : _selectedRecipients.toList().cast<String>();

    final message = Message(
      id: const Uuid().v4(),
      type: _selectedType,
      memberId: _selectedMemberId ?? 'all',
      memberName: _sendToAll ? 'All Members' : 'Member',
      announcementPlace: _selectedType == MessageType.announcement ? _placeController.text : null,
      announcementTime: _selectedType == MessageType.announcement ? _timeController.text : null,
      announcementDay: _selectedType == MessageType.announcement ? _dayController.text : null,
      funeralChurch: _selectedType == MessageType.funeral ? _churchController.text : null,
      funeralPlace: _selectedType == MessageType.funeral ? _placeController.text : null,
      funeralDeathType: _selectedType == MessageType.funeral ? _selectedDeathType : null,
      funeralDeathInfo: _selectedType == MessageType.funeral ? _deathInfoController.text : null,
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
        _bodyController.clear();
        _placeController.clear();
        _timeController.clear();
        _dayController.clear();
        _churchController.clear();
        _deathInfoController.clear();
        _scheduledTime = null;
        _selectedRecipients.clear();
        _selectedMemberId = null;
        setState(() {});
      });
    } catch (e) {
      showErrorModal(context, 'Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Message'),
        elevation: 0,
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: FadeTransition(
            opacity: _animationController.drive(
              Tween<double>(begin: 0.0, end: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMessageTypeSelector(),
                const SizedBox(height: 28),

                _buildMemberSelector(membersAsync),
                const SizedBox(height: 28),

                _buildTextField(
                  controller: _bodyController,
                  label: 'Message Body *',
                  hint: 'Enter your message',
                  icon: Icons.message_outlined,
                  maxLines: 4,
                ),
                const SizedBox(height: 28),

                if (_selectedType == MessageType.announcement)
                  _buildAnnouncementFields()
                else
                  _buildFuneralFields(),
                const SizedBox(height: 28),

                _buildRecipientsSection(membersAsync),
                const SizedBox(height: 28),

                _buildScheduleSection(),
                const SizedBox(height: 32),

                AnimatedButton(
                  label: 'Send Message',
                  onPressed: _handleSendMessage,
                  icon: Icons.send_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberSelector(AsyncValue<List<dynamic>> membersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _sendToAll ? 'Select Member (Optional)' : 'Select Member *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        membersAsync.when(
          data: (members) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedMemberId,
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                hint: const Text('Choose a member'),
                items: members.map<DropdownMenuItem<String>>((member) {
                  return DropdownMenuItem<String>(
                    value: member.id,
                    child: Text(member.fullName),
                  );
                }).toList(),
                onChanged: (memberId) {
                  setState(() => _selectedMemberId = memberId);
                },
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Error: $error'),
        ),
      ],
    );
  }

  Widget _buildAnnouncementFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Announcement Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _placeController,
          label: 'Place',
          hint: 'Enter event place',
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _timeController,
          label: 'Time',
          hint: 'Enter event time',
          icon: Icons.access_time_outlined,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _dayController,
          label: 'Day',
          hint: 'Enter event day',
          icon: Icons.calendar_today_outlined,
        ),
      ],
    );
  }

  Widget _buildFuneralFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Funeral Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _churchController,
          label: 'Church',
          hint: 'Enter church name',
          icon: Icons.church_outlined,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _placeController,
          label: 'Place (Where he lives)',
          hint: 'Enter residence place',
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 12),
        Text(
          'Death Type',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedDeathType,
            isExpanded: true,
            underline: const SizedBox(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            hint: const Text('Select death type'),
            items: ['New', 'Old'].map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (type) {
              setState(() => _selectedDeathType = type);
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _deathInfoController,
          label: 'Death Information',
          hint: 'Enter death details',
          icon: Icons.info_outlined,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: maxLines == 1 ? Icon(icon) : null,
            prefixIconConstraints: maxLines == 1 ? null : const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientsSection(AsyncValue<List<dynamic>> membersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipients',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CheckboxListTile(
            title: const Text('Send to all members'),
            value: _sendToAll,
            onChanged: (value) => setState(() => _sendToAll = value ?? true),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        
        if (!_sendToAll) ...[
          const SizedBox(height: 12),
          membersAsync.when(
            data: (members) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: members
                      .asMap()
                      .entries
                      .map((entry) {
                        final member = entry.value;
                        final isLast = entry.key == members.length - 1;
                        return Column(
                          children: [
                            CheckboxListTile(
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            if (!isLast)
                              Divider(height: 1, color: AppTheme.borderColor),
                          ],
                        );
                      })
                      .toList(),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading members: $error',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send at',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _scheduledTime?.toString().split('.')[0] ?? 'Now',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _TypeButton(
                label: 'Announcement',
                icon: Icons.notifications_outlined,
                isSelected: _selectedType == MessageType.announcement,
                onTap: () => setState(() => _selectedType = MessageType.announcement),
                color: AppTheme.infoColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TypeButton(
                label: 'Funeral',
                icon: Icons.favorite_outline,
                isSelected: _selectedType == MessageType.funeral,
                onTap: () => setState(() => _selectedType = MessageType.funeral),
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TypeButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  State<_TypeButton> createState() => _TypeButtonState();
}

class _TypeButtonState extends State<_TypeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.isSelected ? widget.color.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: widget.isSelected ? widget.color : AppTheme.borderColor,
              width: widget.isSelected ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected ? widget.color : AppTheme.textSecondary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected ? widget.color : AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
