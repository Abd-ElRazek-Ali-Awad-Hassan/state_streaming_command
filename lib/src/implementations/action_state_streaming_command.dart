import 'dart:async';

import 'package:failures/failures.dart';
import 'package:fpdart/fpdart.dart';

import '../abstractions/state_stream.dart';
import '../interfaces/action_state.dart';
import '../interfaces/state_streaming_command.dart';
import 'action_state_impl.dart';
import 'errors.dart';

final class ActionStateStreamingCommand<ResultType>
    extends StateStream<ActionState<ResultType>>
    implements StateStreamingCommand<ActionState<ResultType>> {
  ActionStateStreamingCommand({
    bool canStoreResultOnBusyAndError = false,
    required Future<Either<Failure, ResultType>> Function() actionToExecute,
  })  : _actionToExecute = actionToExecute,
        super(
          canStoreResultOnBusyAndError
              ? ActionStateImpl.forStoringResult()
              : ActionStateImpl(),
        );

  final Future<Either<Failure, ResultType>> Function() _actionToExecute;

  @override
  Future<void> execute() async {
    emit(state.makeBusy());
    (await _actionToExecute()).fold<void>(
      (l) => switch (l) {
        CacheFailure _ => emit(state.reportError(NetworkError())),
        NetworkFailure _ => emit(state.reportError(NetworkError())),
        AuthorizedAccessFailure _ =>
          emit(state.reportError(UnauthorizedAccessError())),
        ServerFailure f =>
          emit(state.reportError(ServerError(message: f.message))),
        _ => () {},
      },
      (r) => emit(state.reportResult(r)),
    );
  }
}
