import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/model/SupportConversationMessagesResponse.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class SupportMessageAttachmentWidget extends StatefulWidget {
  final SupportConversationMessage message;
  final bool isSentByMe;

  const SupportMessageAttachmentWidget({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  State<SupportMessageAttachmentWidget> createState() =>
      _SupportMessageAttachmentWidgetState();
}

class _SupportMessageAttachmentWidgetState
    extends State<SupportMessageAttachmentWidget> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.message.isAudio) {
      _initAudioPlayer();
    }
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioPlayer!.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });
    _audioPlayer!.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });
    _audioPlayer!.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer!.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer!.play(UrlSource(widget.message.attachmentUrl!));
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.isImage) {
      return _buildImageAttachment();
    } else if (widget.message.isVideo) {
      return _buildVideoAttachment();
    } else if (widget.message.isAudio) {
      return _buildAudioAttachment();
    } else if (widget.message.isDocument || widget.message.isFile) {
      return _buildDocumentAttachment();
    }
    return SizedBox.shrink();
  }

  Widget _buildImageAttachment() {
    return GestureDetector(
      onTap: () => _openImageFullScreen(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: widget.message.attachmentUrl!,
          width: 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 200,
            height: 150,
            color: Colors.grey[300],
            child: Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            width: 200,
            height: 150,
            color: Colors.grey[300],
            child: Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoAttachment() {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildAudioAttachment() {
    final duration = _duration.inSeconds;
    final progress = duration > 0 ? _position.inSeconds / duration : 0.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isSentByMe
            ? Colors.white.withOpacity(0.2)
            : context.resources.color.background2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayback,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.isSentByMe
                    ? Colors.white
                    : context.resources.color.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.isSentByMe
                    ? context.resources.color.colorPrimary
                    : Colors.white,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 8),
          // Waveform/Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(
                    widget.isSentByMe
                        ? Colors.white
                        : context.resources.color.colorPrimary,
                  ),
                ),
                SizedBox(height: 4),
                PrimaryText(
                  text: _formatDuration(
                      _isPlaying ? _position : Duration(seconds: duration)),
                  fontSize: 12,
                  textColor: widget.isSentByMe
                      ? Colors.white
                      : context.resources.color.colorGrey,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildDocumentAttachment() {
    return GestureDetector(
      onTap: () => _openFileInBrowser(),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isSentByMe
              ? Colors.white.withOpacity(0.2)
              : context.resources.color.background2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getFileIcon(),
              color: widget.isSentByMe
                  ? Colors.white
                  : context.resources.color.colorPrimary,
              size: 32,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: widget.message.fileName,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: widget.isSentByMe
                        ? Colors.white
                        : context.resources.color.colorBlack,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon() {
    final extension = widget.message.fileExtension;
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void _openImageFullScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: widget.message.attachmentUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.error, color: Colors.white, size: 48),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openFileInBrowser() async {
    final url = widget.message.attachmentUrl;
    if (url == null) return;

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error opening file: $e');
    }
  }
}
