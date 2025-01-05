import 'package:flutter_test/flutter_test.dart';
import 'package:state_streaming_command/state_streaming_command.dart';

typedef CommandExecutor = Future<void> Function(
  StateStreamingCommand<ActionState> command,
);

typedef CommandCreator = StateStreamingCommand<ActionState> Function();

final class TestCommandEmitsInOrder {
  final String description;

  final CommandCreator commandCreate;

  final Iterable<Matcher> matchers;

  final CommandExecutor commandExecute;

  TestCommandEmitsInOrder({
    this.description = '',
    required this.commandCreate,
    required this.commandExecute,
    required this.matchers,
  });

  void call() {
    test(description, () async {
      final command = commandCreate();

      expectLater(command, emitsInOrder(matchers));

      await commandExecute(command);
    });
  }
}
