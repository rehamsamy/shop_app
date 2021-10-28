class AuthModel{
  String idToken;
  String  expiresIn;
  String localId;

  AuthModel({this.idToken, this.expiresIn, this.localId});

  factory AuthModel.fromJson(Map<String,Object> map){
    
    return AuthModel(idToken:map['idToken'], localId:map['localId']);
  }
}