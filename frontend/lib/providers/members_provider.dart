import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/member_model.dart';
import 'package:admin_app/services/members_service.dart';

final membersServiceProvider = Provider((ref) => MembersService());

final membersProvider =
    StateNotifierProvider<MembersNotifier, AsyncValue<List<Member>>>((ref) {
  final service = ref.watch(membersServiceProvider);
  return MembersNotifier(service);
});

final memberDetailProvider =
    FutureProvider.family<Member, String>((ref, memberId) async {
  final service = ref.watch(membersServiceProvider);
  return service.getMemberById(memberId);
});

class MembersNotifier extends StateNotifier<AsyncValue<List<Member>>> {
  final MembersService _service;

  MembersNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchMembers();
  }

  Future<void> fetchMembers({
    String? searchQuery,
    bool? isActive,
    int page = 1,
    int pageSize = 20,
  }) async {
    state = const AsyncValue.loading();
    try {
      final members = await _service.getMembers(
        searchQuery: searchQuery,
        isActive: isActive,
        page: page,
        pageSize: pageSize,
      );
      state = AsyncValue.data(members);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMember(Member member) async {
    try {
      await _service.createMember(member);
      await fetchMembers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMember(Member member) async {
    try {
      await _service.updateMember(member);
      await fetchMembers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMember(String memberId) async {
    try {
      await _service.deleteMember(memberId);
      await fetchMembers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
