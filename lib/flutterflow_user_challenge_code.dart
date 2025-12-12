
// import 'dart:developer';

// import 'package:chewie/chewie.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:video_player/video_player.dart';

// class UserChallengeWidget extends StatefulWidget {
//   const UserChallengeWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<UserChallengeWidget> createState() => _UserChallengeWidgetState();
// }

// class _UserChallengeWidgetState extends State<UserChallengeWidget> {
//   String? recentChallenge;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,
//       color: Colors.black,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(),
//                 child: Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       VideoAndAddReview(),
//                       StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance
//                             .collection('challenges')
//                             .orderBy('createdAt', descending: true)
//                             .snapshots(),
//                         builder: (context, challengeSnapshot) {
//                           if (challengeSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return SizedBox();
//                           }

//                           if (!challengeSnapshot.hasData ||
//                               challengeSnapshot.data!.docs.isEmpty) {
//                             return Center(child: Text('No challenges found.'));
//                           }

//                           return Container(
//                             height: MediaQuery.of(context).size.height,
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               // physics: NeverScrollableScrollPhysics(),
//                               itemCount: challengeSnapshot.data!.docs.length,
//                               itemBuilder: (context, index) {
//                                 var challengeDoc =
//                                     challengeSnapshot.data!.docs[index];

//                                 return StreamBuilder<QuerySnapshot>(
//                                   stream: FirebaseFirestore.instance
//                                       .collection('challenges')
//                                       .doc(challengeDoc.id)
//                                       .collection('reviews')
//                                       .orderBy('createdAt', descending: true)
//                                       .snapshots(),
//                                   builder: (context, reviewSnapshot) {
//                                     if (challengeSnapshot.connectionState ==
//                                             ConnectionState.waiting ||
//                                         reviewSnapshot.connectionState ==
//                                             ConnectionState.waiting) {
//                                       return Container(
//                                         height: 500,
//                                         width: 700,
//                                         child: Center(
//                                           child: CircularProgressIndicator(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       );
//                                     }

//                                     if (!reviewSnapshot.hasData ||
//                                         reviewSnapshot.data!.docs.isEmpty) {
//                                       return Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Text('No reviews yet.'),
//                                       );
//                                     }

//                                     // If reviews exist, show them
//                                     return Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: reviewSnapshot.data!.docs.map((
//                                         reviewDoc,
//                                       ) {
//                                         var reviewData = reviewDoc.data()
//                                             as Map<String, dynamic>;

//                                         Timestamp createdAt =
//                                             reviewData['createdAt'] ??
//                                                 Timestamp.now();
//                                         DateTime dateTime = createdAt.toDate();

//                                         String timeAgo = timeago.format(
//                                           dateTime,
//                                         );

//                                         return Padding(
//                                           padding: const EdgeInsets.only(
//                                             left: 30,
//                                             top: 10,
//                                             right: 30,
//                                           ),
//                                           child: ReviewItem(
//                                             userName: timeAgo,
//                                             reviewText:
//                                                 reviewData['reviewText'] ??
//                                                     'No review text available',
//                                           ),
//                                         );
//                                       }).toList(),
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Challenge {
//   String _id = '';

//   static final Challenge _instance = Challenge._internal();
//   factory Challenge() => _instance;
//   Challenge._internal();

//   set challengeID(String id) => _id = id;

//   String get challengeID => _id;
// }

// class VideoAndAddReview extends StatelessWidget {
//   const VideoAndAddReview({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 30, top: 20),
//           child: StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('challenges')
//                 .orderBy('createdAt', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Container(
//                   height: 350,
//                   width: 700,
//                   child: Center(
//                     child: CircularProgressIndicator(color: Colors.white),
//                   ),
//                 );
//               }

//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }

//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text('No challenges found.'));
//               }
//               DocumentSnapshot mostRecentChallenge = snapshot.data!.docs.first;

//               String videoUrl = mostRecentChallenge['videoUrl'];
//               String challengeName = mostRecentChallenge['challengeName'];
//               return Container(
//                 height: 350,
//                 width: 700,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       challengeName ?? "",
//                       style: TextStyle(
//                         color: Colors.deepOrange,
//                         fontSize: 20,
//                         letterSpacing: 0.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     VideoPlayer(videoUrl: videoUrl),
//                   ],
//                 ),
//               );
//               // return Container(
//               //   color: Colors.deepOrangeAccent,
//               //   height: 350,
//               //   width: 700,
//               //   child: Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: [
//               //       Align(
//               //         alignment: Alignment.topCenter,
//               //         child: VideoPlayer(videoUrl: videoUrl),
//               //       ),
//               //       Padding(
//               //         padding: const EdgeInsets.all(10),
//               //         child: Text(
//               //           challengeName,
//               //           style: TextStyle(
//               //             color: Color(0xffF6EED2),
//               //             fontSize: 16,
//               //             letterSpacing: 0.0,
//               //             fontWeight: FontWeight.bold,
//               //           ),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // );
//             },
//           ),
//         ),
//         Spacer(),
//         AddReview(),
//       ],
//     );
//   }
// }

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