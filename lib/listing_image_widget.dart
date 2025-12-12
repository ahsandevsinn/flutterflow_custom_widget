import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// class ListingImageWidget extends StatefulWidget {
//   final String? initialImageUrl; // Edit case ke liye existing image URL
//   final Function(String imageUrl)? onImageUploaded; // Callback for parent widget
  
//   const ListingImageWidget({
//     super.key,
//     this.initialImageUrl,
//     this.onImageUploaded,
//   });

//   @override
//   State<ListingImageWidget> createState() => _ListingImageWidgetState();
// }

// class _ListingImageWidgetState extends State<ListingImageWidget> {
//   final ImagePicker _picker = ImagePicker();
//   File? _imageFile; // Mobile/Desktop ke liye
//   XFile? _webImageFile; // Web ke liye
//   String? _uploadedImageUrl;
//   bool _isUploading = false;
//   double _uploadProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     // Edit case ke liye initial URL set karen
//     if (widget.initialImageUrl != null) {
//       _uploadedImageUrl = widget.initialImageUrl;
//     }
//   }

//   // Image pick karne ka function
//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           if (kIsWeb) {
//             _webImageFile = pickedFile; // Web ke liye
//           } else {
//             _imageFile = File(pickedFile.path); // Mobile/Desktop ke liye
//           }
//         });
        
//         // Upload automatically start karen
//         await _uploadImageToFirebase(pickedFile);
//       }
//     } catch (e) {
//       _showErrorSnackbar('Image pick karte waqt error: $e');
//     }
//   }

//   // Firebase Storage pe upload karne ka function (Web + Mobile compatible)
//   Future<void> _uploadImageToFirebase(XFile imageFile) async {
//     setState(() {
//       _isUploading = true;
//       _uploadProgress = 0.0;
//     });

//     try {
//       // Unique filename generate karen
//       String fileName = 'listings/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
//       // Firebase Storage reference
//       Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      
//       UploadTask uploadTask;

//       // Web aur Mobile ke liye alag handling
//       if (kIsWeb) {
//         // Web ke liye bytes use karen
//         final bytes = await imageFile.readAsBytes();
//         uploadTask = storageRef.putData(
//           bytes,
//           SettableMetadata(contentType: 'image/jpeg'),
//         );
//       } else {
//         // Mobile/Desktop ke liye File use karen
//         uploadTask = storageRef.putFile(File(imageFile.path));
//       }

//       // Upload progress track karen
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         setState(() {
//           _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
//         });
//       });

//       // Upload complete hone ka wait karen
//       TaskSnapshot taskSnapshot = await uploadTask;
      
//       // Download URL get karen
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      
//       setState(() {
//         _uploadedImageUrl = downloadUrl;
//         _isUploading = false;
//       });

//       // Parent widget ko notify karen
//       if (widget.onImageUploaded != null) {
//         widget.onImageUploaded!(downloadUrl);
//       }

//       _showSuccessSnackbar('Image successfully upload ho gayi!');
      
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//       });
//       _showErrorSnackbar('Upload error: $e');
//     }
//   }

//   // Image source selection dialog (Web ke liye camera option nahi)
//   void _showImageSourceDialog() {
//     if (kIsWeb) {
//       // Web pe directly gallery open karen (camera option nahi hai)
//       _pickImage(ImageSource.gallery);
//     } else {
//       // Mobile/Desktop pe camera aur gallery dono options
//       showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (BuildContext context) {
//           return SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.camera_alt, color: Colors.blue),
//                     title: const Text('Camera'),
//                     onTap: () {
//                       Navigator.pop(context);
//                       _pickImage(ImageSource.camera);
//                     },
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.photo_library, color: Colors.green),
//                     title: const Text('Gallery'),
//                     onTap: () {
//                       Navigator.pop(context);
//                       _pickImage(ImageSource.gallery);
//                     },
//                   ),
//                   if (_uploadedImageUrl != null)
//                     ListTile(
//                       leading: const Icon(Icons.delete, color: Colors.red),
//                       title: const Text('Remove Image'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _removeImage();
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }

