import 'package:maybe_just_nothing/maybe_just_nothing.dart';

import '../interfaces/action_state.dart';
import '../interfaces/error.dart';
import 'errors.dart';

final class ActionStateImpl<ResultType> implements ActionState<ResultType> {
  ActionStateImpl({
    bool isBusy = false,
    Error error = const NoneError(),
    Maybe<ResultType> result = const Nothing(),
  }) : _actionState = _ActionStateImpl<ResultType>(
          error: error,
          isBusy: isBusy,
          result: result,
        );

  ActionStateImpl.forStoringResult({
    bool isBusy = false,
    Error error = const NoneError(),
    Maybe<ResultType> result = const Nothing(),
  }) : _actionState = _ActionStateThatStoreResultImpl<ResultType>(
          error: error,
          isBusy: isBusy,
          result: result,
        );

  late final ActionState<ResultType> _actionState;

  @override
  bool get isBusy => _actionState.isBusy;

  @override
  Error get error => _actionState.error;

  @override
  Maybe<ResultType> get result => _actionState.result;

  @override
  ActionState<ResultType> makeBusy() => _actionState.makeBusy();

  @override
  ActionState<ResultType> reportError(
    Error error,
  ) =>
      _actionState.reportError(error);

  @override
  ActionState<ResultType> reportResult(
    ResultType result,
  ) =>
      _actionState.reportResult(result);
}

final class _ActionStateImpl<ResultType> implements ActionState<ResultType> {
  @override
  final bool isBusy;

  @override
  final Error error;

  @override
  final Maybe<ResultType> result;

  _ActionStateImpl({
    this.isBusy = false,
    this.error = const NoneError(),
    this.result = const Nothing(),
  });

  @override
  ActionState<ResultType> makeBusy() {
    return _ActionStateImpl<ResultType>(isBusy: true);
  }

  @override
  ActionState<ResultType> reportError(Error error) {
    return _ActionStateImpl<ResultType>(error: error);
  }

  @override
  ActionState<ResultType> reportResult(ResultType result) {
    return _ActionStateImpl<ResultType>(result: Just<ResultType>(result));
  }
}

final class _ActionStateThatStoreResultImpl<ResultType>
    implements ActionState<ResultType> {
  @override
  final bool isBusy;

  @override
  final Error error;

  @override
  final Maybe<ResultType> result;

  _ActionStateThatStoreResultImpl({
    this.isBusy = false,
    this.error = const NoneError(),
    this.result = const Nothing(),
  });

  @override
  ActionState<ResultType> makeBusy() {
    return _ActionStateThatStoreResultImpl<ResultType>(
      isBusy: true,
      result: result,
    );
  }

  @override
  ActionState<ResultType> reportError(Error error) {
    return _ActionStateThatStoreResultImpl<ResultType>(
      error: error,
      result: result,
    );
  }

  @override
  ActionState<ResultType> reportResult(ResultType result) {
    return _ActionStateThatStoreResultImpl<ResultType>(
      result: Just<ResultType>(result),
    );
  }
}
