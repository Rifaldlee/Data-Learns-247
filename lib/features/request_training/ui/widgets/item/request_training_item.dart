import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_list.dart';
import 'package:flutter/material.dart';

class RequestTrainingItem extends StatelessWidget {
  final RequestTrainingList requestTrainingList;
  final VoidCallback? onTap;

  const RequestTrainingItem({
    super.key,
    required this.requestTrainingList,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = kLightGreyColor;
    if (requestTrainingList.status == "waiting-approval") {
      statusColor = Colors.orange;
    } else {
      statusColor = kGreenColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(4)
          ),
          color: kWhiteColor
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    )
                  )
                ),
                child: Expanded(
                  child: Row(
                    children: [
                      Text(requestTrainingList.dateCreated.toString()),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(4)
                          ),
                        ),
                        child: Text(
                          requestTrainingList.status.toString(),
                          style: const TextStyle(
                            color: kWhiteColor
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                requestTrainingList.productName.toString(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: kBlackColor,
                    fontWeight: FontWeight.bold
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}