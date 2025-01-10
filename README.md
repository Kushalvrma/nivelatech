# nivelatech

cryptocurrency-price-alert-system

## Getting Started

This project is a Cryptocurrency Price Alert System built using Flutter and Dart. The app allows users to monitor real-time cryptocurrency prices and get alerts when their target price thresholds are met.

Features

1. Fetch Real-Time Price Data

Utilizes the CoinGecko API to retrieve cryptocurrency price data.

Fetches additional details such as market cap, 24-hour volume, and price change percentage.

2. User Input

Provides a user-friendly interface to:

Input cryptocurrency symbols (e.g., BTC, ETH).

Set target price thresholds (both upper and lower bounds).

3. Price Monitoring

Automatically checks cryptocurrency prices at regular intervals (default: every 5 minutes).

Allows users to start and stop price monitoring.

4. Alert Mechanism

Sends real-time alerts when the price conditions are met using GetX Snackbar notifications.

5. Additional Features

Displays a list of the top 50 cryptocurrencies with details like price, market cap, and 24-hour change.

Supports monitoring of multiple cryptocurrencies simultaneously.

Dependencies

The project uses the following key dependencies:


http  ^1.0.0
To make HTTP requests to the CoinGecko API.

get ^4.6.0

For state management, navigation, and dependency injection.

intl

^0.18.0

To format dates for cryptocurrency data.

API Usage

This project uses the CoinGecko API to:

Fetch a list of cryptocurrencies:

Endpoint: https://api.coingecko.com/api/v3/coins/list

Retrieve detailed price data:

Endpoint: https://api.coingecko.com/api/v3/simple/price

Query parameters include:

ids (comma-separated crypto IDs)

vs_currencies (e.g., USD)

Additional parameters for market cap, volume, etc.