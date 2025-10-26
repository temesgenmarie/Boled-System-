import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/models/message_model.dart';
import 'package:admin_app/services/messages_service.dart';

final messagesServiceProvider = Provider((ref) => MessagesService());

final messageHistoryProvider =
    StateNotifierProvider<MessageHistoryNotifier, AsyncValue<List<Message>>>(
        (ref) {
  final service = ref.watch(messagesServiceProvider);
  return MessageHistoryNotifier(service);
});

class MessageHistoryNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final MessagesService _service;

  MessageHistoryNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchHistory();
  }

  Future<void> fetchHistory({
    MessageType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      final messages = await _service.getMessageHistory(
        type: type,
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncValue.data(messages);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      await _service.sendMessage(message);
      await fetchHistory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
