import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoService {
  final String baseUrl = "https://api.coingecko.com/api/v3";

  // Fetch list of cryptocurrencies from CoinGecko
  Future<List<Map<String, dynamic>>> fetchCryptoList() async {
    final listUrl = Uri.parse('$baseUrl/coins/list');
    final response = await http.get(listUrl);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cryptocurrency list');
    }
  }

  // Fetch prices and other data for selected cryptocurrencies
  Future<Map<String, dynamic>> fetchCryptoPrices(List<String> ids) async {
    final idsStr = ids.join(',');
    final priceUrl = Uri.parse('$baseUrl/simple/price?ids=$idsStr&vs_currencies=usd&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true');
    final response = await http.get(priceUrl);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load cryptocurrency prices');
    }
  }
}
