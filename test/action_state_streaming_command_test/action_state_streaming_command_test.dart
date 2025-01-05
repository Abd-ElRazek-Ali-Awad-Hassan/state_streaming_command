import 'package:flutter_test/flutter_test.dart';
import 'package:state_streaming_command/state_streaming_command.dart';

import 'groups/storing_result_when_busy_or_has_error_test_group.dart';
import 'groups/without_storing_result_when_busy_or_has_error_test_group.dart';

void main() {
  group('$ActionStateStreamingCommand', () {
    StoringResultWhenBusyOrHasErrorTestGroup().call();
    WithoutStoringResultWhenBusyOrHasErrorTestGroup().call();
  });
}
