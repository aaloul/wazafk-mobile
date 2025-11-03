import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_member_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_member_repository.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_network_image.dart';
import '../../../../components/progress_bar.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../../../utils/utils.dart';

class MemberProfileHeader extends StatefulWidget {
  const MemberProfileHeader({
    super.key,
    required this.avatar,
    required this.memberHashcode,
    this.isFavorite = false,
  });

  final String avatar;
  final String memberHashcode;
  final bool isFavorite;

  @override
  State<MemberProfileHeader> createState() => _MemberProfileHeaderState();
}

class _MemberProfileHeaderState extends State<MemberProfileHeader> {
  final AddFavoriteMemberRepository _addFavoriteRepository =
  AddFavoriteMemberRepository();
  final RemoveFavoriteMemberRepository _removeFavoriteRepository =
  RemoveFavoriteMemberRepository();

  var isFavorite = false.obs;
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    isFavorite.value = widget.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (isFavorite.value) {
        // Remove from favorites
        final response = await _removeFavoriteRepository.removeFavoriteMember(
          widget.memberHashcode,
        );

        if (response.success == true) {
          isFavorite.value = false;
          constants.showSnackBar(
            response.message ?? 'Removed from favorites',
            SnackBarStatus.SUCCESS,
          );
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to remove from favorites',
            SnackBarStatus.ERROR,
          );
        }
      } else {
        // Add to favorites
        final response = await _addFavoriteRepository.addFavoriteMember(
          widget.memberHashcode,
        );

        if (response.success == true) {
          isFavorite.value = true;
          constants.showSnackBar(
            response.message ?? 'Added to favorites',
            SnackBarStatus.SUCCESS,
          );
        } else {
          constants.showSnackBar(
            response.message ?? 'Failed to add to favorites',
            SnackBarStatus.ERROR,
          );
        }
      }
    } catch (e) {
      constants.showSnackBar(
        'Error: $e',
        SnackBarStatus.ERROR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 210,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  AppIcons.jobCover,
                  fit: BoxFit.cover,
                  height: 160,
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 16,
            left: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: Utils().isRTL() ? 2 : 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      AppIcons.back,
                      width: 30,
                      color: context.resources.color.colorWhite,
                    ),
                  ),
                ),
                Spacer(),

                Obx(
                      () =>
                      GestureDetector(
                        onTap: isLoading.value ? null : _toggleFavorite,
                        child: isLoading.value
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: ProgressBar(

                          ),
                        )
                            : Image.asset(
                          isFavorite.value
                              ? AppIcons.banomarkOn
                              : AppIcons.banomark,
                          width: 20,
                          color: context.resources.color.colorWhite,
                        ),
                      ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.background2,
                      width: 5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(999999),
                    child: PrimaryNetworkImage(
                      url: widget.avatar,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
