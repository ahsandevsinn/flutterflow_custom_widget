import 'package:flutter/material.dart';

// class CustomDateTimePicker extends StatefulWidget {
//   const CustomDateTimePicker({super.key});

//   @override
//   State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
// }

// class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;

//   String formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }
// Future<void> selectTime() async {
   
//     final TimeOfDay? pickedStart = await showTimePicker(
//       initialEntryMode : TimePickerEntryMode.dial,
//       context: context,
//       initialTime: TimeOfDay.now(),
//       helpText: 'Start Time',
      
//     );

//     if (pickedStart != null) {
//       // Then immediately select end time
//       final TimeOfDay? pickedEnd = await showTimePicker(
//         context: context,
//         initialTime: pickedStart,
//         helpText: 'End Time',

//       );

//       if (pickedEnd != null) {
//         setState(() {
//           startTime = pickedStart;
//           endTime = pickedEnd;
//         });
//       }
//     }
//   }



//   String getDisplayText() {
//     if (startTime == null) {
//       return '[jm]';
//     } else if (endTime == null) {
//       return formatTimeOfDay(startTime!);
//     } else {
//       return '${formatTimeOfDay(startTime!)} - ${formatTimeOfDay(endTime!)}';
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 40),
//             const Text(
//               'Start Time / End Time',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 16),
//             GestureDetector(
//               onTap: selectTime,
//               child: Container(
//                 width: double.infinity,
//                 height: 42.0,
                
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFFF8ED),
//                   border: Border.all(
//                     color: const Color(0xFFE07A5F),
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     getDisplayText(),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
         
//           ],
//         ),
      
//       );
    
//   }}


// import 'package:flutter/material.dart';

class CustomDateTimePicker extends StatefulWidget {
  final String? initialStartTime;
  final String? initialEndTime;

  const CustomDateTimePicker({
    super.key,
    this.initialStartTime,
    this.initialEndTime,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    // Convert incoming string times (like "9:30 AM") into TimeOfDay
    startTime = _parseTime(widget.initialStartTime);
    endTime = _parseTime(widget.initialEndTime);
  }

  /// 🕓 Converts a string like "9:30 AM" or "17:00" → TimeOfDay
  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    try {
      // Handle both "9:30 AM" and "09:30" formats
      final time = timeString.trim().toUpperCase();
      final parts = time.split(' ');

      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final period = parts[1];
        if (period == 'PM' && hour < 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('⚠️ Invalid time format: $timeString');
      return null;
    }
  }

  /// Converts TimeOfDay → formatted string like "9:30 AM"
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedStart = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      helpText: 'Start Time',
    );

    if (pickedStart != null) {
      final TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: pickedStart,
        helpText: 'End Time',
      );

