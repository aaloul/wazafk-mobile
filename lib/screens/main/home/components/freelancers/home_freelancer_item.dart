import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/LoginResponse.dart';
import 'package:wazafak_app/repository/favorite/favorite_members_repository.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/utils.dart';

import '../../../../../utils/res/AppIcons.dart';

class HomeFreelancerItem extends StatefulWidget {
  const HomeFreelancerItem({super.key, required this.freelancer});

  final User freelancer;

  @override
  State<HomeFreelancerItem> createState() => _HomeFreelancerItemState();
}

class _HomeFreelancerItemState extends State<HomeFreelancerItem> {
  final _favoriteMembersRepository = FavoriteMembersRepository();
  late RxBool isFavorite;
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    isFavorite = (widget.freelancer.isFavorite == 1).obs;
  }

  Future<void> toggleFavorite() async {
    if (isLoading.value || widget.freelancer.hashcode == null) return;

    try {
      isLoading.value = true;
      final previousState = isFavorite.value;
      isFavorite.value = !isFavorite.value;

      final response = isFavorite.value
          ? await _favoriteMembersRepository.addFavoriteMember(
              widget.freelancer.hashcode!,
            )
          : await _favoriteMembersRepository.removeFavoriteMember(
              widget.freelancer.hashcode!,
            );

      if (response.success == true) {
        constants.showSnackBar(
          response.message ??
              (isFavorite.value
                  ? 'Added to favorites'
                  : 'Removed from favorites'),
          SnackBarStatus.SUCCESS,
        );
      } else {
        // Revert on failure
        isFavorite.value = previousState;
        constants.showSnackBar(
          response.message ?? 'Failed to update favorites',
          SnackBarStatus.ERROR,
        );
      }
    } catch (e) {
      // Revert on error
      isFavorite.value = !isFavorite.value;
      constants.showSnackBar(
        'Error updating favorites: $e',
        SnackBarStatus.ERROR,
      );
      print('Error toggling favorite: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToMemberProfile() {
    if (widget.freelancer.hashcode == null) return;

    // Convert HomeFreelancer to User
    final user = User(
      entityType: widget.freelancer.entityType,
      hashcode: widget.freelancer.hashcode,
      code: widget.freelancer.code,
      title: widget.freelancer.title,
      firstName: widget.freelancer.firstName,
      lastName: widget.freelancer.lastName,
      mobile: widget.freelancer.mobile,
      email: widget.freelancer.email,
      dateOfBirth: widget.freelancer.dateOfBirth,
      gender: widget.freelancer.gender,
      image: widget.freelancer.image,
      country: widget.freelancer.country,
      info: widget.freelancer.info,
      workExperience: widget.freelancer.workExperience,
      website: widget.freelancer.website,
      rating: widget.freelancer.rating,
      joinDate: widget.freelancer.joinDate,
      joinYear: widget.freelancer.joinYear,
      timezone: widget.freelancer.timezone,
      language: widget.freelancer.language,
      idVerified: widget.freelancer.idVerified,
      idVerifiedDatetime: widget.freelancer.idVerifiedDatetime,
      documentType: widget.freelancer.documentType,
      document1: widget.freelancer.document1,
      document2: widget.freelancer.document2,
      documentPassport: widget.freelancer.documentPassport,
      documentForeignLegal1: widget.freelancer.documentForeignLegal1,
      documentForeignLegal2: widget.freelancer.documentForeignLegal2,
      documentForeignPaperwork: widget.freelancer.documentForeignPaperwork,
      status: widget.freelancer.status,
      nbJobPosts: widget.freelancer.nbJobPosts,
      nbHiredFreelancers: widget.freelancer.nbHiredFreelancers,
      nbCompletedJobs: widget.freelancer.nbCompletedJobs,
      isFavorite: widget.freelancer.isFavorite,
    );

    Get.toNamed(RouteConstant.freelancerMemberProfileScreen, arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToMemberProfile,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.resources.color.colorGrey18,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Freelancer Header
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resources.color.colorPrimary,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: PrimaryNetworkImage(
                      url: widget.freelancer.image ?? '',
                      width: 45,
                      height: 45,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: PrimaryText(
                              text:
                                  '${widget.freelancer.firstName ?? ''} ${widget.freelancer.lastName ?? ''}'
                                      .trim(),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              textColor: context.resources.color.colorBlack,
                            ),
                          ),
                          // Rating beside name
                          if (widget.freelancer.rating != null) ...[
                            SizedBox(width: 2),
                            Icon(Icons.star, color: Colors.amber, size: 13),
                            PrimaryText(
                              text: widget.freelancer.rating!,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: context.resources.color.colorBlack,
                            ),
                          ],
                        ],
                      ),
                      if (widget.freelancer.title != null &&
                          widget.freelancer.title!.isNotEmpty)
                        PrimaryText(
                          text: widget.freelancer.title!,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorGrey19,
                        ),
                    ],
                  ),
                ),
                // Bookmark Icon
                Obx(
                  () => GestureDetector(
                    onTap: toggleFavorite,
                    child: isLoading.value
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.resources.color.colorPrimary,
                              ),
                            ),
                          )
                        : Image.asset(
                            isFavorite.value
                                ? AppIcons.banomarkOn
                                : AppIcons.banomark,
                            width: 18,
                          ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            PrimaryText(
              text: widget.freelancer.info.toString().isEmpty
                  ? 'N/A'
                  : widget.freelancer.info ?? 'N/A',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              textColor: context.resources.color.colorGrey19,
              maxLines: 2,
            ),

            // Services & Packages combined
            if ((widget.freelancer.services != null &&
                    widget.freelancer.services!.isNotEmpty) ||
                (widget.freelancer.packages != null &&
                    widget.freelancer.packages!.isNotEmpty)) ...[
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 1,
                color: context.resources.color.colorGrey18,
              ),
              SizedBox(height: 12),
              PrimaryText(
                text: 'Services & Packages',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: context.resources.color.colorBlack,
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Services
                  if (widget.freelancer.services != null)
                    ...widget.freelancer.services!.map(
                      (service) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: context.resources.color.colorPrimary
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: PrimaryText(
                          text: service.title ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorBlack,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  // Packages
                  if (widget.freelancer.packages != null)
                    ...widget.freelancer.packages!.map(
                      (package) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.resources.color.colorPrimary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: context.resources.color.colorPrimary
                                .withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: PrimaryText(
                          text: package.title ?? '',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: context.resources.color.colorBlack,
                          maxLines: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
