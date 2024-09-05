import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamChatConfiguration(
      data: StreamChatConfigurationData(),
      child: Scaffold(
        appBar: AppBar(),
        body: StreamChatTheme(
          data: StreamChatThemeData(),
          child: StreamUserListView(
            onUserTap: (p0) async {
              final core = StreamChatCore.of(context);
              final channel = core.client.channel('messaging', extraData: {
                'members': [core.currentUser?.id, p0.id]
              });
              await channel.watch();
            },
            controller: StreamUserListController(
              filter: Filter.notEqual(
                  'id', StreamChatCore.of(context).currentUser?.id ?? ''),
              client: StreamChatCore.of(context).client,
            ),
          ),
        ),
      ),
    );
  }
}
