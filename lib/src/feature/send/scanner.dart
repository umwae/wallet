import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stonwallet/src/feature/navdec/deeplink_block.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  String barcodeResult = 'Point the camera at a barcode';
  String? lastProcessedLink;
  DateTime? _lastScan;

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty || barcodes.first.rawValue == null) return;

    final now = DateTime.now();
    if (_lastScan != null && now.difference(_lastScan!) < const Duration(seconds: 2)) {
      // Игнорируем частые вызовы
      return;
    }
    _lastScan = now;

    final link = barcodes.first.rawValue!;
    context.read<DeepLinkBloc>().add(DeepLinkReceived(Uri.parse(link)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                barcodeResult,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
