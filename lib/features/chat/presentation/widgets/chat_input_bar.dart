import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../services/location/location_service.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSendText;
  final Function(String) onSendImage;
  final Function(String, int) onSendVoice;
  final Function(double, double, String)? onSendLocation;

  const ChatInputBar({
    super.key,
    required this.onSendText,
    required this.onSendImage,
    required this.onSendVoice,
    this.onSendLocation,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_hasText) {
      widget.onSendText(_controller.text);
      _controller.clear();
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: AppColors.mainAppPrimary),
              title: Text(
                'Make a Call',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _mockCall();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: AppColors.mainAppPrimary),
              title: Text(
                'Send an Image',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndSendImage();
              },
            ),
            if (widget.onSendLocation != null)
              ListTile(
                leading: const Icon(Icons.location_on, color: AppColors.mainAppPrimary),
                title: Text(
                  'Partager ma position',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _shareLocation();
                },
              ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppColors.mainAppPrimary),
              title: Text(
                'Send PDF / Document',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _mockSendPDF();
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppColors.mainAppPrimary),
              title: Text(
                'Share Location',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location shared (mock)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mockCall() {
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting voice call... (mock)')),
    );
  }

  void _mockSendPDF() {
     widget.onSendText('📄 Attached Document: invoice_repair.pdf');
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF document sent (mock)')),
    );
  }

  void _pickAndSendImage() {
    // Mock: send a sample image
    final sampleImages = [
      'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=400',
      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
      'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400',
    ];
    final randomImage = sampleImages[DateTime.now().millisecond % sampleImages.length];
    widget.onSendImage(randomImage);
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    // Mock: simulate recording for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_isRecording) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    if (!_isRecording) return;
    setState(() {
      _isRecording = false;
    });
    // Mock: send voice message with random duration
    final duration = 3 + (DateTime.now().millisecond % 10);
    widget.onSendVoice('mock_voice_url', duration);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message vocal envoyé (${duration}s)', style: GoogleFonts.poppins()),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _shareLocation() async {
    if (widget.onSendLocation == null) return;

    final locationService = LocationService();
    final status = await locationService.checkPermission();

    if (status != LocationPermissionStatus.granted) {
      final requestStatus = await locationService.requestPermission();
      if (requestStatus != LocationPermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Permission de localisation requise',
                style: GoogleFonts.poppins(),
              ),
            ),
          );
        }
        return;
      }
    }

    final position = await locationService.getCurrentPosition();
    if (position != null) {
      widget.onSendLocation!(
        position.latitude,
        position.longitude,
        'Ma position',
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible d\'obtenir votre position',
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _isRecording ? _buildRecordingUI() : _buildNormalUI(),
      ),
    );
  }

  Widget _buildNormalUI() {
    return Row(
      children: [
        IconButton(
          onPressed: _showAttachmentMenu,
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.mainAppPrimary,
        ),
        IconButton(
          onPressed: _pickAndSendImage,
          icon: const Icon(Icons.image_outlined),
          color: AppColors.mainAppPrimary,
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Écrire un message…',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            style: GoogleFonts.poppins(fontSize: 14),
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) => _handleSend(),
          ),
        ),
        if (_hasText)
          IconButton(
            onPressed: _handleSend,
            icon: const Icon(Icons.send),
            color: AppColors.mainAppPrimary,
          )
        else
          GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.mic,
                color: AppColors.mainAppPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecordingUI() {
    return Row(
      children: [
        Icon(Icons.mic, color: AppColors.error),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Enregistrement en cours...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: _stopRecording,
          icon: const Icon(Icons.send),
          color: AppColors.mainAppPrimary,
        ),
      ],
    );
  }
}
