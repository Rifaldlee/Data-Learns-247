import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  const ErrorDialogWidget({super.key, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 370,
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: kRedColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Icon(
                Icons.error_outline,
                color: kWhiteColor,
                size: 64
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message,
                      style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: kBlackColor),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                    ),
                    TextButton(
                      onPressed: onClose,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 48
                        ),
                        backgroundColor: kRedColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: kWhiteColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}