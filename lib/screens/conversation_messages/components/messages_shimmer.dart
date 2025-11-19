import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../components/shimmer_placeholders.dart';

class MessagesShimmer extends StatelessWidget {
  const MessagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const Row(
              children: [
                CirclePlaceHolder(width: 50),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextPlaceHolder(width: 100),
                          Spacer(),
                          TextPlaceHolder(width: 100),
                        ],
                      ),
                      SizedBox(height: 6),
                      TextPlaceHolder(width: 100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