//   // Image remove karne ka function
//   void _removeImage() {
//     setState(() {
//       _imageFile = null;
//       _webImageFile = null;
//       _uploadedImageUrl = null;
//     });
    
//     if (widget.onImageUploaded != null) {
//       widget.onImageUploaded!(''); // Empty string bhej dein
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   // Image preview widget (Web + Mobile compatible)
//   Widget _buildImagePreview() {
//     if (_uploadedImageUrl != null) {
//       // Uploaded image show karen
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(
//               _uploadedImageUrl!,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return const Center(
//                   child: Icon(Icons.error, color: Colors.red, size: 40),
//                 );
//               },
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//             // Web pe remove button bhi add karen
//             if (kIsWeb && _uploadedImageUrl != null)
//               Positioned(
//                 top: 8,
//                 left: 8,
//                 child: GestureDetector(
//                   onTap: _removeImage,
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       );
//     } else if (kIsWeb && _webImageFile != null) {
//       // Web pe local preview (before upload)
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: FutureBuilder<Uint8List>(
//           future: _webImageFile!.readAsBytes(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Image.memory(
//                 snapshot.data!,
//                 fit: BoxFit.cover,
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       );
//     } else if (!kIsWeb && _imageFile != null) {
//       // Mobile/Desktop pe local preview
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.file(
//           _imageFile!,
//           fit: BoxFit.cover,
//         ),
//       );
//     }

//     // Placeholder
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
//         SizedBox(height: 8),
//         Text(
//           'Add Image',
//           style: TextStyle(color: Colors.grey, fontSize: 14),
//         ),
//         SizedBox(height: 4),
//         Text(
//           'Click to upload',
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _isUploading ? null : _showImageSourceDialog,
//       child: Container(
//         height: 150,
//         width: 150,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Colors.grey[400]!,
//             width: 2,
//           ),
//         ),
//         child: _isUploading
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                       value: _uploadProgress,
//                       strokeWidth: 3,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       '${(_uploadProgress * 100).toInt()}%',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Uploading...',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : _buildImagePreview(),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListingImageWidget extends StatefulWidget {
  const ListingImageWidget({
    super.key,
    this.width,
    this.height,
    this.initialImageUrl,
    this.onImageUploaded,
    this.isRequired = true, // Validation ke liye
  });

  final double? width;
  final double? height;
  final String? initialImageUrl;
  final Future Function(String? imageUrl)? onImageUploaded;
  final bool isRequired; // Is field required hai ya nahi

  @override
  State<ListingImageWidget> createState() => _ListingImageWidgetState();
}

