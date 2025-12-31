import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

class VoiceRecordingWidget extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSend;
  final RecorderController recorderController;

  const VoiceRecordingWidget({
    super.key,
    required this.onCancel,
    required this.onSend,
    required this.recorderController,
  });

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget> {
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  double _slidePosition = 0.0;
  final double _cancelThreshold = -120.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Waveform and timer with slide to cancel overlay
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Slide to cancel text (behind)
                if (_slidePosition > -100)
                  Positioned(
                    left: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: context.resources.color.colorGrey,
                        ),
                        SizedBox(width: 4),
                        PrimaryText(
                          text: "Slide to cancel",
                          fontSize: 14,
                          textColor: context.resources.color.colorGrey,
                        ),
                      ],
                    ),
                  ),

                // Waveform container (on top, slidable)
                GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _slidePosition += details.delta.dx;
                      if (_slidePosition < _cancelThreshold) {
                        widget.onCancel();
                      }
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_slidePosition > _cancelThreshold) {
                      setState(() {
                        _slidePosition = 0.0;
                      });
                    }
                  },
                  child: Transform.translate(
                    offset: Offset(
                        _slidePosition.clamp(_cancelThreshold, 0.0), 0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: context.resources.color.background2,
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          // Recording indicator
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 12),
                          // Timer
                          PrimaryText(
                            text: _formatDuration(_recordingDuration),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: context.resources.color.colorPrimary,
                          ),
                          SizedBox(width: 12),
                          // Waveform
                          Expanded(
                            child: AudioWaveforms(
                              size: Size(double.infinity, 40),
                              recorderController: widget.recorderController,
                              waveStyle: WaveStyle(
                                waveColor:
                                    context.resources.color.colorPrimary,
                                spacing: 4.0,
                                showMiddleLine: false,
                                extendWaveform: true,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          // Send button
          GestureDetector(
            onTap: widget.onSend,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: context.resources.color.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
