import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/models/member_model.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/widgets/modals/success_modal.dart';
import 'package:admin_app/widgets/modals/error_modal.dart';
import 'package:uuid/uuid.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
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

  bool _validateForm() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _dateOfBirth == null) {
      return false;
    }
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text);
  }

  void _handleSave() async {
    if (!_validateForm()) {
      showErrorModal(context, 'Please fill all required fields correctly');
      return;
    }

    final member = Member(
      id: const Uuid().v4(),
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      dateOfBirth: _dateOfBirth!,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      isActive: _isActive,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(membersProvider.notifier).addMember(member);
      showSuccessModal(context, 'Member added successfully', () {
        context.go('/members');
      });
    } catch (e) {
      showErrorModal(context, 'Failed to add member: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Member')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone *'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email *'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date of Birth *'),
              subtitle: Text(
                _dateOfBirth?.toString().split(' ')[0] ?? 'Not selected',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
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
              onChanged: (value) => setState(() => _isActive = value ?? true),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSave,
                child: const Text('Save Member'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
