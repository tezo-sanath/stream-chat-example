import 'dart:developer';

import 'package:chatapp/chat_screen.dart';
import 'package:chatapp/contacts_screen.dart';
import 'package:chatapp/user_model.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final client = StreamChatClient('edt2pe6zry4x');

  runApp(App(
    client: client,
  ));
}

class App extends StatefulWidget {
  const App({super.key, required this.client});
  final StreamChatClient client;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(
        streamChatClient: widget.client,
      ),
      builder: (context, child) {
        return StreamChatCore(client: widget.client, child: child!);
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.streamChatClient});
  final StreamChatClient streamChatClient;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () async {
            try {
              final client = StreamChatCore.of(context).client;
              await client.connectUser(User(id: usersList[index].id),
                  client.devToken(usersList[index].id).rawValue);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(
                  client: widget.streamChatClient,
                ),
              ));
            } catch (e) {
              log(e.toString());
            }
          },
          title: Text(usersList[index].name),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.client,
  });
  final StreamChatClient client;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ContactsScreen(),
                ));
              },
              icon: const Icon(Icons.add))
        ],
        leading: IconButton(
            onPressed: () async {
              await StreamChatCore.of(context).client.disconnectUser();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: PopScope(
        canPop: false,
        child: StreamChatTheme(
          data: StreamChatThemeData(colorTheme: StreamColorTheme.light()),
          child: StreamChat(
            client: widget.client,
            child: StreamChannelListView(
              errorBuilder: (p0, p1) {
                return Center(
                  child: Text(p1.message),
                );
              },
              onChannelTap: (p0) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      StreamChannel(channel: p0, child: const ChatScreen()),
                ));
              },
              controller: StreamChannelListController(
                filter: Filter.and(
                  [
                    Filter.equal('type', 'messaging'),
                    Filter.in_('members', [
                      StreamChatCore.of(context).currentUser!.id,
                    ])
                  ],
                ),
                client: widget.client,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
