import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/repository/favorite/add_favorite_member_repository.dart';
import 'package:wazafak_app/repository/favorite/remove_favorite_member_repository.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import '../../../../components/primary_network_image.dart';
import '../../../../components/primary_text.dart';
import '../../../../components/progress_bar.dart';
import '../../../../model/LoginResponse.dart';
import '../../../../utils/res/AppIcons.dart';
import '../../../../utils/utils.dart';

class FreelancerProfileHeader extends StatefulWidget {
  const FreelancerProfileHeader({
    super.key,
    this.isFavorite = false,
    required this.user,
  });

  final User user;
  final bool isFavorite;

  @override
  State<FreelancerProfileHeader> createState() => _MemberProfileHeaderState();
}

class _MemberProfileHeaderState extends State<FreelancerProfileHeader> {
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
        final response = await _removeFavoriteRepository.removeFavoriteMember(
          widget.user.hashcode.toString(),
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
        final response = await _addFavoriteRepository.addFavoriteMember(
          widget.user.hashcode.toString(),
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
      constants.showSnackBar('Error: $e', SnackBarStatus.ERROR);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 240,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 210,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: context.resources.color.colorBlueL2,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 16,
            left: 16,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: context.resources.color.colorWhite,
                border: Border.all(
                  width: 1,
                  color: context.resources.color.colorGrey25,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  ProfileHeaderItem(
                    icon: AppIcons.checkCircle,
                    title: context.resources.strings.jobsDone,
                    value: '${widget.user.nbCompletedJobs ?? '0'}',
                  ),
                  ProfileHeaderItem(
                    icon: AppIcons.bag,
                    title: context.resources.strings.services,
                    value: '${widget.user.services?.length ?? '0'}',
                  ),
                  ProfileHeaderItem(
                    icon: AppIcons.star,
                    title: context.resources.strings.rating,
                    value: '${widget.user.rating}/5',
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),

          Positioned(
            top: 16,
            right: 16,
            left: 16,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: Utils().isRTL() ? 2 : 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(AppIcons.back3, width: 38),
                      ),
                    ),
                    Spacer(),
                    Obx(
                      () => GestureDetector(
                        onTap: isLoading.value ? null : _toggleFavorite,
                        child: isLoading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: ProgressBar(),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.resources.color.colorGrey15,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    isFavorite.value
                                        ? AppIcons.banomarkOn
                                        : AppIcons.banomark,
                                    width: 18,
                                    color: context.resources.color.colorPrimary,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SizedBox(
                      width: 95,
                      height: 95,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(999999),
                        child: PrimaryNetworkImage(
                          url: widget.user.image.toString(),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          PrimaryText(
                                text:
                                    '${widget.user.firstName} ${widget.user.lastName}',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textColor: context.resources.color.colorBlack4,
                              ),
                            SizedBox(height: 4),
                            Container(
                              width: 65,
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: context.resources.color.colorWhite,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: context.resources.color.colorGrey25,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppIcons.star2, width: 14),
                                  SizedBox(width: 2),
                                  PrimaryText(
                                    text: widget.user.rating ?? 'N/A',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    textColor:
                                        context.resources.color.colorPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderItem extends StatelessWidget {
  const ProfileHeaderItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final String icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.resources.color.colorBlueL,
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: 18,
                color: context.resources.color.colorPrimary,
              ),
            ),
          ),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PrimaryText(
                text: value,
                textColor: context.resources.color.colorPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
              SizedBox(height: 2),
              PrimaryText(
                text: title,
                textColor: context.resources.color.colorGrey26,
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
