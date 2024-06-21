import 'dart:developer';
import 'dart:typed_data';

import 'package:ai_image_generator_using_bloc/presentation/home/bloc/home_bloc_bloc.dart';
import 'package:ai_image_generator_using_bloc/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text, Type type) {
    _textController.clear();
    if (type == HomeBlocInitialState && text.isNotEmpty) {
      homeBloc.add(PromptEnteredEvent(text: text));
      ChatMessage message = ChatMessage(
        text: text,
        sender: "user",
        bloc: homeBloc,
      );
      setState(() {
        _messages.insert(0, message);
      });
      log("image list: $_messages");
    }
    // log("message=> " + type.toString());
  }

  Widget _buildTextComposer({required Type state}) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                decoration:
                    const InputDecoration.collapsed(hintText: "Write a prompt"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 200, 8, 149),
                ),
                onPressed: () => _handleSubmitted(_textController.text, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    homeBloc.add(PromptInitialEvent());
  }

  final homeBloc = HomeBlocBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBlocBloc, HomeBlocState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeBlocActionState,
      buildWhen: (previous, current) => current is! HomeBlocActionState,
      listener: (context, state) {
        final stateType = state.runtimeType;
        log("message=> $stateType");
        if (state is ImageDownloadLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        } else if (state is ImageDownloadSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      builder: (context, state) {
        final stateType = state.runtimeType;
        if (state is HomeBlocPromptSuccessState) {
          // final successState = state as HomeBlocPromptSuccessState;
          // Simulate a response from imagine api
          log("Success state=> $state");
          ChatMessage botMessage = ChatMessage(
            sender: "Artistry",
            image: state.unit8List,
            bloc: homeBloc,
          );

          _messages.insert(0, botMessage);

          log("image list: $_messages");
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[300],
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Wellcome to Artistry',
                  style: TextStyle(
                      color: Color.fromARGB(255, 200, 8, 149),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/logo.jpg",
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Flexible(
                child: _messages.length <= 0
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Features:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '1. Chat with AI\n2. Generate Images\n3. Get Recommendations',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Example Prompts:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '"Tell me a joke."\n"Generate an image of a sunset."\n"Recommend me a book."',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (_, int index) => _messages[index],
                      ),
              ),
              state is HomeBlocPromptLoadingState
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TripleDotLoader(),
                      ],
                    )
                  : state is HomeBlocPromptErrorState
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Server Error! Try again...",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                )
                              ]),
                        )
                      : const SizedBox(),
              const Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(state: stateType),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChatMessage extends StatelessWidget {
  String? text;
  final String sender;
  Uint8List? image;
  final Bloc bloc;

  ChatMessage({
    super.key,
    required this.sender,
    this.text,
    this.image,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sender == "user" ? _buildUserMessage() : _buildBotMessage(),
      ),
    );
  }

  List<Widget> _buildUserMessage() {
    return [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'You',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text.toString()),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: const CircleAvatar(child: Text('U')),
      ),
    ];
  }

  List<Widget> _buildBotMessage() {
    return [
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: const CircleAvatar(child: Text('A')),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Artistry',
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  width: 200,
                  margin: const EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(image!), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: InkWell(
                    onTap: () {
                      bloc.add(ImageDownloadEvent(image: image!));
                    },
                    child: const CircleAvatar(
                      radius: 15,
                      child: Icon(Icons.arrow_downward_rounded),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
