import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';

// Global Alice instance
final Alice alice = Alice(
  configuration: AliceConfiguration(
    showNotification: true,
    showInspectorOnShake: true,
  ),
);
