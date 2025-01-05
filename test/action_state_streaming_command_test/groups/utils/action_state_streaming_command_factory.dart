import 'package:failures/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:state_streaming_command/state_streaming_command.dart';

final class ActionStateStreamingCommandFactory {
  StateStreamingCommand<ActionState> create<ResultType>({
    bool canStoreResultOnBusyAndError = false,
    required Future<Either<Failure, ResultType>> Function() actionToExecute,
  }) =>
      ActionStateStreamingCommand<ResultType>(
        actionToExecute: actionToExecute,
        canStoreResultOnBusyAndError: canStoreResultOnBusyAndError,
      );
}
