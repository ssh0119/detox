import 'package:http/http.dart' as http;

class RequestServer {
  final String url = 'http://192.168.43.226:8080';

  /// 서버로 GET 요청을 보내는 함수
  Future<http.Response?> makeGetRequest(
      String salutation, String name, String email) async {
    final client = http.Client();
    final uri = Uri.parse('$url/interestRequest');

    try {
      // POST 요청
      final response = await client.post(
        uri,
        body: {'salutation': salutation, 'name': name, 'email': email},
      );

      // 상태 코드 출력
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // 상태 코드에 따른 처리
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 요청 성공
        return response;
      } else {
        // 오류 상태 처리
        print("Request failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // 네트워크 또는 기타 오류 처리
      print("Error during request: $e");
      return null;
    } finally {
      // 클라이언트 닫기
      client.close();
    }
  }
}
