import 'package:maybe_just_nothing/maybe_just_nothing.dart';

import 'error.dart';

abstract interface class ActionState<ResultType> {
  bool get isBusy;

  Error get error;

  Maybe<ResultType> get result;

  ActionState<ResultType> makeBusy();

  ActionState<ResultType> reportError(Error error);

  ActionState<ResultType> reportResult(ResultType result);
}
