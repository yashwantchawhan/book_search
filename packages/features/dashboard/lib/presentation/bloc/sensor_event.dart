abstract class SensorEvent {}

class FetchSensorInformationEvent extends SensorEvent {
  FetchSensorInformationEvent();
}

class TriggeredFlashLightEvent extends SensorEvent {
  final bool currentValue;
  TriggeredFlashLightEvent({required this.currentValue});
}
