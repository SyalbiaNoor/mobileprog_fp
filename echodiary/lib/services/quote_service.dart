import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<String> fetchQuote() async {
    final url = Uri.parse('https://zenquotes.io/api/today');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final quote = data[0]['q'];
      final author = data[0]['a'];
      return '"$quote"\n— $author';
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
