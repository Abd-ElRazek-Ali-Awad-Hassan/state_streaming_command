import 'package:failures/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';
import 'package:state_streaming_command/state_streaming_command.dart';

import 'utils/action_state_streaming_command_factory.dart';
import 'utils/and_matcher_extension.dart';
import 'utils/test_command_emits_in_order.dart';

const firstResult = 'string result';

const lastResult = 'string result 2';

final class StoringResultWhenBusyOrHasErrorTestGroup {
  late Either<Failure, String> actionResult;

  late StateStreamingCommand<ActionState> command;

  void call() {
    group('with storing result when busy or has error', () {
      setUp(() {
        actionResult = const Right(firstResult);
        command = ActionStateStreamingCommandFactory().create<String>(
          actionToExecute: () async => actionResult,
          canStoreResultOnBusyAndError: true,
        );
      });

      _testStoreResultWhenBusy();

      _testStoreResultWhenServerError();

      _testStoreResultWhenUnauthorizedAccessError();

      _testStoreResultWhenNetworkErrorOnCacheFailure();

      _testStoreResultWhenNetworkErrorOnNetworkFailure();
    });
  }

  void _testStoreResultWhenBusy() {
    TestCommandEmitsInOrder(
      description: 'store result when busy',
      commandCreate: () => command,
      commandExecute: (command) async {
        await command.execute();
        actionResult = const Right(lastResult);
        await command.execute();
      },
      matchers: [
        _predicateStateError<NoneError>(),
        _predicateStateIsBusy(),
        _predicateStateResult(firstResult),
        _predicateStateIsBusy().and(_predicateStateResult(firstResult)),
        _predicateStateResult(lastResult),
      ],
    ).call();
  }

  void _testStoreResultWhenServerError() {
    _testStoreResultWhenHasError<ServerError>(
      failure: ServerFailure(),
      description: 'store result when server error',
    );
  }

  void _testStoreResultWhenUnauthorizedAccessError() {
    _testStoreResultWhenHasError<UnauthorizedAccessError>(
      failure: AuthorizedAccessFailure(),
      description: 'store result when unauthorized access error',
    );
  }

  void _testStoreResultWhenNetworkErrorOnCacheFailure() {
    _testStoreResultWhenHasError<NetworkError>(
      failure: CacheFailure(),
      description: 'store result when network error on cache failure',
    );
  }

  void _testStoreResultWhenNetworkErrorOnNetworkFailure() {
    _testStoreResultWhenHasError<NetworkError>(
      failure: NetworkFailure(),
      description: 'store result when network error on network failure',
    );
  }

  void _testStoreResultWhenHasError<ErrorType extends Error>({
    String description = '',
    required Failure failure,
  }) {
    return TestCommandEmitsInOrder(
      description: description,
      commandCreate: () => command,
      commandExecute: (command) async {
        await command.execute();
        actionResult = Left(failure);
        await command.execute();
      },
      matchers: [
        _predicateStateError<NoneError>(),
        _predicateStateIsBusy(),
        _predicateStateResult(firstResult),
        _predicateStateIsBusy().and(_predicateStateResult(firstResult)),
        _predicateStateResult(firstResult)
            .and(_predicateStateError<ErrorType>()),
      ],
    ).call();
  }

  Matcher _predicateStateError<ErrorType extends Error>() =>
      predicate<ActionState>((e) {
        expect(e.error, isA<ErrorType>());
        return true;
      });

  Matcher _predicateStateIsBusy() => predicate<ActionState>((e) {
        expect(e.isBusy, isTrue);
        return true;
      });

  Matcher _predicateStateResult<ResultType>(
    ResultType result,
  ) =>
      predicate<ActionState>((e) {
        expect(e.result, Just(result));
        return true;
      });
}
