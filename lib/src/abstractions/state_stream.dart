import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../interfaces/emitter.dart';

abstract class StateStream<StateType> extends Stream<StateType>
    implements Emitter<StateType> {
  StateStream([StateType? initialState]) {
    _subject = switch (initialState) {
      null => BehaviorSubject(),
      _ => BehaviorSubject<StateType>.seeded(initialState),
    };
  }

  late final BehaviorSubject<StateType> _subject;

  @override
  void emit(StateType state) => _subject.add(state);

  StateType get state => _subject.value;

  @override
  StreamSubscription<StateType> listen(
    void Function(StateType event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _subject.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}
