import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterflow_custom_widget/catagory_backup.dart';
import 'package:flutterflow_custom_widget/custom_date_time_picker.dart';
import 'package:flutterflow_custom_widget/drop_down_widget.dart';
import 'package:flutterflow_custom_widget/listing_image_widget.dart';
import 'package:flutterflow_custom_widget/wheel.dart';
import 'package:flutterflow_custom_widget/wheel_flutterflow_widget.dart';

String? _downloadUrl;

class CatagoryIconWidget extends StatefulWidget {
  const CatagoryIconWidget({super.key});

  @override
  State<CatagoryIconWidget> createState() => _CatagoryIconWidgetState();
}

class _CatagoryIconWidgetState extends State<CatagoryIconWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
              
                // ListingImageWidget(isRequired: true),
                Container(
                  color: Colors.black ,
                  height: 500,
                  width: 500,
                  child: WheelWidget()),
            
                  
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Submit");
                    }
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SvgPicker extends StatefulWidget {
  final String? initialImageUrl; // For editing existing image
  final Future Function(String? url)? onUrlGenerated;

  const SvgPicker({Key? key, this.initialImageUrl, this.onUrlGenerated})
    : super(key: key);

  @override
  State<SvgPicker> createState() => _SvgPickerState();
}

class _SvgPickerState extends State<SvgPicker> {
  File? _selectedFile;
  String? _svgContent;
  bool _isUploading = false;
  String? _downloadUrl;
  bool _hasPickedNewImage = false;

  @override
  void initState() {
    super.initState();
    // Set initial download URL from widget parameter
    _downloadUrl = widget.initialImageUrl;
  }

  Future<void> _pickSvgFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      if (kIsWeb) {
        if (file.bytes != null) {
          final svgData = String.fromCharCodes(file.bytes!);
          setState(() {
            _svgContent = svgData;
            _hasPickedNewImage = true;
          });

          // Upload the file to Firebase Storage
          await _uploadSvgToFirebase(file.bytes!, file.name);
        }
      } else if (file.path != null) {
        final pickedFile = File(file.path!);
        final svgData = await pickedFile.readAsString();
        setState(() {
          _selectedFile = pickedFile;
          _svgContent = svgData;
          _hasPickedNewImage = true;
        });

        // Upload to Firebase Storage
        await _uploadSvgToFirebase(await pickedFile.readAsBytes(), file.name);
      }
    }
  }

  Future<void> _uploadSvgToFirebase(
    Uint8List fileBytes,
    String fileName,
  ) async {
    setState(() => _isUploading = true);

    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('svgs/$fileName');

      // Upload the file (for both web & mobile)
      final uploadTask = await storageRef.putData(
        fileBytes,
        SettableMetadata(contentType: 'image/svg+xml'),
      );

      // Get the download URL
      final url = await uploadTask.ref.getDownloadURL();

      setState(() {
        _downloadUrl = url;
        _isUploading = false;
      });

      // Call the callback with the URL
      await widget.onUrlGenerated?.call(url);

      print('✅ Uploaded successfully! Download URL: $url');
    } catch (e) {
      setState(() => _isUploading = false);
      print('❌ Upload failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickSvgFile,
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    // If user picked a new image, show it from local content
    if (_hasPickedNewImage && _svgContent != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.string(
          _svgContent!,
          width: 180,
          height: 180,
          fit: BoxFit.contain,
          placeholderBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // If there's an initial/downloaded URL, show it from network
    if (_downloadUrl != null && _downloadUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.network(
          _downloadUrl!,
          width: 180,
          height: 180,
          color: Colors.red,
          fit: BoxFit.contain,
          placeholderBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // No image - show placeholder
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text('Tap to pick SVG', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}


// class SvgPicker extends StatefulWidget {
//   final void Function(File?)? onFilePicked;

//   const SvgPicker({Key? key, this.onFilePicked}) : super(key: key);

//   @override
//   State<SvgPicker> createState() => _SvgPickerState();
// }

// class _SvgPickerState extends State<SvgPicker> {
//   File? _selectedFile;
//   String? _svgContent;
//   bool _isUploading = false;

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
//           widget.onFilePicked?.call(null);

//           // Upload the file to Firebase Storage
//           await _uploadSvgToFirebase(file.bytes!, file.name);

// setState(() {
  
// });

//         }
//       } else if (file.path != null) {
//         final pickedFile = File(file.path!);
//         final svgData = await pickedFile.readAsString();
//         setState(() {
//           _selectedFile = pickedFile;
//           _svgContent = svgData;
//         });
//         widget.onFilePicked?.call(pickedFile);

//         // Upload to Firebase Storage
//         await _uploadSvgToFirebase(await pickedFile.readAsBytes(), file.name);

//         setState(() {
          
//         });

//       }
//     }
//   }

//   Future<void> _uploadSvgToFirebase(Uint8List fileBytes, String fileName) async {
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
//                       color: Colors.red,
//                       fit: BoxFit.contain,
//                       placeholderBuilder: (context) =>
//                           const Center(child: CircularProgressIndicator()),
//                     ),
//                   ),


                
                  
//       ),
//     );
  
//   }
// }


// class SvgPicker extends StatefulWidget {
//   final void Function(File?)? onFilePicked;

//   const SvgPicker({Key? key, this.onFilePicked}) : super(key: key);

//   @override
//   State<SvgPicker> createState() => _SvgPickerState();
// }

// class _SvgPickerState extends State<SvgPicker> {
//   File? _selectedFile;
//   String? _svgContent;

//   Future<void> _pickSvgFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['svg'],
//       withData: true, // important for web
//     );

//     if (result != null && result.files.isNotEmpty) {
//       final file = result.files.single;

//       // On web: read from bytes
//       if (kIsWeb) {
//         if (file.bytes != null) {
//           final svgData = String.fromCharCodes(file.bytes!);
//           setState(() {
//             _svgContent = svgData;
//           });
//           widget.onFilePicked?.call(null); // No real File on web
//         }
//       } 
//       // On mobile/desktop: read from path
//       else if (file.path != null) {
//         final pickedFile = File(file.path!);
//         final svgData = await pickedFile.readAsString();
//         setState(() {
//           _selectedFile = pickedFile;
//           _svgContent = svgData;
//         });
//         widget.onFilePicked?.call(pickedFile);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("_svgContent $_svgContent");
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
//         child: _svgContent == null
//             ? Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
//                     SizedBox(height: 8),
//                     Text('Tap to pick SVG', style: TextStyle(color: Colors.grey)),

//                   ],
//                 ),
//               )
//             : ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SvgPicture.string(
                  
//                   _svgContent!,
//                   width: 180,
//                   height: 180,
//                   color: Colors.red,
//                   fit: BoxFit.contain,
//                   placeholderBuilder: (context) =>
//                       const Center(child: CircularProgressIndicator()),
//                 ),
//               ),
//       ),
//     );
//   }
// }
