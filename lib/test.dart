
// import 'package:flutter_svg/svg.dart';

// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';

// class CatagoryIconPicker extends StatefulWidget {
//   const CatagoryIconPicker({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<CatagoryIconPicker> createState() => _CatagoryIconPickerState();
// }

// class _CatagoryIconPickerState extends State<CatagoryIconPicker> {
//   File? _selectedFile;
//   String? _svgContent;
//   bool _isUploading = false;
//   String? _downloadUrl;

//   Future<void> _pickSvgFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['svg'],
//       withData: true,
//     );

//     if (result != null && result.files.isNotEmpty) {
//       final file = result.files.single;

//       if (kIsWeb) {
//         if (file.bytes != null) {
//           final svgData = String.fromCharCodes(file.bytes!);
//           setState(() => _svgContent = svgData);
//           // widget.onFilePicked?.call(null);

//           // Upload the file to Firebase Storage
//           await _uploadSvgToFirebase(file.bytes!, file.name);

//           setState(() {});
//         }
//       } else if (file.path != null) {
//         final pickedFile = File(file.path!);
//         final svgData = await pickedFile.readAsString();
//         setState(() {
//           _selectedFile = pickedFile;
//           _svgContent = svgData;
//         });
//         // widget.onFilePicked?.call(pickedFile);

//         // Upload to Firebase Storage
//         await _uploadSvgToFirebase(await pickedFile.readAsBytes(), file.name);

//         setState(() {});
//       }
//     }
//   }

//   Future<void> _uploadSvgToFirebase(
//       Uint8List fileBytes, String fileName) async {
//     setState(() => _isUploading = true);

//     try {
//       // Create a reference to Firebase Storage
//       final storageRef = FirebaseStorage.instance.ref().child('svgs/$fileName');

//       // Upload the file (for both web & mobile)
//       final uploadTask = await storageRef.putData(
//         fileBytes,
//         SettableMetadata(contentType: 'image/svg+xml'),
//       );

//       // Get the download URL
//       final url = await uploadTask.ref.getDownloadURL();

//       setState(() {
//         FFAppState().selectedImagePath = url;

//         _downloadUrl = url;
//         _isUploading = false;
//       });

//       print('✅ Uploaded successfully! Download URL: $url');
//     } catch (e) {
//       setState(() => _isUploading = false);
//       print('❌ Upload failed: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed: $e')),
//       );
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _pickSvgFile,
//       child: Container(
//         height: 180,
//         width: 180,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.grey.shade100,
//         ),
//         child: _isUploading
//             ? const Center(child: CircularProgressIndicator())
//             : _svgContent == null
//                 ? const Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.add_photo_alternate,
//                             size: 40, color: Colors.grey),
//                         SizedBox(height: 8),
//                         Text('Tap to pick SVG',
//                             style: TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   )
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: SvgPicture.string(
//                       _svgContent!,
//                       width: 180,
//                       height: 180,
//                       // color: Colors.red,
//                       fit: BoxFit.contain,
//                       placeholderBuilder: (context) =>
//                           const Center(child: CircularProgressIndicator()),
//                     ),
//                   ),
//       ),
//     );
  
//   }
// }