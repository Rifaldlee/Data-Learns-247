import 'package:flutter/material.dart';
import 'package:data_learns_247/core/theme/color.dart';

class EmptyResultScreen extends StatelessWidget {
  const EmptyResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Image(
            image: AssetImage("assets/img/img_ill_2.png")
          ),
        ),
        Text(
          'Oops! Pencarian tidak ditemukan',
          textAlign: TextAlign.center,
          style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: kBlackColor)
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            'Sepertinya tidak ada artikel atau pembelajaran yang sesuai. Coba gunakan kata kunci yang berbeda atau perluas pencarian Anda',
            textAlign: TextAlign.center,
            style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: kBlackColor)
          ),
        )
      ],
    );
  }
}