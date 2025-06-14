import 'package:flutter/material.dart';
import 'package:frontend/app/home/leaderboard/leaderboard.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class LeaderboardPageView extends GetView<LeaderboardPageController> {
  const LeaderboardPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      appBar: ThemedAppBar(title: 'Leaderboard'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const CircularProgressIndicator();
            }

            final leaderboard = controller.leaderboard;

            if (leaderboard.isEmpty) {
              return const Text('No leaderboard data available.');
            }

            final filteredLeaderboard = leaderboard
                .where((player) =>
                    player.userId != 1 &&
                    player.userId != 2 &&
                    player.userId != 3)
                .toList();

            return PageCard(
              title: 'Top Players',
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: filteredLeaderboard.length,
                  itemBuilder: (context, index) {
                    final player = filteredLeaderboard[index];

                    Widget icon;
                    if (index == 0) {
                      icon = const Icon(Icons.emoji_events,
                          color: Color(0xFFFFD700), size: 35);
                    } else if (index == 1) {
                      icon = const Icon(Icons.emoji_events,
                          color: Color(0xFFC0C0C0), size: 35);
                    } else if (index == 2) {
                      icon = const Icon(Icons.emoji_events,
                          color: Color(0xFF8B4513), size: 35);
                    } else {
                      icon = const Icon(Icons.military_tech,
                          color: Colors.grey, size: 35);
                    }

                    final avatarPath =
                        player.avatarImage ?? '/images/default.png';

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(avatarPath),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              player.username ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          icon,
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Games Won: ${player.gamesWon ?? 0}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Win Ratio: ${(player.winRatio ?? 0).toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Chips: ${player.chipsBalance ?? 0}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