class _ListingImageWidgetState extends State<ListingImageWidget> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  XFile? _webImageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  
  // Validation ke liye
  String? _errorMessage;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialImageUrl != null) {
      _uploadedImageUrl = widget.initialImageUrl;
    }
  }

  // Validation check karne ka function
  bool validate() {
    if (widget.isRequired && _uploadedImageUrl == null) {
      setState(() {
        _errorMessage = 'Image is required';
        _showError = true;
      });
      return false;
    }
    
    setState(() {
      _errorMessage = null;
      _showError = false;
    });
    return true;
  }

  // Error clear karne ka function
  void clearError() {
    if (_showError) {
      setState(() {
        _errorMessage = null;
        _showError = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Error clear karen jab image select ho
        clearError();
        
        setState(() {
          if (kIsWeb) {
            _webImageFile = pickedFile;
          } else {
            _imageFile = File(pickedFile.path);
          }
        });

        await _uploadImageToFirebase(pickedFile);
      }
    } catch (e) {
      _showErrorSnackbar('error: $e');
    }
  }

  Future<void> _uploadImageToFirebase(XFile imageFile) async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      String fileName = 'listings/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask;

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        uploadTask = storageRef.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        uploadTask = storageRef.putFile(File(imageFile.path));
      }

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = downloadUrl;
        _isUploading = false;
      });

      if (widget.onImageUploaded != null) {
        widget.onImageUploaded!(downloadUrl);
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorSnackbar('Upload error: $e');
    }
  }

  void _showImageSourceDialog() {
    if (kIsWeb) {
      _pickImage(ImageSource.gallery);
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Colors.blue),
                    title: const Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library, color: Colors.green),
                    title: const Text('Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  if (_uploadedImageUrl != null)
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Remove Image'),
                      onTap: () {
                        Navigator.pop(context);
                        _removeImage();
                      },
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
      _webImageFile = null;
      _uploadedImageUrl = null;
    });

    if (widget.onImageUploaded != null) {
      widget.onImageUploaded!('');
    }
    
    // Remove ke baad validation check karen
    if (widget.isRequired) {
      validate();
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_uploadedImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _uploadedImageUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 40),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            if (kIsWeb && _uploadedImageUrl != null)
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    } else if (kIsWeb && _webImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FutureBuilder<Uint8List>(
          future: _webImageFile!.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else if (!kIsWeb && _imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
        ),
      );
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          'Add Image',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          'Click to upload',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _isUploading ? null : _showImageSourceDialog,
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _showError ? Colors.red : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: _isUploading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _uploadProgress,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${(_uploadProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Uploading...',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildImagePreview(),
          ),
        ),
        // Error message display
        if (_showError && _errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

// Usage Example in Form:
// final GlobalKey<_ListingImageWidgetState> imageWidgetKey = GlobalKey<_ListingImageWidgetState>();
//
// Form ke submit pe:
// if (imageWidgetKey.currentState?.validate() == false) {
//   // Image validation fail
//   return;
// }



// class ListingImageWidget extends StatefulWidget {
//   const ListingImageWidget({
//     super.key,
//     this.width,
//     this.height,
//     this.initialImageUrl,
//     this.onImageUploaded,
//   });

//   final double? width;
//   final double? height;
//   final String? initialImageUrl;
//   final Future Function(String? imageUrl)? onImageUploaded;

//   @override
//   State<ListingImageWidget> createState() => _ListingImageWidgetState();
// }

// class _ListingImageWidgetState extends State<ListingImageWidget> {
//   final ImagePicker _picker = ImagePicker();
//   File? _imageFile; // Mobile/Desktop ke liye
//   XFile? _webImageFile; // Web ke liye
//   String? _uploadedImageUrl;
//   bool _isUploading = false;
//   double _uploadProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     // Edit case ke liye initial URL set karen
//     if (widget.initialImageUrl != null) {
//       _uploadedImageUrl = widget.initialImageUrl;
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           if (kIsWeb) {
//             _webImageFile = pickedFile; // Web ke liye
//           } else {
//             _imageFile = File(pickedFile.path); // Mobile/Desktop ke liye
//           }
//         });

//         // Upload automatically start karen
//         await _uploadImageToFirebase(pickedFile);
//       }
//     } catch (e) {
//       _showErrorSnackbar('error: $e');
//     }
//   }

//   Future<void> _uploadImageToFirebase(XFile imageFile) async {
//     setState(() {
//       _isUploading = true;
//       _uploadProgress = 0.0;
//     });

//     try {
//       // Unique filename generate karen
//       String fileName = 'listings/${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Firebase Storage reference
//       Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

//       UploadTask uploadTask;

//       // Web aur Mobile ke liye alag handling
//       if (kIsWeb) {
//         // Web ke liye bytes use karen
//         final bytes = await imageFile.readAsBytes();
//         uploadTask = storageRef.putData(
//           bytes,
//           SettableMetadata(contentType: 'image/jpeg'),
//         );
//       } else {
//         // Mobile/Desktop ke liye File use karen
//         uploadTask = storageRef.putFile(File(imageFile.path));
//       }

//       // Upload progress track karen
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         setState(() {
//           _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
//         });
//       });

//       // Upload complete hone ka wait karen
//       TaskSnapshot taskSnapshot = await uploadTask;

//       // Download URL get karen
//       String downloadUrl = await taskSnapshot.ref.getDownloadURL();

//       setState(() {
//         _uploadedImageUrl = downloadUrl;
//         FFAppState().listingImage = _uploadedImageUrl!;
//         _isUploading = false;
//       });

//       // Parent widget ko notify karen
//       if (widget.onImageUploaded != null) {
//         widget.onImageUploaded!(downloadUrl);
//       }

//       // _showSuccessSnackbar('Image successfully upload ho gayi!');
//     } catch (e) {
//       setState(() {
//         _isUploading = false;
//       });
//       _showErrorSnackbar('Upload error: $e');
//     }
//   }

//   // Image source selection dialog (Web ke liye camera option nahi)
//   void _showImageSourceDialog() {
//     if (kIsWeb) {
//       // Web pe directly gallery open karen (camera option nahi hai)
//       _pickImage(ImageSource.gallery);
//     } else {
//       // Mobile/Desktop pe camera aur gallery dono options
//       showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (BuildContext context) {
//           return SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.camera_alt, color: Colors.blue),
//                     title: const Text('Camera'),
//                     onTap: () {
//                       Navigator.pop(context);
//                       _pickImage(ImageSource.camera);
//                     },
//                   ),
//                   ListTile(
//                     leading:
//                         const Icon(Icons.photo_library, color: Colors.green),
//                     title: const Text('Gallery'),
//                     onTap: () {
//                       Navigator.pop(context);
//                       _pickImage(ImageSource.gallery);
//                     },
//                   ),
//                   if (_uploadedImageUrl != null)
//                     ListTile(
//                       leading: const Icon(Icons.delete, color: Colors.red),
//                       title: const Text('Remove Image'),
//                       onTap: () {
//                         Navigator.pop(context);
//                         _removeImage();
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }

//   // Image remove karne ka function
//   void _removeImage() {
//     setState(() {
//       _imageFile = null;
//       _webImageFile = null;
//       _uploadedImageUrl = null;
//     });

//     if (widget.onImageUploaded != null) {
//       widget.onImageUploaded!(''); // Empty string bhej dein
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showSuccessSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   Widget _buildImagePreview() {
//     if (_uploadedImageUrl != null) {
//       // Uploaded image show karen
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             Image.network(
//               _uploadedImageUrl!,
//               fit: BoxFit.cover,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return const Center(
//                   child: Icon(Icons.error, color: Colors.red, size: 40),
//                 );
//               },
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//             // Web pe remove button bhi add karen
//             if (kIsWeb && _uploadedImageUrl != null)
//               Positioned(
//                 top: 8,
//                 left: 8,
//                 child: GestureDetector(
//                   onTap: _removeImage,
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       );
//     } else if (kIsWeb && _webImageFile != null) {
//       // Web pe local preview (before upload)
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: FutureBuilder<Uint8List>(
//           future: _webImageFile!.readAsBytes(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Image.memory(
//                 snapshot.data!,
//                 fit: BoxFit.cover,
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       );
//     } else if (!kIsWeb && _imageFile != null) {
//       // Mobile/Desktop pe local preview
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.file(
//           _imageFile!,
//           fit: BoxFit.cover,
//         ),
//       );
//     }

//     // Placeholder
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
//         SizedBox(height: 8),
//         Text(
//           'Add Image',
//           style: TextStyle(color: Colors.grey, fontSize: 14),
//         ),
//         SizedBox(height: 4),
//         Text(
//           'Click to upload',
//           style: TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _isUploading ? null : _showImageSourceDialog,
//       child: Container(
//         height: 150,
//         width: 150,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Colors.grey[400]!,
//             width: 2,
//           ),
//         ),
//         child: _isUploading
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                       value: _uploadProgress,
//                       strokeWidth: 3,
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       '${(_uploadProgress * 100).toInt()}%',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Uploading...',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : _buildImagePreview(),
//       ),
//     );
 
//   }
// }