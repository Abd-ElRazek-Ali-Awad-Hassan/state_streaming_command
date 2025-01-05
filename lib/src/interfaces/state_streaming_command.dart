import 'command.dart';

abstract interface class StateStreamingCommand<StateType>
    implements Command, Stream<StateType> {}
