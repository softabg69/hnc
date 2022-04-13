abstract class RequestStatus {
  const RequestStatus();
}

class RequestInitialStatus extends RequestStatus {
  const RequestInitialStatus();
}

class RequestSubmitting extends RequestStatus {}

class RequestSuccess extends RequestStatus {}

class RequestFailed extends RequestStatus {
  final Exception exception;

  RequestFailed(this.exception);
}
