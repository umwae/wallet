class AssetItemVM {
  final String name;
  final String value;
  final String amount;
  final String price;
  final String? iconURL;
  final String? priceChangePercentage24h;

  const AssetItemVM({
    required this.name,
    required this.value,
    required this.amount,
    required this.price,
    this.iconURL,
    this.priceChangePercentage24h,
  });
}
