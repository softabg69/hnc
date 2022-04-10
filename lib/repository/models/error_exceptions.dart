class ErrorEmptyResponse implements Exception {}

class ErrorGettingData implements Exception {
  ErrorGettingData(String error);
}
