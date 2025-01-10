import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/crypto_dashboard_controller.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  final CryptoController _controller = Get.put(CryptoController());

  @override
  void initState() {
    super.initState();
    _controller.startPriceMonitoring();
    _controller.fetchInitialData(); // Fetch data when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto List with Price Monitoring'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.cryptoList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller.cryptoSymbolController,
                  onChanged: (value) {
                    _controller.selectedCryptoSymbol(value.toUpperCase());
                  },
                  decoration: InputDecoration(labelText: 'Enter Crypto Symbol (e.g., BTC)'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller.targetPriceController,
                  onChanged: (value) {
                    double? newTargetPrice = double.tryParse(value);
                    if (newTargetPrice != null) {
                      _controller.targetPrice.value = newTargetPrice;
                    }
                  },
                  decoration: InputDecoration(labelText: 'Set Target Price'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _controller.startPriceMonitoring();
                    },
                    child: Text('Start Monitoring'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _controller.stopPriceMonitoring();
                    },
                    child: Text('Cancel Monitoring'),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _controller.cryptoList.length,
                itemBuilder: (context, index) {
                  final crypto = _controller.cryptoList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              crypto.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Symbol: ${crypto.symbol}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Price: \$${crypto.price.toStringAsFixed(6)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Market Cap: \$${crypto.marketCap.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '24h Volume: \$${crypto.volume24h.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '24h Change: ${crypto.priceChange24h.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: crypto.priceChange24h > 0 ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Last Updated: ${DateFormat('dd-MM-yyyy').format(crypto.lastUpdated)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
