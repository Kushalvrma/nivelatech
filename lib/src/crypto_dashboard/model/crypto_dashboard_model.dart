class CryptoModel {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double marketCap;
  final double volume24h;
  final double priceChange24h;
  final DateTime lastUpdated;

  CryptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.priceChange24h,
    required this.lastUpdated,
  });

  // Factory method to create a CryptoModel from JSON with additional details
  factory CryptoModel.fromJson(Map<String, dynamic> json, Map<String, dynamic> priceDetails) {
    return CryptoModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? '',
      price: priceDetails['usd'] != null ? priceDetails['usd'].toDouble() : 0.0,
      marketCap: priceDetails['usd_market_cap'] != null ? priceDetails['usd_market_cap'].toDouble() : 0.0,
      volume24h: priceDetails['usd_24h_vol'] != null ? priceDetails['usd_24h_vol'].toDouble() : 0.0,
      priceChange24h: priceDetails['usd_24h_change'] != null ? priceDetails['usd_24h_change'].toDouble() : 0.0,
      lastUpdated: priceDetails['last_updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(priceDetails['last_updated_at'] * 1000)
          : DateTime.now(),
    );
  }

  // Override toString() to print relevant data
  @override
  String toString() {
    return 'CryptoModel{id: $id, name: $name, symbol: $symbol, price: \$${price.toStringAsFixed(8)}, marketCap: \$${marketCap.toStringAsFixed(2)}, volume24h: \$${volume24h.toStringAsFixed(2)}, priceChange24h: ${priceChange24h.toStringAsFixed(2)}%, lastUpdated: $lastUpdated}';
  }
}
