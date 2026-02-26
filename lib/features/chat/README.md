# Chat Module - RiLyBricoule

## Overview
Premium chat/messaging system for client-provider communication in the RiLyBricoule marketplace app.

## Features Implemented

### 1. Conversation List Screen
- ✅ Real-time conversation list with unread indicators
- ✅ Search functionality (filters by name and message content)
- ✅ Pull-to-refresh support
- ✅ Empty state with CTA to explore providers
- ✅ No results state for search
- ✅ FAB for new message (navigates to search)
- ✅ Online/offline status indicators
- ✅ Unread count badges
- ✅ Smart time formatting (Today, Yesterday, dates)

### 2. Chat Thread Screen
- ✅ Message bubbles (left for provider, right for client)
- ✅ Date separators (Aujourd'hui, Hier, dates)
- ✅ Message status indicators (sending, sent, delivered, read)
- ✅ Image message support
- ✅ Long press for message options (copy, delete, report)
- ✅ Auto-scroll to bottom on new messages
- ✅ Online/offline status in header
- ✅ Call and more options (placeholders)

### 3. Message Input
- ✅ Text input with send button
- ✅ Image picker (mock implementation)
- ✅ Attachment menu
- ✅ Send button disabled when empty
- ✅ Keyboard-aware scrolling

### 4. Navigation Integration
- ✅ Bottom nav updated (Messages replaces Favoris)
- ✅ Dynamic routing for chat threads
- ✅ Deep linking support
- ✅ Chat button in provider profile
- ✅ Auto-create conversation from provider profile

## Architecture

### Data Layer
```
lib/features/chat/
├── data/
│   └── local_chat_repository.dart    # Mock implementation with in-memory data
├── domain/
│   ├── chat_repository.dart          # Interface for API integration
│   └── models/
│       ├── conversation.dart         # Conversation model
│       ├── message.dart              # Message model with status
│       └── user_summary.dart         # User summary model
```

### Presentation Layer
```
├── presentation/
│   ├── screens/
│   │   ├── conversation_list_screen.dart
│   │   └── chat_thread_screen.dart
│   └── widgets/
│       ├── conversation_tile.dart
│       ├── message_bubble.dart
│       ├── date_separator.dart
│       └── chat_input_bar.dart
```

### State Management
```
├── controllers/
│   ├── conversations_controller.dart  # Manages conversation list
│   └── chat_thread_controller.dart    # Manages individual chat
```

## Mock Data
The `LocalChatRepository` includes:
- 5 seeded conversations with various states
- 2 conversations with unread messages
- 1 conversation with image messages
- Mix of online/offline providers
- Realistic timestamps and message content

## Message Status Flow
1. **Sending** → Shows loading indicator
2. **Sent** → Single checkmark (500ms delay)
3. **Delivered** → Double checkmark (800ms delay)
4. **Read** → Double checkmark in primary color (1200ms delay, only if provider is online)

## API Integration Readiness

### To integrate with backend API:

1. **Replace LocalChatRepository** with ApiChatRepository:
```dart
class ApiChatRepository implements ChatRepository {
  final ApiClient _client;
  
  @override
  Future<List<Conversation>> getConversations({String? query}) async {
    final response = await _client.get('/conversations', queryParams: {'q': query});
    return (response.data as List)
        .map((json) => Conversation.fromJson(json))
        .toList();
  }
  
  // Implement other methods...
}
```

2. **WebSocket for real-time updates**:
```dart
Stream<List<Conversation>> watchConversations() {
  return _websocket.stream
      .where((event) => event.type == 'conversation_update')
      .map((event) => (event.data as List)
          .map((json) => Conversation.fromJson(json))
          .toList());
}
```

3. **Update main.dart**:
```dart
final chatRepository = ApiChatRepository(apiClient);
```

## Routes
- `/messages` - Conversation list (bottom nav tab 3)
- `/chat/:conversationId` - Individual chat thread

## Design System
- Primary color: `#1A227F`
- Uses Google Fonts (Poppins)
- Rounded corners (12-16px)
- Clean shadows and spacing
- Consistent with existing app design

## Edge Cases Handled
1. ✅ Empty conversation list → Shows empty state
2. ✅ Search with no results → Shows no results state
3. ✅ Long messages → Proper truncation in list
4. ✅ Empty text → Send button disabled
5. ✅ Delete last message → Updates conversation preview
6. ✅ Message status updates → Real-time simulation
7. ✅ Keyboard behavior → Auto-scroll maintained

## Future Enhancements (Backend Required)
- [ ] File attachments (PDF, documents)
- [ ] Voice messages
- [ ] Video calls
- [ ] Message reactions
- [ ] Typing indicators
- [ ] Push notifications
- [ ] Message encryption
- [ ] Conversation archiving
- [ ] Block/report users
- [ ] Message search within conversation

## Testing
To test the chat module:
1. Navigate to Messages tab (bottom nav)
2. Tap any conversation to open chat
3. Send text messages
4. Send images (mock)
5. Long press messages for options
6. Search conversations
7. Go to provider profile → tap chat button
8. Observe message status changes
9. Test empty states

## Dependencies Added
- `intl: ^0.19.0` - For date formatting

## Notes
- All data is currently in-memory (resets on app restart)
- Message status simulation mimics real-world delays
- Provider online status is mocked
- Images use placeholder URLs
- Ready for WebSocket integration
