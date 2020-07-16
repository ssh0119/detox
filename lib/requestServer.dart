import 'package:http/http.dart';

class RequestServer {
  String url = 'http://192.168.43.226:8080';

  Future makeGetRequest(String salutation, String name, String email) async {
    var client = Client();
    var urlRequest = url + "/interestRequest";
    try {
      var res = await client.post(urlRequest,
          body: {'salutation': salutation, 'name': name, 'email': email});
      print("Response status : ${res.statusCode}");
      print("Response body: ${res.body}");
      return res;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }
}
