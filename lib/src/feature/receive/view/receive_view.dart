import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stonwallet/src/core/constant/png.dart';

class ReceiveView extends StatelessWidget {
  final String? address;
  const ReceiveView({this.address, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final qrData = _generateQrData(address: address);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                // Дополнительные параметры для кастомизации:
                embeddedImage: const AssetImage(PathsPng.tonSymbol), // Логотип в центре
                // embeddedImageSize: const Size(40, 40),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  address ?? '??????????????????',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                  maxLines: null,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                color: colorScheme.primary,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address ?? '??????????????????'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Адрес скопирован')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _generateQrData({String? address}) {
    return 'ton://transfer/$address';
  }
}
