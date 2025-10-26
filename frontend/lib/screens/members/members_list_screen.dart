import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_app/providers/members_provider.dart';
import 'package:admin_app/widgets/app_drawer.dart';

class MembersListScreen extends ConsumerStatefulWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends ConsumerState<MembersListScreen> {
  late TextEditingController _searchController;
  bool? _filterActive;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(WidgetRef ref) {
    ref.read(membersProvider.notifier).fetchMembers(
          searchQuery: _searchController.text,
          isActive: _filterActive,
        );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/members/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _handleSearch(ref),
                  decoration: InputDecoration(
                    hintText: 'Search by name, email, or phone',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<bool?>(
                        segments: const [
                          ButtonSegment(label: Text('All'), value: null),
                          ButtonSegment(label: Text('Active'), value: true),
                          ButtonSegment(label: Text('Inactive'), value: false),
                        ],
                        selected: {_filterActive},
                        onSelectionChanged: (Set<bool?> newSelection) {
                          setState(() {
                            _filterActive = newSelection.first;
                          });
                          _handleSearch(ref);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: membersAsync.when(
              data: (members) {
                if (members.isEmpty) {
                  return const Center(child: Text('No members found'));
                }
                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      title: Text(member.fullName),
                      subtitle: Text(member.email),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('View'),
                            onTap: () =>
                                context.go('/members/${member.id}'),
                          ),
                          PopupMenuItem(
                            child: const Text('Edit'),
                            onTap: () =>
                                context.go('/members/${member.id}/edit'),
                          ),
                          PopupMenuItem(
                            child: const Text('Delete'),
                            onTap: () => _showDeleteConfirmation(
                              context,
                              ref,
                              member.id,
                            ),
                          ),
                        ],
                      ),
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

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String memberId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(membersProvider.notifier).deleteMember(memberId);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
