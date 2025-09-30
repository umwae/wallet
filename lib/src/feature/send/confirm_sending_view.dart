import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stonwallet/src/core/constant/svg.dart';
import 'package:stonwallet/src/core/utils/extensions/string_extension.dart';
import 'package:stonwallet/src/core/widget/base_page.dart';
import 'package:stonwallet/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:stonwallet/src/feature/send/cubit/confirm_sending_cubit.dart';
import 'package:tonutils/tonutils.dart' show WalletContractV4R2;

class ConfirmSendingView extends BaseStatefulPage {
  final String? address;

  const ConfirmSendingView({
    required this.address,
    super.key,
  });

  @override
  State<ConfirmSendingView> createState() => _ConfirmSendingViewState();
}

class _ConfirmSendingViewState extends BaseStatefulPageState<ConfirmSendingView> {
  late TextEditingController _amountController;
  late TextEditingController _commentController;
  final String initialAmount = '';
  final String initialComment = '';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: initialAmount);
    _commentController = TextEditingController(text: initialComment);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm(BuildContext context, WalletContractV4R2 openedContract) async {
    if (widget.address == null || widget.address!.isEmpty) return;
    final amount = _amountController.text;
    final comment = _commentController.text;

    await context.read<TransferCubit>().createTransfer(
          openedContract: openedContract,
          address: widget.address ?? '',
          amount: amount,
          message: comment,
        );
  }

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final deps = DependenciesScope.of(context);
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text('Подтверждение отправки'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Адрес получателя:', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  widget.address?.shortForm() ?? '',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SvgPicture.asset(PathsSvg.tonLogoDark, height: 50),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Card(
              // color: colorScheme.surfaceVariant,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        // fillColor: colorScheme.surfaceVariant,
                        // filled: true,
                        hintText: '0.00 TON',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Комментарий (необязательно)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: BlocListener<TransferCubit, TransferState>(
                listener: (context, state) {
                  if (state is TransferIdle && state.amount != null) {
                    // Показываем snackbar и закрываем страницу
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Отправлены ${state.amount} TON по адресу ${widget.address}'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: FilledButton(
                  onPressed: () => _onConfirm(context, deps.openedWallet),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                  child: const Text('Подтвердить и отправить'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
