import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/CategoriesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class HomeCategoryItem extends StatelessWidget {
  const HomeCategoryItem({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: .5,
                color: context.resources.color.colorBlue,
              ),
            ),
            child: PrimaryNetworkImage(
              url: category.icon.toString(),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SizedBox(height: 5),

          PrimaryText(
            text: category.name.toString(),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
