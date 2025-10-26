import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/widgets/modals/success_modal.dart';
import 'package:admin_app/widgets/modals/error_modal.dart';

class EditMemberScreen extends ConsumerStatefulWidget {
  final String memberId;

  const EditMemberScreen({required this.memberId, Key? key}) : super(key: key);

  @override
  ConsumerState<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends ConsumerState<EditMemberScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final member = await ref.read(memberDetailProvider(widget.memberId).future);
    final updatedMember = member.copyWith(
      fullName: _fullNameController.text,
      phone: _phoneController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      isActive: _isActive,
    );

    try {
      await ref.read(membersProvider.notifier).updateMember(updatedMember);
      showSuccessModal(context, 'Member updated successfully', () {
        context.go('/members');
      });
    } catch (e) {
      showErrorModal(context, 'Failed to update member: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberAsync = ref.watch(memberDetailProvider(widget.memberId));

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Member')),
      body: memberAsync.when(
        data: (member) {
          // Initialize controllers on first build
          if (_fullNameController.text.isEmpty) {
            _fullNameController.text = member.fullName;
            _phoneController.text = member.phone;
            _emailController.text = member.email ?? '';
            _isActive = member.isActive;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email (Optional)'),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (value) =>
                      setState(() => _isActive = value ?? true),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    child: const Text('Update Member'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
