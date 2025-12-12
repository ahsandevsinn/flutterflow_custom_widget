import 'dart:developer';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class ChallengeWidget extends StatefulWidget {
  const ChallengeWidget({super.key});

  @override
  State<ChallengeWidget> createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [AddChallengeWidget(),
        Padding(
        padding: const EdgeInsets.only(left: 30, top: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('challenges')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No challenges found.'));
            }

            // Get the most recent challenge (first document in the sorted list)
            DocumentSnapshot mostRecentChallenge = snapshot.data!.docs.first;

            // Get the challenge data
            String videoUrl = mostRecentChallenge['videoUrl'];
            String challengeName = mostRecentChallenge['challengeName'];

            return Container(
              color: Colors.deepOrangeAccent,
              height: 350,
              width: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: AdminVideoPlayer(videoUrl: videoUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      challengeName,
                      style: TextStyle(
                        color: Color(0xffF6EED2),
                        fontSize: 16,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    
      // Padding(
      //   padding: const EdgeInsets.only(left: 30,top: 20),
      //   child: Container(
      //     color: Colors.deepOrangeAccent,
      //     height: 350,
      //     width: 700,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Align(
      //           alignment: Alignment.topCenter,
      //           child: AdminVideoPlayer(
      //                 videoUrl: 'https://firebasestorage.googleapis.com/v0/b/the-owensboro-app.firebasestorage.app/o/challenges%2F1762431539665.mp4?alt=media&token=287657b7-3928-4dd8-92c2-eb9e2bbef9d6',
                     
      //               ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.all(10),
      //           child: Text(
      //             'Title',
      //             style: TextStyle(
      //               color: Color(0xffF6EED2),
      //               fontSize: 16,
      //               letterSpacing: 0.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
     

      ]),
    );
 
  }
}
class AdminVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const AdminVideoPlayer({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<AdminVideoPlayer> createState() => _AdminVideoPlayerState();
}

class _AdminVideoPlayerState extends State<AdminVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        handleColor: Colors.blueAccent,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightBlue,
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      autoInitialize: true,
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized && _chewieController != null
        ? SizedBox(
          height: 300,
          child: Chewie(controller: _chewieController!))
        : Center(child: const CircularProgressIndicator());
  }
}


class AddChallengeWidget extends StatelessWidget {
  const AddChallengeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Text(
                  'Challenge',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 48,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Admin can create, manage, and update weekly challenge videos easily.',
                style: TextStyle(
                  color: Color(0xffF6EED2),
                  fontSize: 16,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) => InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) => AddBannerDialog(),
                );
               
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.15,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Colors.deepOrange),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'Add Challenge',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 16,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            ),
          ),
        ],
      ),
    );
  }
}

class VideoFileWrapper {
  final File? file; // For mobile
  final Uint8List? bytes; // For web
  final String? name; // File name for web

  VideoFileWrapper({this.file, this.bytes, this.name});

  bool get isWeb => bytes != null;
  bool get isMobile => file != null;
  bool get hasVideo => file != null || bytes != null;
}

class AddBannerDialog extends StatefulWidget {
  AddBannerDialog({Key? key}) : super(key: key);

  @override
  State<AddBannerDialog> createState() => _AddBannerDialogState();
}

class _AddBannerDialogState extends State<AddBannerDialog> {
  final TextEditingController _bannerNameController = TextEditingController();
  final TextEditingController _challengeDescription = TextEditingController();

