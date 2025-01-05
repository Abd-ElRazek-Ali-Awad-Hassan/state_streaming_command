import 'package:failures/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:state_streaming_command/state_streaming_command.dart';

import 'utils/action_state_streaming_command_factory.dart';
import 'utils/test_command_emits_in_order.dart';
import 'utils/test_reporting_failure_as_error.dart';

final class WithoutStoringResultWhenBusyOrHasErrorTestGroup {
  void call() {
    group('without storing result when busy or has error', () {
      _testReportingServerError();

      _testReportingUnauthorizedAccessError();

      _testReportingNetworkErrorOnCacheFailure();

      _testReportingNetworkErrorOnNetworkFailure();

      _testReportingResult('string result');
    });
  }
}

void _testReportingServerError() {
  TestReportingFailureAsError(
    description: 'report server error',
    failure: ServerFailure(),
    errorPredicate: (e) => e is ServerError,
  ).call();
}

void _testReportingUnauthorizedAccessError() {
  TestReportingFailureAsError(
    description: 'report unauthorized access error',
    failure: AuthorizedAccessFailure(),
    errorPredicate: (e) => e is UnauthorizedAccessError,
  ).call();
}

void _testReportingNetworkErrorOnCacheFailure() {
  TestReportingFailureAsError(
    description: 'report network error on cache failure',
    failure: CacheFailure(),
    errorPredicate: (e) => e is NetworkError,
  ).call();
}

void _testReportingNetworkErrorOnNetworkFailure() {
  TestReportingFailureAsError(
    description: 'report network error on network failure',
    failure: NetworkFailure(),
    errorPredicate: (e) => e is NetworkError,
  ).call();
}

void _testReportingResult<ResultType>(ResultType result) {
  TestCommandEmitsInOrder(
    description: 'report result: $result',
    commandCreate: () {
      return ActionStateStreamingCommandFactory().create<ResultType>(
        actionToExecute: () async => Right(result),
        canStoreResultOnBusyAndError: false,
      );
    },
    commandExecute: (command) => command.execute(),
    matchers: [
      predicate<ActionState>((e) => e.error is NoneError),
      predicate<ActionState>((e) => e.isBusy),
      predicate<ActionState>((e) => e.result == Just(result)),
    ],
  ).call();
}
