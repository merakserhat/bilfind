import 'package:bilfind_app/models/conversation_model.dart';
import 'package:bilfind_app/models/program.dart';
import 'package:bilfind_app/models/response/message_response.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

abstract class SocketListenable {
  void updateState();
  void onGetMessage(MessageResponse messageResponse);
  void updateWithNewConversation(ConversationModel conversationModel);
}

class SocketService {
  static final SocketService _instance = SocketService._internal();

  SocketListenable? socketListenable;
  IO.Socket? socket;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {}

  register(SocketListenable socketListenable) {
    this.socketListenable = socketListenable;

    socket = IO.io(
        'https://bilfind-554377be9818.herokuapp.com/messaging',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    socket!.onConnect((_) {});

    //When an event recieved from server, data is added to the stream
    socket!.on('log', (data) {});

    socket!.on('message', (data) {
      MessageResponse messageResponse = MessageResponse.fromJson(data);
      socketListenable.onGetMessage(messageResponse);
    });
    socket!.onDisconnect((_) => print('disconnect'));
  }

  dispose() {
    socketListenable = null;
    if (socket != null) {
      socket!.close();
      socket!.dispose();
    }
  }

  updateListeners() {
    if (socketListenable != null) {
      socketListenable!.updateState();
    }
  }

  joinConversation(ConversationModel conversationModel) {
    if (socket == null) {
      print("Socket is null");
      return;
    }

    if (socket!.disconnected) {
      socket!.connect();
    }

    socket!.emit('joinRoom', {
      "conversationId": conversationModel.id,
      "userId": Program().userModel!.id,
    });
  }

  sendMessage(ConversationModel conversationModel, String text) {
    if (socket == null) {
      return;
    }

    if (socket!.disconnected) {
      socket!.connect();
    }

    socket!.emit('sendMessage', {
      "conversationId": conversationModel.id,
      "userId": Program().userModel!.id,
      "content": text,
    });
  }
}
