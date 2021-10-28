class HttpError implements Exception{

  String message;

  HttpError(this.message);

  String get error => message;

}