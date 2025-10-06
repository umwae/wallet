import 'package:stonwallet/src/core/exceptions/app_exception.dart';
import 'package:stonwallet/src/core/exceptions/app_exception_mapper.dart';
import 'package:stonwallet/src/core/utils/logger.dart';
import 'package:stonwallet/src/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:stonwallet/src/feature/transactions/domain/mappers/transaction_entity_mapper.dart';
import 'package:tonutils/tonutils.dart';
import 'package:stonwallet/src/feature/crypto/domain/repositories/ton_wallet_repository.dart';
import 'package:stonwallet/src/core/service/secure_storage_service.dart';
import 'package:stonwallet/src/core/constant/api_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TonWalletRepositoryImpl implements TonWalletRepository {
  final Logger? logger;
  final baseUrl = dotenv.env['TON_TESTNET_URL']!;

  TonWalletRepositoryImpl({this.logger});

  @override
  Future<double?> getBalance(dynamic openedWallet) async {
    try {
      final balanceNano = await (openedWallet as WalletContractV4R2).getBalance();
      final balance = balanceNano / BigInt.from(1e9.toInt());
      final addr =
          openedWallet.address.toString(isUrlSafe: true, isBounceable: true, isTestOnly: true);
      logger
          ?.info('Wallet address: $addr, balance: $balance, workChain: ${openedWallet.workChain}');
      return balance;
    } on Object catch (e, st) {
      Error.throwWithStackTrace(e.toAppException(), st);
    }
  }

  @override
  Future<WalletContractV4R2> openWallet(SecureStorageService secureStorage) async {
    try {
      var keyPair = await secureStorage.getKeyPair();
      keyPair ??= await _generateAndSaveKeyPair(secureStorage);
      final wallet = WalletContractV4R2.create(publicKey: keyPair.publicKey);
      final client = TonJsonRpc('$baseUrl/jsonRPC', testnetApiKey);
      final opened = client.open(wallet);
      logger?.info(
        'Wallet opened: ${wallet.address.toString(isUrlSafe: true, isBounceable: true, isTestOnly: true)}',
      );
      return opened;
    } on Object catch (e, st) {
      Error.throwWithStackTrace(e.toAppException(), st);
    }
  }

  Future<KeyPair> _generateAndSaveKeyPair(SecureStorageService secureStorage) async {
    try {
      final mnemonics = tonkeeperMnemonics.split(' ');
      final keyPair = Mnemonic.toKeyPair(
        mnemonics,
      ); //TODO: запускать в отдельном потоке - секунд 40 генерит, очень долго
      await secureStorage.saveKeyPair(keyPair);
      return keyPair;
    } on Object catch (e, st) {
      Error.throwWithStackTrace(DataException('Key generation error', inner: e), st);
    }
  }

  @override
  Future<List<TransactionEntity>> fetchTransactions(InternalAddress address) async {
    try {
      final client = TonJsonRpc('$baseUrl/jsonRPC', testnetApiKey);
      var transactions = <Transaction>[];
      transactions = await client.getTransactions(
        address,
        limit: 2,
      );

      final entities = <TransactionEntity>[];
      for (final tx in transactions) {
        final separatedTransactions = mapRawTransaction(tx, address.toString());
        entities.addAll(separatedTransactions);
      }
      return entities;
    } on Object catch (e, st) {
      Error.throwWithStackTrace(e.toAppException(), st);
    }
  }

  @override
  Future<void> createTransfer(
    WalletContractV4R2 openedContract,
    String address,
    String amount,
    String message,
    SecureStorageService secureStorage,
  ) async {
    try {
      var keyPair = await secureStorage.getKeyPair();
      keyPair ??= await _generateAndSaveKeyPair(secureStorage);
      final seqno = await openedContract.getSeqno();
      final transfer = openedContract.createTransfer(
        seqno: seqno,
        privateKey: keyPair.privateKey,
        messages: [
          internal(
            to: SiaString(address),
            value: SbiString(amount.toString()),
            body: ScString(message),
          ),
        ],
      );
      logger?.info(
        'New transfer: $amount TON to $address}',
      );
    } on Object catch (e, st) {
      Error.throwWithStackTrace(e.toAppException(), st);
    }
  }
}
