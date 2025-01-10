import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/crypto_dashboard_model.dart';
import '../service/crypto_dashboard_service.dart';

class CryptoController extends GetxController {
  final CryptoService _cryptoService = CryptoService();
  RxList<CryptoModel> cryptoList = RxList<CryptoModel>();
  RxBool isLoading = true.obs;
  RxBool hasMore = true.obs;
  int limit = 50;
  RxDouble targetPrice = 0.0.obs;
  RxString selectedCryptoSymbol = ''.obs;

  TextEditingController targetPriceController = TextEditingController();
  TextEditingController cryptoSymbolController = TextEditingController();

  Timer? _priceCheckTimer;
  Timer? _dataRefreshTimer;

  @override
  void onClose() {
    targetPriceController.dispose();
    cryptoSymbolController.dispose();
    _priceCheckTimer?.cancel();
    _dataRefreshTimer?.cancel();
    super.onClose();
  }

  // Fetch initial data
  Future<void> fetchInitialData() async {
    isLoading(true); // Start loading
    try {
      // Fetch the first batch of cryptocurrencies (50)
      List<Map<String, dynamic>> cryptoData = await _cryptoService.fetchCryptoList();
      List<String> cryptoIds = cryptoData.take(limit).map((crypto) => crypto['id'] as String).toList();

      // Fetch the prices and other details for the selected cryptocurrencies
      Map<String, dynamic> prices = await _cryptoService.fetchCryptoPrices(cryptoIds);

      // Create list of CryptoModel with price and additional details
      cryptoList.addAll(cryptoData.take(limit).map((crypto) {
        return CryptoModel.fromJson(crypto, prices[crypto['id']] ?? {});
      }).toList());
    } catch (e) {
      print('Error: $e');
    }
    isLoading(false); // Stop loading
  }

  // Fetch updated data for cryptocurrencies every 10 seconds
  Future<void> fetchUpdatedData() async {
    try {
      // Fetch the latest list of cryptocurrencies (50)
      List<Map<String, dynamic>> cryptoData = await _cryptoService.fetchCryptoList();
      List<String> cryptoIds = cryptoData.take(limit).map((crypto) => crypto['id'] as String).toList();

      // Fetch the latest prices and other details for the selected cryptocurrencies
      Map<String, dynamic> prices = await _cryptoService.fetchCryptoPrices(cryptoIds);

      // Update the cryptoList with the fresh data
      cryptoList.clear(); // Clear the existing list
      cryptoList.addAll(cryptoData.take(limit).map((crypto) {
        return CryptoModel.fromJson(crypto, prices[crypto['id']] ?? {});
      }).toList());print(cryptoList);
     print("---------ssssssssss");
      // Trigger UI update by calling update()
      update();
    } catch (e) {
      print('Error fetching updated data: $e');
    }
  }

  // Start monitoring the cryptocurrency prices and data refresh every 10 seconds
  void startPriceMonitoring() {
    // Fetch the updated data every 10 seconds
    _dataRefreshTimer = Timer.periodic(Duration(seconds: 15), (timer) async {
      await fetchUpdatedData(); // Fetch the latest data and prices
    });

    if (_priceCheckTimer != null) {
      _priceCheckTimer!.cancel();
    }

    // Price monitoring functionality (checking if target price is reached)
    _priceCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (selectedCryptoSymbol.isNotEmpty && targetPrice.value > 0) {
        // Search for the selected cryptocurrency by its symbol
        var currentCrypto = cryptoList.firstWhere(
              (crypto) => crypto.symbol.toLowerCase() == selectedCryptoSymbol.value.toLowerCase(),
          orElse: () => CryptoModel(
            id: '',
            name: 'Unknown',
            symbol: selectedCryptoSymbol.value,
            price: 0.0,
            marketCap: 0.0,
            volume24h: 0.0,
            priceChange24h: 0.0,
            lastUpdated: DateTime.now(),
          ),
        );

        print("Checking price for ${currentCrypto.symbol}: \$${currentCrypto.price} against target \$${targetPrice.value}");

        // Adjusting comparison with tolerance
        const double tolerance = 0.00001;
        if ((currentCrypto.price - targetPrice.value).abs() < tolerance) {
          print("Price reached target!");
          Get.snackbar(
            "Price Alert",
            "${currentCrypto.name} has reached the target price of \$${targetPrice.value.toStringAsFixed(8)}",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    });
  }

  // Stop monitoring
  void stopPriceMonitoring() {
    targetPriceController.clear();
    cryptoSymbolController.clear();
    _priceCheckTimer?.cancel();
    _dataRefreshTimer?.cancel();
  }
}
