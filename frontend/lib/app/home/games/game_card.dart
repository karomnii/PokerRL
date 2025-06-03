// import 'package:flutter/material.dart';
// import 'package:frontend/api/swagger.models.swagger.dart' as api;
// import 'package:get/get.dart';

// class GameCard extends StatelessWidget {
//   const GameCard({
//     super.key,
//     required this.game,
//     this.onJoin,
//   });

//   final api.ActiveGameDto game;
//   final VoidCallback? onJoin;

//   // String _ownerName() {
//   //   // Safely pick the first active player, fall back to “Unknown”
//   //   try {
//   //     // final owner = game.gamePlayers?.firstWhereOrNull((gp) => gp.isActive!);
//   //     // return owner?.user!.username ?? 'Unknown';
//   //   } catch (_) {
//   //     return 'Unknown';
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text(
//               game.tableId?.toString() ?? 'Unnamed table',
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               'Owner: ${_ownerName()}',
//               style: const TextStyle(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//             ElevatedButton(
//               onPressed: onJoin ??
//                   () {
//                     Get.snackbar('Info', 'Joined game ${game.gameId}');
//                   },
//               child: const Text('Join'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
