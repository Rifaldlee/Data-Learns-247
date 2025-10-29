import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/date_formater.dart';
import 'package:data_learns_247/features/notification/data/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final Data data;

  const NotificationItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String date = data.date.toString();
    DateComponents time = dateFormater(date);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: SizedBox.fromSize(
            size: const Size.fromRadius(32),
            child: const Image(
              image: AssetImage("assets/img/default_image_datalearns.png")
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      color: kBlueColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(4)
                      ),
                    ),
                    child: Text(
                      data.type.toString(),
                      style: const TextStyle(
                        color: kWhiteColor
                      ),
                    )
                  ),
                  const Spacer(),
                  Text(
                    time.hourMinute
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.message.toString(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: kBlackColor,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}