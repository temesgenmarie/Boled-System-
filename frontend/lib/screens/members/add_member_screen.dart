import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/models/member_model.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/providers/auth_provider.dart';
import 'package:admin_app/widgets/modals/success_modal.dart';
import 'package:admin_app/widgets/modals/error_modal.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  MemberRole _selectedRole = MemberRole.user; // Added role selection
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_fullNameController.text.isEmpty || _phoneController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _handleSave() async {
    if (!_validateForm()) {
      showErrorModal(context, 'Please fill all required fields');
      return;
    }

    final authState = ref.read(authStateProvider);
    final organizationId = authState.organization?.id ?? 'default-org';

    final member = Member(
      id: const Uuid().v4(),
      fullName: _fullNameController.text, // Simplified to fullName only
      phone: _phoneController.text,
      email: null,
      role: _selectedRole, // Added role assignment
      isActive: _isActive,
      createdAt: DateTime.now(),
      organizationId: organizationId,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Enter member full name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                hintText: 'Enter phone number',
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Member Role *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<MemberRole>(
                value: _selectedRole,
                isExpanded: true,
                underline: const SizedBox(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: MemberRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (role) {
                  if (role != null) {
                    setState(() => _selectedRole = role);
                  }
                },
              ),
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
