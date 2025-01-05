import 'package:failures/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:state_streaming_command/state_streaming_command.dart';

import 'action_state_streaming_command_factory.dart';
import 'test_command_emits_in_order.dart';

final class TestReportingFailureAsError {
  final Failure failure;
  final String description;
  final bool Function(Error error) errorPredicate;

  TestReportingFailureAsError({
    required this.failure,
    this.description = '',
    required this.errorPredicate,
  });

  void call() {
    TestCommandEmitsInOrder(
      description: description,
      commandCreate: () => ActionStateStreamingCommandFactory().create(
        actionToExecute: () async => Left(failure),
      ),
      commandExecute: (command) => command.execute(),
      matchers: [
        predicate<ActionState>((e) => e.error is NoneError),
        predicate<ActionState>((e) => e.isBusy),
        predicate<ActionState>((e) => errorPredicate(e.error)),
      ],
    ).call();
  }
}
