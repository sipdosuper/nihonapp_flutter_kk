// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class MessageWidget extends StatelessWidget {
//   const MessageWidget({
//     super.key,
//     required this.text,
//     required this.isFromUser,
//   });

//   final String text;
//   final bool isFromUser;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Flexible(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 520),
//             decoration: BoxDecoration(
//               color: isFromUser
//                   ? Theme.of(context).colorScheme.primary
//                   : Theme.of(context).colorScheme.secondary,
//             ), // BoxDecoration
//             child: Column(
//               children: [
//                 MarkdownBody.(data: text),
//               ],
//             ), // Column
//           ), // Container
//         ), // Flexible
//       ],
//     );
//   }
// }