      if (pickedEnd != null) {
        setState(() {
          startTime = pickedStart;
          endTime = pickedEnd;
        });
      }
    }
  }

  String getDisplayText() {
    if (startTime == null && endTime == null) {
      return '[jm]';
    } else if (endTime == null) {
      return formatTimeOfDay(startTime!);
    } else {
      return '${formatTimeOfDay(startTime!)} - ${formatTimeOfDay(endTime!)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Start Time / End Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: selectTime,
            child: Container(
              width: double.infinity,
              height: 42.0,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8ED),
                border: Border.all(
                  color: const Color(0xFFE07A5F),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getDisplayText(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
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

// // Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// class CustomStartEndTimePicker extends StatefulWidget {
//   const CustomStartEndTimePicker({
//     super.key,
//     this.width,
//     this.height,
//     this.onStartTime,
//     this.onEndTime,
//   });

//   final double? width;
//   final double? height;
//   final Future Function(String? startTime)? onStartTime;
//   final Future Function(String? endTime)? onEndTime;

//   @override
//   State<CustomStartEndTimePicker> createState() =>
//       _CustomStartEndTimePickerState();
// }

// class _CustomStartEndTimePickerState extends State<CustomStartEndTimePicker> {
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;

//   String formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hour:$minute $period';
//   }

//   Future<void> selectTime() async {
//     // First, select start time
//     final TimeOfDay? pickedStart = await showTimePicker(
//       initialEntryMode: TimePickerEntryMode.dial,
//       context: context,
//       initialTime: TimeOfDay.now(),
//       helpText: 'Start Time',
//     );

//     if (pickedStart != null) {
//       // Then immediately select end time
//       final TimeOfDay? pickedEnd = await showTimePicker(
//         context: context,
//         initialTime: pickedStart,
//         helpText: 'End Time',
//       );

//       if (pickedEnd != null) {
//         setState(() {
//           startTime = pickedStart;
//           endTime = pickedEnd;
          // final localizations = MaterialLocalizations.of(context);
          // String? startTimeString = startTime != null
          //     ? localizations.formatTimeOfDay(startTime!)
          //     : null;
          // String? endTimeString =
          //     endTime != null ? localizations.formatTimeOfDay(endTime!) : null;
          // widget.onStartTime?.call(startTimeString);
          // widget.onEndTime?.call(endTimeString);
//         });
//       }
//     }
//   }

//   // Future<void> selectTime() async {
//   //   final TimeOfDay? picked = await showTimePicker(
//   //     context: context,
//   //     initialTime: TimeOfDay.now(),
//   //   );

//   //   if (picked != null) {
//   //     setState(() {
//   //       if (startTime == null) {
//   //         // First selection is start time
//   //         startTime = picked;
//   //       } else if (endTime == null) {
//   //         // Second selection is end time
//   //         endTime = picked;
//   //       } else {
//   //         // Reset and start over
//   //         startTime = picked;
//   //         endTime = null;
//   //       }
//   //     });
//   //   }
//   // }

//   String getDisplayText() {
//     if (startTime == null) {
//       return '[jm]';
//     } else if (endTime == null) {
//       return formatTimeOfDay(startTime!);
//     } else {
//       return '${formatTimeOfDay(startTime!)} - ${formatTimeOfDay(endTime!)}';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     const Text(
    //       'Start Time / End Time',
    //       style: TextStyle(
    //         fontSize: 14,
    //         fontWeight: FontWeight.bold,
    //         color: Colors.black,
    //       ),
    //     ),
    //     const SizedBox(height: 10),
    //     GestureDetector(
    //       onTap: selectTime,
    //       child: Container(
    //         width: double.infinity,
    //         height: 42.0,
    //         decoration: BoxDecoration(
    //           color: const Color(0xFFFFF8ED),
    //           border: Border.all(
    //             color: const Color(0xFFE07A5F),
    //             width: 2,
    //           ),
    //           borderRadius: BorderRadius.circular(8),
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(
    //             getDisplayText(),
    //             style: const TextStyle(
    //               fontSize: 16,
    //               color: Colors.black87,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
//   }
// }


class CustomStartEndTimePicker extends StatefulWidget {
  const CustomStartEndTimePicker({
    super.key,
    this.width,
    this.height,
    this.onStartTime,
    this.onEndTime,
    this.initialStartTime,
    this.initialEndTime,
  });

  final double? width;
  final double? height;
  final Future Function(String? startTime)? onStartTime;
  final Future Function(String? endTime)? onEndTime;
  final String? initialStartTime;
  final String? initialEndTime;

  @override
  State<CustomStartEndTimePicker> createState() =>
      _CustomStartEndTimePickerState();
}

class _CustomStartEndTimePickerState extends State<CustomStartEndTimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    // Convert incoming string times (like "9:30 AM") into TimeOfDay
    startTime = _parseTime(widget.initialStartTime);
    endTime = _parseTime(widget.initialEndTime);
  }

  /// 🕓 Converts a string like "9:30 AM" or "17:00" → TimeOfDay
  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    try {
      // Handle both "9:30 AM" and "09:30" formats
      final time = timeString.trim().toUpperCase();
      final parts = time.split(' ');

      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final period = parts[1];
        if (period == 'PM' && hour < 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('⚠️ Invalid time format: $timeString');
      return null;
    }
  }

  /// Converts TimeOfDay → formatted string like "9:30 AM"
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedStart = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      helpText: 'Start Time',
    );

    if (pickedStart != null) {
      final TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: pickedStart,
        helpText: 'End Time',
      );

      if (pickedEnd != null) {
        setState(() {
          startTime = pickedStart;
          endTime = pickedEnd;
          final localizations = MaterialLocalizations.of(context);
          String? startTimeString = startTime != null
              ? localizations.formatTimeOfDay(startTime!)
              : null;
          String? endTimeString =
              endTime != null ? localizations.formatTimeOfDay(endTime!) : null;
          widget.onStartTime?.call(startTimeString);
          widget.onEndTime?.call(endTimeString);
        });
      }
    }
  }

  String getDisplayText() {
    if (startTime == null && endTime == null) {
      return '[jm]';
    } else if (endTime == null) {
      return formatTimeOfDay(startTime!);
    } else {
      return '${formatTimeOfDay(startTime!)} - ${formatTimeOfDay(endTime!)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start Time / End Time',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: selectTime,
          child: Container(
            width: double.infinity,
            height: 42.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8ED),
              border: Border.all(
                color: const Color(0xFFE07A5F),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getDisplayText(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
 
  }
}


class TimePicker extends StatefulWidget {
  const TimePicker({
    super.key,
    this.width,
    this.height,
    this.onStartTime,
    this.onEndTime,
    this.initialStartTime,
    this.initialEndTime,
  });

  final double? width;
  final double? height;
  final Future Function(String? startTIme)? onStartTime;
  final Future Function(String? endTime)? onEndTime;
  final String? initialStartTime;
  final String? initialEndTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    // Convert incoming string times (like "9:30 AM") into TimeOfDay
    startTime = _parseTime(widget.initialStartTime);
    endTime = _parseTime(widget.initialEndTime);
  }

  /// 🕓 Converts a string like "9:30 AM" or "17:00" → TimeOfDay
  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    try {
      // Handle both "9:30 AM" and "09:30" formats
      final time = timeString.trim().toUpperCase();
      final parts = time.split(' ');

      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final period = parts[1];
        if (period == 'PM' && hour < 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      debugPrint('⚠️ Invalid time format: $timeString');
      return null;
    }
  }

  /// Converts TimeOfDay → formatted string like "9:30 AM"
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedStart = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      helpText: 'Start Time',
    );

    if (pickedStart != null) {
      final TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: pickedStart,
        helpText: 'End Time',
      );

      if (pickedEnd != null) {
        setState(() {
          startTime = pickedStart;
          endTime = pickedEnd;
          final localizations = MaterialLocalizations.of(context);
          String? startTimeString = startTime != null
              ? localizations.formatTimeOfDay(startTime!)
              : null;
          String? endTimeString =
              endTime != null ? localizations.formatTimeOfDay(endTime!) : null;
          widget.onStartTime?.call(startTimeString);
          widget.onEndTime?.call(endTimeString);
        });
      }
    }
  }

  String getDisplayText() {
    if (startTime == null && endTime == null) {
      return '';
    } else if (endTime == null) {
      return formatTimeOfDay(startTime!);
    } else {
      return '${formatTimeOfDay(startTime!)} - ${formatTimeOfDay(endTime!)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start Time / End Time',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: selectTime,
          child: Container(
            width: double.infinity,
            height: 42.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8ED),
              border: Border.all(
                color: const Color(0xFFE07A5F),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getDisplayText(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  
  }
}

