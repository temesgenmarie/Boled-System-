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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  DateTime? _dateOfBirth;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final member = await ref.read(memberDetailProvider(widget.memberId).future);
    final updatedMember = member.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      dateOfBirth: _dateOfBirth ?? member.dateOfBirth,
      address: _addressController.text.isEmpty ? null : _addressController.text,
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
          if (_firstNameController.text.isEmpty) {
            _firstNameController.text = member.firstName;
            _lastNameController.text = member.lastName;
            _phoneController.text = member.phone;
            _emailController.text = member.email;
            _addressController.text = member.address ?? '';
            _dateOfBirth = member.dateOfBirth;
            _isActive = member.isActive;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Date of Birth'),
                  subtitle: Text(_dateOfBirth?.toString().split(' ')[0] ?? ''),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dateOfBirth ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() => _dateOfBirth = date);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 3,
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
