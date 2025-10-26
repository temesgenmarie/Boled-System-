import 'package:admin_app/models/member_model.dart';
import 'package:uuid/uuid.dart';

class MembersService {
  // Mock data storage
  static final List<Member> _mockMembers = [
    Member(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      phone: '555-0101',
      email: 'john@example.com',
      dateOfBirth: DateTime(1990, 5, 15),
      address: '123 Main St',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Member(
      id: '2',
      firstName: 'Jane',
      lastName: 'Smith',
      phone: '555-0102',
      email: 'jane@example.com',
      dateOfBirth: DateTime(1985, 8, 20),
      address: '456 Oak Ave',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  Future<List<Member>> getMembers({
    String? searchQuery,
    bool? isActive,
    int page = 1,
    int pageSize = 20,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var results = _mockMembers;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      results = results
          .where((m) =>
              m.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              m.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
              m.phone.contains(searchQuery))
          .toList();
    }

    if (isActive != null) {
      results = results.where((m) => m.isActive == isActive).toList();
    }

    // Pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;
    return results.sublist(
      startIndex,
      endIndex > results.length ? results.length : endIndex,
    );
  }

  Future<Member> getMemberById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockMembers.firstWhere((m) => m.id == id);
  }

  Future<void> createMember(Member member) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newMember = member.copyWith(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );
    _mockMembers.add(newMember);
  }

  Future<void> updateMember(Member member) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockMembers.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _mockMembers[index] = member;
    }
  }

  Future<void> deleteMember(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockMembers.removeWhere((m) => m.id == id);
  }
}
