import 'package:admin_app/models/message_model.dart';
import 'package:uuid/uuid.dart';

class MessagesService {
  static final List<Message> _mockMessages = [];

  Future<List<Message>> getMessageHistory({
    MessageType? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var results = _mockMessages;

    if (type != null) {
      results = results.where((m) => m.type == type).toList();
    }

    if (startDate != null) {
      results = results.where((m) => m.sentAt.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      results = results.where((m) => m.sentAt.isBefore(endDate)).toList();
    }

    return results.reversed.toList();
  }

  Future<void> sendMessage(Message message) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newMessage = message.copyWith(
      id: const Uuid().v4(),
      status: 'sent',
    );
    _mockMessages.add(newMessage);
  }
}
