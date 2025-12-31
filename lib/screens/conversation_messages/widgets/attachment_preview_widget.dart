import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class AttachmentPreviewWidget extends StatefulWidget {
  final File file;
  final String attachmentType;
  final String? fileName;
  final VoidCallback onRemove;

  const AttachmentPreviewWidget({
    super.key,
    required this.file,
    required this.attachmentType,
    this.fileName,
    required this.onRemove,
  });

  @override
  State<AttachmentPreviewWidget> createState() =>
      _AttachmentPreviewWidgetState();
}

class _AttachmentPreviewWidgetState extends State<AttachmentPreviewWidget> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.attachmentType == 'video') {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.file(widget.file);
    await _videoController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.resources.color.background2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Preview thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: _buildPreview(),
          ),
          SizedBox(width: 12),
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryText(
                  text: widget.fileName ?? 'Attachment',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                PrimaryText(
                  text: _getFileSize(),
                  fontSize: 12,
                  textColor: context.resources.color.colorGrey,
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            icon: Icon(Icons.close, color: context.resources.color.colorGrey),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    switch (widget.attachmentType) {
      case 'image':
        return Image.file(
          widget.file,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        );
      case 'video':
        if (_videoController != null &&
            _videoController!.value.isInitialized) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: VideoPlayer(_videoController!),
              ),
              Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
            ],
          );
        }
        return Container(
          width: 60,
          height: 60,
          color: Colors.black12,
          child: Icon(Icons.videocam, color: Colors.grey),
        );
      case 'document':
      case 'file':
      default:
        return Container(
          width: 60,
          height: 60,
          color: context.resources.color.colorPrimary.withOpacity(0.1),
          child: Icon(
            _getFileIcon(),
            color: context.resources.color.colorPrimary,
            size: 30,
          ),
        );
    }
  }

  IconData _getFileIcon() {
    final extension = widget.fileName?.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileSize() {
    final bytes = widget.file.lengthSync();
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