  bool _isVideoSelected = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Future<void> createChallenge(
      String challengeName,
      String challengeDesc,
      VideoFileWrapper? videoWrapper,
    ) async {
      try {
        setState(() {
          _isLoading = true;
        });

        if (videoWrapper == null || !videoWrapper.hasVideo) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please select a video.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        String videoFileName =
            'challenges/${DateTime.now().millisecondsSinceEpoch}.mp4';
        Reference storageRef = FirebaseStorage.instance.ref(videoFileName);

        TaskSnapshot uploadTask;

        if (kIsWeb && videoWrapper.isWeb) {
          // Web upload using putData
          uploadTask = await storageRef.putData(
            videoWrapper.bytes!,
            SettableMetadata(contentType: 'video/mp4'),
          );
        } else if (videoWrapper.isMobile) {
          // Mobile upload using putFile
          uploadTask = await storageRef.putFile(videoWrapper.file!);
        } else {
          throw Exception('Invalid video file wrapper state');
        }

        String videoUrl = await uploadTask.ref.getDownloadURL();

        Map<String, dynamic> challengeData = {
          'challengeName': challengeName,
          'createdAt': FieldValue.serverTimestamp(),
          "description" : challengeDesc,
          'videoUrl': videoUrl,
        };

        await FirebaseFirestore.instance
            .collection('challenges')
            .add(challengeData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Challenge created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        print("Error: ${e.toString()}");
        log("Error: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    VideoFileWrapper? videoWrapper;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F1E2),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Add Challenge',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Challenge Name *',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB35E4E),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _bannerNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFF09A7A), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFD0D0D0), width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(fontSize: 16.0, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 8.0),
           
            const Text(
              'Challenge Description *',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB35E4E),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _challengeDescription,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFF09A7A), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Color(0xFFD0D0D0), width: 1.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(fontSize: 16.0, color: Color(0xFF333333)),
            ),
           
            const SizedBox(height: 10.0),
            
            CustomVideoPickerWidget(
              height: 300,
              primaryColor: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20),
              onVideoSelected: (wrapper) {
                if (wrapper != null && wrapper.hasVideo) {
                  videoWrapper = wrapper;
                  log('Video selected for ${kIsWeb ? 'web' : 'mobile'}');
                  _isVideoSelected = true;
                } else {
                  print('Video removed');
                  videoWrapper = null;
                  _isVideoSelected = false;
                }
              },
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: _isLoading ? Center(child: CircularProgressIndicator(color: const Color(0xFFF09A7A),),): ElevatedButton(
                onPressed: () {
                  print('Banner Name: ${_bannerNameController.text}');
                  if (_bannerNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter a challenge name.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (_challengeDescription.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter a challenge description.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }else if (!_isVideoSelected || videoWrapper == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please select a video.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    log("Uploading video...");
                    createChallenge(_bannerNameController.text,_challengeDescription.text, videoWrapper);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF09A7A),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Challenge',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}


class CustomVideoPickerWidget extends StatefulWidget {
  final Function(VideoFileWrapper?)? onVideoSelected;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? primaryColor;

  const CustomVideoPickerWidget({
    Key? key,
    this.onVideoSelected,
    this.height,
    this.width,
    this.borderRadius,
    this.primaryColor,
  }) : super(key: key);

  @override
  State<CustomVideoPickerWidget> createState() =>
      _CustomVideoPickerWidgetState();
}

class _CustomVideoPickerWidgetState extends State<CustomVideoPickerWidget> {
  VideoFileWrapper? _videoWrapper;
  VideoPlayerController? _controller;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Color get primaryColor => widget.primaryColor ?? Colors.deepPurple;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo(ImageSource source) async {
    setState(() => _isLoading = true);

    try {
      final XFile? pickedFile = await _picker.pickVideo(source: source);

      if (pickedFile != null) {
        if (kIsWeb) {
          // Web handling - read bytes
          final Uint8List videoBytes = await pickedFile.readAsBytes();
          _videoWrapper = VideoFileWrapper(
            bytes: videoBytes,
            name: pickedFile.name,
          );
          await _initializeVideoWeb(pickedFile);
        } else {
          // Mobile handling
          _videoWrapper = VideoFileWrapper(file: File(pickedFile.path));
          await _initializeVideoMobile();
        }
        widget.onVideoSelected?.call(_videoWrapper);
      }
    } catch (e) {
      _showErrorSnackbar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _initializeVideoMobile() async {
    if (_videoWrapper?.file == null) return;

    _controller?.dispose();
    _controller = VideoPlayerController.file(_videoWrapper!.file!)
      ..initialize()
          .then((_) {
            setState(() {});
            _controller!.setLooping(true);
            _controller!.addListener(() {
              setState(() {});
            });
          })
          .catchError((error) {
            _showErrorSnackbar('Failed to load video');
          });
  }

  Future<void> _initializeVideoWeb(XFile file) async {
    _controller?.dispose();
    _controller = VideoPlayerController.networkUrl(Uri.parse(file.path))
      ..initialize()
          .then((_) {
            setState(() {});
            _controller!.setLooping(true);
            _controller!.addListener(() {
              setState(() {});
            });
          })
          .catchError((error) {
            _showErrorSnackbar('Failed to load video');
          });
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Video Source',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            _buildSourceOption(
              icon: Icons.video_library_rounded,
              title: 'Gallery',
              subtitle: kIsWeb
                  ? 'Pick from your files'
                  : 'Pick from your videos',
              color: primaryColor,
              onTap: () {
                Navigator.pop(context);
                _pickVideo(ImageSource.gallery);
              },
            ),
            if (!kIsWeb) ...[
              const SizedBox(height: 12),
              _buildSourceOption(
                icon: Icons.videocam_rounded,
                title: 'Camera',
                subtitle: 'Record a new video',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.camera);
                },
              ),
            ],
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Camera not available on web',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return InkWell(
      onTap: _showSourceDialog,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_circle_outline_rounded,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tap to Pick Video',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              kIsWeb ? 'From your files' : 'From gallery or camera',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.language, color: Colors.orange, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        'Running on Web',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Loading video...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Row(
            children: [
              _buildIconButton(
                icon: Icons.change_circle_rounded,
                onPressed: _showSourceDialog,
                tooltip: 'Change Video',
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                icon: Icons.delete_rounded,
                onPressed: () {
                  setState(() {
                    _videoWrapper = null;
                    _controller?.dispose();
                    _controller = null;
                  });
                  widget.onVideoSelected?.call(null);
                },
                tooltip: 'Remove Video',
                color: Colors.red,
              ),
            ],
          ),
        ),
        if (kIsWeb)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.language, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Web Mode',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _controller!.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: true,
                  padding: EdgeInsets.zero,
                  colors: VideoProgressColors(
                    playedColor: primaryColor,
                    bufferedColor: Colors.white.withOpacity(0.3),
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (color ?? Colors.white).withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color ?? Colors.black87, size: 20),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 400,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _isLoading
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      kIsWeb ? 'Loading video from web...' : 'Loading video...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          : _videoWrapper == null
          ? _buildPlaceholder()
          : _buildVideoPlayer(),
    );
  }
}

