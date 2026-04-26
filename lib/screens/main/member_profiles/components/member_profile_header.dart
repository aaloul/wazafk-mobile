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

class MemberProfileHeader extends StatefulWidget {
  const MemberProfileHeader({
    super.key,
    this.isFavorite = false,
    required this.user, required this.isEmployer,
  });

  final User user;
  final bool isFavorite;
  final bool isEmployer;

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
        // Add to favorites
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
      height: 300,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: context.resources.color.colorPrimary,
                  ),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x004EA9EE), Color(0x1C3CA0ED)],
                ),
              ),

              child: Row(children: [

                SizedBox(width: 16,),

                ProfileHeaderItem(icon: AppIcons.checkCircle, title: 'Jobs done', value:  '${widget.user.nbCompletedJobs ?? '0'}',),
                ProfileHeaderItem(icon: AppIcons.bag, title: 'Services', value: '${widget.user.services?.length ?? '0'}',),
                ProfileHeaderItem(icon: AppIcons.star, title: 'Rating', value: '${widget.user.rating}/5',),
                SizedBox(width: 16,),

              ]),
            ),
          ),

          Positioned(
            top: 40,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x004EA9EE), Color(0xFF4EA9EE)],
                    ),
                  ),
                ),
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

                SizedBox(height: 16),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: PrimaryText(
                          text:
                              '${widget.user.firstName} ${widget.user.lastName}',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          textColor: context.resources.color.colorWhite,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimary.withAlpha(
                            80,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Image.asset(AppIcons.star2, width: 12),
                            SizedBox(width: 2),
                            PrimaryText(
                              text: widget.user.rating ?? 'N/A',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              textColor: context.resources.color.colorWhite,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class ProfileHeaderItem extends StatelessWidget {
  const ProfileHeaderItem({super.key, required this.icon, required this.title, required this.value});

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
              color: context.resources.color.colorWhite,
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
              SizedBox(height: 2,),
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
