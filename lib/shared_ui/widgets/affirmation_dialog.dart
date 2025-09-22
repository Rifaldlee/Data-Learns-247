import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class AffirmationDialog extends StatelessWidget {
  final String message;
  final String cancelText;
  final String proceedText;
  final Function() onProceed;
  final Function()? onCancel;

  const AffirmationDialog({
    super.key,
    required this.message,
    this.cancelText = 'Batal',
    this.proceedText = 'Iya',
    required this.onProceed,
    this.onCancel,
  });

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
            const ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image(
                image: AssetImage('assets/img/hero-img.jpg'),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16
                ),
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
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex : 2,
                          child: OutlinedButton(
                            onPressed: onCancel ?? () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              fixedSize: const Size(
                                double.infinity,
                                48
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: const BorderSide(
                                width: 3,
                                color: kRedColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Text(
                              cancelText,
                              style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: kRedColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: onProceed,
                            style: TextButton.styleFrom(
                              backgroundColor: kGreenColor,
                              fixedSize: const Size(
                                double.infinity,
                                48
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              ),
                            ),
                            child: Text(
                              proceedText,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: kWhiteColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}