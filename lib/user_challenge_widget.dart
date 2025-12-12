import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class Challenge {
  String _id = '';

  static final Challenge _instance = Challenge._internal();
  factory Challenge() => _instance;
  Challenge._internal();

  set challengeID(String id) => _id = id;

  String get challengeID => _id;
}

class UserChallengeWidget extends StatelessWidget {
  UserChallengeWidget({super.key});
  String? recentChallenge;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Color(0xff252932),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [VideoAndAddReview(), ReviewsSection()],
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

class VideoAndAddReview extends StatefulWidget {
  VideoAndAddReview({super.key});

  @override
  State<VideoAndAddReview> createState() => _VideoAndAddReviewState();
}

class _VideoAndAddReviewState extends State<VideoAndAddReview> {
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReview() async {
    log("ChallengeID Submit ${Challenge().challengeID}");
    String reviewText = _reviewController.text.trim();

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Review cannot be empty!'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      CollectionReference reviews = FirebaseFirestore.instance
          .collection('challenges')
          .doc(Challenge().challengeID)
          .collection('reviews');

      await reviews.add({
        'reviewText': reviewText,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Review submitted successfully!'),
          backgroundColor: Colors.green.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      _reviewController.clear();
      setState(() {
        _isLoading = false;
        // _selectedRating = 0;
      });
    } catch (e) {
      _reviewController.clear();
      setState(() {
        _isLoading = false;
      });
      log("e ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to submit review. Try again later.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMostRecentChallenge();
  }

  Future<void> _fetchMostRecentChallenge() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .orderBy('createdAt', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot mostRecentChallenge = snapshot.docs.first;
      Challenge().challengeID = mostRecentChallenge.id;

      log("challengeID ${Challenge().challengeID}");
    } else {
      log("No challenges found!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MediaQuery.of(context).size.width > 850
              ? Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('challenges')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 450,
                            // width: 700,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No challenges found.'));
                        }
                        DocumentSnapshot mostRecentChallenge =
                            snapshot.data!.docs.first;

                        String videoUrl = mostRecentChallenge['videoUrl'];
                        String challengeName =
                            mostRecentChallenge['challengeName'];
                        Timestamp timestamp = mostRecentChallenge['createdAt'];
                        DateTime createdAt = timestamp.toDate();
                        String challengeDes =
                            mostRecentChallenge['description'] ?? "";
                        // Format the DateTime
                        String formattedDate = DateFormat(
                          'MMMM d, yyyy',
                        ).format(createdAt);

                        print(formattedDate);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challengeName ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formattedDate ?? "",
                              style: TextStyle(
                                color: Color(0xff8a8d95),
                                fontSize: 16,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            VideoPlayer(videoUrl: videoUrl),
                            SizedBox(height: 10.0),

                            Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              challengeDes ?? "",
                              style: TextStyle(
                                color: Color(0xff8a8d95),
                                fontSize: 15,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  // flex:  3 ,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('challenges')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 450,
                            // width: 700,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No challenges found.'));
                        }
                        DocumentSnapshot mostRecentChallenge =
                            snapshot.data!.docs.first;

                        String videoUrl = mostRecentChallenge['videoUrl'];
                        String challengeName =
                            mostRecentChallenge['challengeName'];
                        String challengeDes =
                            mostRecentChallenge['description'] ?? "";
                        Timestamp timestamp = mostRecentChallenge['createdAt'];
                        DateTime createdAt = timestamp.toDate();

                        // Format the DateTime
                        String formattedDate = DateFormat(
                          'MMMM d, yyyy',
                        ).format(createdAt);

                        print(formattedDate);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challengeName ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formattedDate ?? "",
                              style: TextStyle(
                                color: Color(0xff8a8d95),
                                fontSize: 16,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            VideoPlayer(videoUrl: videoUrl),
                            SizedBox(height: 10.0),

                            Text(
                              "Description",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              challengeDes ?? "",
                              style: TextStyle(
                                color: Color(0xff8a8d95),
                                fontSize: 15,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D3442),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                controller: _reviewController,
                                decoration: InputDecoration(
                                  suffixIcon: _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.deepOrangeAccent,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            _submitReview();
                                          },
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                        ),
                                  hintText:
                                      'Tell us what you thought about the video!',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 10,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(20),
                                ),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
          SizedBox(width: 20),
          MediaQuery.of(context).size.width > 850
              ? Expanded(flex: 2, child: AddReview())
              : SizedBox(),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}

// class ReviewItem extends StatelessWidget {
//   final String userName;
//   final String reviewText;

//   ReviewItem({required this.userName, required this.reviewText});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[800],
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         padding: EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               reviewText,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               userName,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool _isLoading = false;
  int _selectedRating = 0;

  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    log("ChallengeID Submit ${Challenge().challengeID}");
    String reviewText = _reviewController.text.trim();

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Review cannot be empty!'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      CollectionReference reviews = FirebaseFirestore.instance
          .collection('challenges')
          .doc(Challenge().challengeID)
          .collection('reviews');

      await reviews.add({
        'reviewText': reviewText,
        'rating': _selectedRating,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Review submitted successfully!'),
          backgroundColor: Colors.green.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      _reviewController.clear();
      setState(() {
        _isLoading = false;
        _selectedRating = 0;
      });
    } catch (e) {
      _reviewController.clear();
      setState(() {
        _isLoading = false;
      });
      log("e ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to submit review. Try again later.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMostRecentChallenge();
  }

  Future<void> _fetchMostRecentChallenge() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .orderBy('createdAt', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot mostRecentChallenge = snapshot.docs.first;
      Challenge().challengeID = mostRecentChallenge.id;

      log("challengeID ${Challenge().challengeID}");
    } else {
      log("No challenges found!");
    }
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = index + 1;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              index < _selectedRating ? Icons.star : Icons.star_border,
              color: const Color(0xFFFFA726),
              size: 42,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(maxWidth: 500),
      // margin: const EdgeInsets.only(right: 50),
      decoration: BoxDecoration(
        color: const Color(0xFF424B5A),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          const Text(
            'Add Your Review',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 24),

          // Star Rating
          // _buildStarRating(),
          // const SizedBox(height: 24),

          // Review TextField
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2D3442),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: 'Tell us what you thought about the video!',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
              maxLines: 5,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.send_rounded, size: 20),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}

// class AddReview extends StatefulWidget {
//   const AddReview({super.key});

//   @override
//   State<AddReview> createState() => _AddReviewState();
// }

// class _AddReviewState extends State<AddReview> {
//   bool _isLoading = false;

//   final TextEditingController _reviewController = TextEditingController();

//   Future<void> _submitReview() async {
//     log("ChallengeID Submit ${Challenge().challengeID}");
//     String reviewText = _reviewController.text.trim();

//     if (reviewText.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Review cannot be empty!')));
//       return;
//     }

//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       CollectionReference reviews = FirebaseFirestore.instance
//           .collection('challenges')
//           .doc(Challenge().challengeID)
//           .collection('reviews');

//       await reviews.add({
//         'reviewText': reviewText,

//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Review submitted successfully!')),
//       );

//       _reviewController.clear();
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       _reviewController.clear();
//       setState(() {
//         _isLoading = false;
//       });
//       log("e ${e.toString()}");

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to submit review. Try again later.'),
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchMostRecentChallenge();
//   }

//   Future<void> _fetchMostRecentChallenge() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('challenges')
//         .orderBy('createdAt', descending: true)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       DocumentSnapshot mostRecentChallenge = snapshot.docs.first;
//       Challenge().challengeID = mostRecentChallenge.id;

//       log("challengeID ${Challenge().challengeID}");
//     } else {
//       log("No challenges found!");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.deepOrangeAccent),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       width: 500,
//       margin: EdgeInsets.only(right: 50),
//       padding: EdgeInsets.all(20),
//       child: Column(
//         children: [
//           Text(
//             'Add Review',
//             style: TextStyle(
//               color: Colors.deepOrange,
//               fontSize: 38,
//               letterSpacing: 0.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 10.0),

//           // TextField for entering the review
//           TextField(
//             controller: _reviewController,
//             decoration: InputDecoration(
//               hintText: 'Enter your review',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 borderSide: BorderSide(color: Color(0xFFF09A7A), width: 2.0),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 borderSide: BorderSide(color: Color(0xFFD0D0D0), width: 1.0),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 12.0,
//               ),
//               fillColor: Colors.white,
//               filled: true,
//             ),
//             maxLines: 6,
//             style: const TextStyle(fontSize: 16.0, color: Color(0xFF333333)),
//           ),

//           const SizedBox(height: 10.0),

//           // Submit button
//           SizedBox(
//             width: double.infinity,
//             child: _isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.deepOrangeAccent,
//                     ),
//                   )
//                 : ElevatedButton(
//                     onPressed: _submitReview,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepOrangeAccent,
//                       padding: const EdgeInsets.symmetric(vertical: 14.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       'Submit',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayer extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }

//   Future<void> _initializePlayer() async {
//     _videoPlayerController = VideoPlayerController.networkUrl(
//       Uri.parse(widget.videoUrl),
//     );

//     await _videoPlayerController.initialize();

//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: false,
//       looping: false,
//       showControls: true,
//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.blue,
//         handleColor: Colors.blueAccent,
//         backgroundColor: Colors.grey,
//         bufferedColor: Colors.lightBlue,
//       ),
//       placeholder: Container(
//         color: Colors.black,
//         child: const Center(child: CircularProgressIndicator()),
//       ),
//       autoInitialize: true,
//     );

//     setState(() {
//       _isInitialized = true;
//     });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isInitialized && _chewieController != null
//         ? SizedBox(height: 300, child: Chewie(controller: _chewieController!))
//         : Center(child: CircularProgressIndicator(color: Colors.white));
//     // return _isInitialized && _chewieController != null
//     //   ? Container(
//     //       decoration: BoxDecoration(
//     //         border: Border.all(
//     //           color: Colors.deepOrangeAccent,
//     //           width: 1,
//     //         ),
//     //         borderRadius: BorderRadius.circular(20.0),
//     //       ),
//     //       child: SizedBox(
//     //         height: 300,
//     //         child: Chewie(controller: _chewieController!),
//     //       ),
//     //     )
//     //   : Center(child: CircularProgressIndicator(color: Colors.white));
//   }
// }

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        showControls: true,
        aspectRatio: 16 / 9,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF6C63FF),
          handleColor: const Color(0xFF6C63FF),
          backgroundColor: Colors.grey.shade800,
          bufferedColor: const Color(0xFF9D97FF),
        ),
        placeholder: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade900, Colors.grey.shade800],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading video...',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        autoInitialize: true,
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildPlayerContent(),
        ),
      ),
    );
  }

  Widget _buildPlayerContent() {
    if (_hasError) {
      return _buildErrorState();
    }

    if (!_isInitialized || _chewieController == null) {
      return _buildLoadingState();
    }

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Chewie(controller: _chewieController!),
            // Optional: Add a subtle gradient overlay at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey.shade900, Colors.grey.shade800],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Preparing your video',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This won\'t take long',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.shade900.withOpacity(0.2),
              Colors.grey.shade900,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.red.shade400,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Unable to load video',
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _isInitialized = false;
                  });
                  _initializePlayer();
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ReviewsSection extends StatefulWidget {
//   const ReviewsSection({super.key});

//   @override
//   State<ReviewsSection> createState() => _ReviewsSectionState();
// }

// class _ReviewsSectionState extends State<ReviewsSection> {
//   bool _showAllComments = false;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('challenges')
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, challengeSnapshot) {
//         if (challengeSnapshot.connectionState == ConnectionState.waiting) {
//           return const SizedBox();
//         }

//         if (!challengeSnapshot.hasData ||
//             challengeSnapshot.data!.docs.isEmpty) {
//           return const SizedBox();
//         }

        

//         return SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: 600,
//           child: ListView.builder(
//             shrinkWrap: true,
//             itemCount: challengeSnapshot.data!.docs.length,
//             itemBuilder: (context, index) {
// //               var challengeDoc = challengeSnapshot.data!.docs[index];
// log("challengeDocID ${Challenge().challengeID}");

//               return StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('challenges')
//                     .doc(Challenge().challengeID)
//                     .collection('reviews')
//                     .orderBy('createdAt', descending: true)
//                     .snapshots(),
//                 builder: (context, reviewSnapshot) {
//                   if (reviewSnapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Container(
//                       height: 200,
//                       child: const Center(
//                         child: CircularProgressIndicator(
//                           color: Color(0xFF6C63FF),
//                           strokeWidth: 3,
//                         ),
//                       ),
//                     );
//                   }

//                   if (!reviewSnapshot.hasData ||
//                       reviewSnapshot.data!.docs.isEmpty) {
//                     return const SizedBox();
//                   }

//                   // Get all reviews
//                   List<QueryDocumentSnapshot> allReviews =
//                       reviewSnapshot.data!.docs;
//                   int totalComments = allReviews.length;
//                   // Show only first 3 if not expanded
//                   List<QueryDocumentSnapshot> displayedReviews =
//                       _showAllComments
//                       ? allReviews
//                       : allReviews.take(3).toList();



//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Comments Header
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 20,
//                         ),
//                         child: Row(
//                           children: [
//                             const Text(
//                               'Comments',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF6C63FF),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 '$totalComments',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Reviews List
//                       ...displayedReviews.map((reviewDoc) {
//                         var reviewData =
//                             reviewDoc.data() as Map<String, dynamic>;

//                         Timestamp createdAt =
//                             reviewData['createdAt'] ?? Timestamp.now();
//                         DateTime dateTime = createdAt.toDate();
//                         String timeAgo = timeago.format(dateTime);

//                         int rating = reviewData['rating'] ?? 5;

//                         return Padding(
//                           padding: const EdgeInsets.only(
//                             left: 30,
//                             right: 30,
//                             bottom: 16,
//                           ),
//                           child: ReviewItem(
//                             timeAgo: timeAgo,
//                             reviewText:
//                                 reviewData['reviewText'] ??
//                                 'No review text available',
//                             rating: rating,
//                           ),
//                         );
//                       }).toList(),

//                       // View All Button
//                       if (totalComments > 3)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 30,
//                             vertical: 16,
//                           ),
//                           child: Center(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _showAllComments = !_showAllComments;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF3B82F6),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(24),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     _showAllComments
//                                         ? 'Show Less'
//                                         : 'View All ($totalComments) Comments',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       letterSpacing: 0.3,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Icon(
//                                     _showAllComments
//                                         ? Icons.keyboard_arrow_up_rounded
//                                         : Icons.keyboard_arrow_down_rounded,
//                                     size: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                       const SizedBox(height: 20),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class ReviewsSection extends StatefulWidget {
//   const ReviewsSection({super.key});

//   @override
//   State<ReviewsSection> createState() => _ReviewsSectionState();
// }

// class _ReviewsSectionState extends State<ReviewsSection> {
//   bool _showAllComments = false;
//   @override
//   void initState() {
//     super.initState();
//     _fetchMostRecentChallenge();
//   }

//   Future<void> _fetchMostRecentChallenge() async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('challenges')
//         .orderBy('createdAt', descending: true)
//         .get();

//     if (snapshot.docs.isNotEmpty) {
//       DocumentSnapshot mostRecentChallenge = snapshot.docs.first;
//       Challenge().challengeID = mostRecentChallenge.id;

//       log("challengeID ${Challenge().challengeID}");
//     } else {
//       log("No challenges found!");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Directly query the specific challenge's reviews without looping through all challenges
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('challenges')
//           .doc(Challenge().challengeID)
//           .collection('reviews')
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, reviewSnapshot) {
//         if (reviewSnapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             height: 200,
//             child: const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xFF6C63FF),
//                 strokeWidth: 3,
//               ),
//             ),
//           );
//         }

//         if (!reviewSnapshot.hasData || reviewSnapshot.data!.docs.isEmpty) {
//           return const SizedBox();
//         }

//         // Get all reviews
//         List<QueryDocumentSnapshot> allReviews = reviewSnapshot.data!.docs;
//         int totalComments = allReviews.length;

//         // Show only first 3 if not expanded
//         List<QueryDocumentSnapshot> displayedReviews = _showAllComments
//             ? allReviews
//             : allReviews.take(3).toList();

//         return SizedBox(
//           width: 600,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Comments Header
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 20,
//                 ),
//                 child: Row(
//                   children: [
//                     const Text(
//                       'Comments',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF6C63FF),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '$totalComments',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Reviews List
//               ...displayedReviews.map((reviewDoc) {
//                 var reviewData = reviewDoc.data() as Map<String, dynamic>;

//                 Timestamp createdAt =
//                     reviewData['createdAt'] ?? Timestamp.now();
//                 DateTime dateTime = createdAt.toDate();
//                 String timeAgo = timeago.format(dateTime);

//                 int rating = reviewData['rating'] ?? 5;

//                 return Padding(
//                   padding: const EdgeInsets.only(
//                     left: 30,
//                     right: 30,
//                     bottom: 16,
//                   ),
//                   child: ReviewItem(
//                     timeAgo: timeAgo,
//                     reviewText: reviewData['reviewText'] ??
//                         'No review text available',
//                     rating: rating,
//                   ),
//                 );
//               }).toList(),

//               // View All Button
//               if (totalComments > 3)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 16,
//                   ),
//                   child: Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _showAllComments = !_showAllComments;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B82F6),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 14,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             _showAllComments
//                                 ? 'Show Less'
//                                 : 'View All ($totalComments) Comments',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.3,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Icon(
//                             _showAllComments
//                                 ? Icons.keyboard_arrow_up_rounded
//                                 : Icons.keyboard_arrow_down_rounded,
//                             size: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class ReviewsSection extends StatefulWidget {
  const ReviewsSection({super.key});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  bool _showAllComments = false;
  bool _isLoading = true;
  String? _challengeID;

  @override
  void initState() {
    super.initState();
    _fetchMostRecentChallenge();
  }

  Future<void> _fetchMostRecentChallenge() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('challenges')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot mostRecentChallenge = snapshot.docs.first;
        setState(() {
          _challengeID = mostRecentChallenge.id;
          Challenge().challengeID = mostRecentChallenge.id;
          _isLoading = false;
        });
        log("challengeID $_challengeID");
      } else {
        setState(() {
          _isLoading = false;
        });
        log("No challenges found!");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log("Error fetching challenge: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state while fetching challenge ID
    if (_isLoading) {
      return Container(
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C63FF),
            strokeWidth: 3,
          ),
        ),
      );
    }

    // If no challenge ID found, show nothing
    if (_challengeID == null || _challengeID!.isEmpty) {
      return const SizedBox();
    }

    // Directly query the specific challenge's reviews
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('challenges')
          .doc(_challengeID)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, reviewSnapshot) {
        if (reviewSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C63FF),
                strokeWidth: 3,
              ),
            ),
          );
        }

        if (reviewSnapshot.hasError) {
          log("Error loading reviews: ${reviewSnapshot.error}");
          return const SizedBox();
        }

        if (!reviewSnapshot.hasData || reviewSnapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        // Get all reviews
        List<QueryDocumentSnapshot> allReviews = reviewSnapshot.data!.docs;
        int totalComments = allReviews.length;

        // Show only first 3 if not expanded
        List<QueryDocumentSnapshot> displayedReviews = _showAllComments
            ? allReviews
            : allReviews.take(3).toList();

        return SizedBox(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comments Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Comments',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$totalComments',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Reviews List
              ...displayedReviews.map((reviewDoc) {
                var reviewData = reviewDoc.data() as Map<String, dynamic>;

                Timestamp createdAt =
                    reviewData['createdAt'] ?? Timestamp.now();
                DateTime dateTime = createdAt.toDate();
                String timeAgo = timeago.format(dateTime);

                int rating = reviewData['rating'] ?? 5;

                return Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 16,
                  ),
                  child: ReviewItem(
                    timeAgo: timeAgo,
                    reviewText: reviewData['reviewText'] ??
                        'No review text available',
                    rating: rating,
                  ),
                );
              }).toList(),

              // View All Button
              if (totalComments > 3)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showAllComments = !_showAllComments;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showAllComments
                                ? 'Show Less'
                                : 'View All ($totalComments) Comments',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _showAllComments
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}


class ReviewItem extends StatelessWidget {
  final String timeAgo;
  final String reviewText;
  final int rating;

  const ReviewItem({
    Key? key,
    required this.timeAgo,
    required this.reviewText,
    this.rating = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF424B5A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF6C63FF), const Color(0xFF3B82F6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and Rating Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Star Rating Display
                    // Row(
                    //   children: List.generate(5, (index) {
                    //     return Icon(
                    //       index < rating ? Icons.star : Icons.star_border,
                    //       color: const Color(0xFFFFA726),
                    //       size: 18,
                    //     );
                    //   }),
                    // ),
                    // const SizedBox(width: 6),
                    // Text(
                    //   rating.toString(),
                    //   style: TextStyle(
                    //     color: Colors.white.withOpacity(0.7),
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),

                // Review Text
                Text(
                  reviewText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Time Ago
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13,
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
