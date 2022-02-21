enum ServerResponseType {
  serverResponseError,
  serverResponseSuccess,
  serverResponseWarning,
  serverResponseClientError,
}

class ServerResponse {
  final int statusCode;
  final Object data;
  final ServerResponseType type;

  ServerResponse(
      {required this.type, required this.data, required this.statusCode});
}
