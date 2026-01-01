import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_network_image.dart';
import 'package:wazafak_app/model/SupportConversationsResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class ParticipantsAvatarGrid extends StatelessWidget {
  const ParticipantsAvatarGrid({
    super.key,
    required this.participants,
    this.size = 60,
  });

  final List<GroupParticipant> participants;
  final double size;

  @override
  Widget build(BuildContext context) {
    final displayParticipants = participants.take(4).toList();
    final participantCount = displayParticipants.length;

    if (participantCount == 0) {
      return _buildEmptyState(context);
    }

    if (participantCount == 1) {
      return _buildSingleAvatar(displayParticipants[0]);
    }

    if (participantCount == 2) {
      return _buildTwoAvatars(displayParticipants);
    }

    if (participantCount == 3) {
      return _buildThreeAvatars(displayParticipants);
    }

    return _buildFourAvatars(displayParticipants);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.resources.color.colorGrey3.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.people,
        color: context.resources.color.colorGrey3,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildSingleAvatar(GroupParticipant participant) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999999),
      child: PrimaryNetworkImage(
        url: participant.memberImage ?? '',
        width: size,
        height: size,
      ),
    );
  }

  Widget _buildTwoAvatars(List<GroupParticipant> participants) {
    final halfSize = size / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(999999),
              bottomLeft: Radius.circular(999999),
            ),
            child: PrimaryNetworkImage(
              url: participants[0].memberImage ?? '',
              width: halfSize,
              height: size,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(999999),
              bottomRight: Radius.circular(999999),
            ),
            child: PrimaryNetworkImage(
              url: participants[1].memberImage ?? '',
              width: halfSize,
              height: size,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeAvatars(List<GroupParticipant> participants) {
    final halfSize = size / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          // Top: 2 avatars
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(999999),
                ),
                child: PrimaryNetworkImage(
                  url: participants[0].memberImage ?? '',
                  width: halfSize,
                  height: halfSize,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(999999),
                ),
                child: PrimaryNetworkImage(
                  url: participants[1].memberImage ?? '',
                  width: halfSize,
                  height: halfSize,
                ),
              ),
            ],
          ),
          // Bottom: 1 avatar centered
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(999999),
              bottomRight: Radius.circular(999999),
            ),
            child: PrimaryNetworkImage(
              url: participants[2].memberImage ?? '',
              width: size,
              height: halfSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourAvatars(List<GroupParticipant> participants) {
    final halfSize = size / 2;
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          // Top row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(999999),
                ),
                child: PrimaryNetworkImage(
                  url: participants[0].memberImage ?? '',
                  width: halfSize,
                  height: halfSize,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(999999),
                ),
                child: PrimaryNetworkImage(
                  url: participants[1].memberImage ?? '',
                  width: halfSize,
                  height: halfSize,
                ),
              ),
            ],
          ),
          // Bottom row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(999999),
                ),
                child: PrimaryNetworkImage(
                  url: participants[2].memberImage ?? '',
                  width: halfSize,
                  height: halfSize,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(999999),
                ),
                child: PrimaryNetworkImage(
                  url: participants[3].memberImage ?? '',
                  width: halfSize,
                  height: halfSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
