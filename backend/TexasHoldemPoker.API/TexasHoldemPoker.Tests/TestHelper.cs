using System;
using System.Collections.Generic;
using TexasHoldemPoker.API.Models;

namespace TexasHoldemPoker.Tests
{
    public static class TestHelper
    {
        public static PokerTable CreateTestTable(int id = 1, string name = null)
        {
            return new PokerTable
            {
                TableId = id,
                Name = name ?? $"Test Table {id}",
                EntryFee = 100,
                MinBuyIn = 500,
                MaxBuyIn = 1000,
                SmallBlind = 10,
                BigBlind = 20,
                MaxPlayers = 9,
                DifficultyLevel = "Beginner",
                IsActive = true
            };
        }

        public static User CreateTestUser(int id = 1, string username = null)
        {
            return new User
            {
                UserId = id,
                Username = username ?? $"TestUser{id}",
                Email = $"user{id}@example.com",
                PasswordHash = $"hashedpassword{id}",
                ChipsBalance = 1000,
                RegistrationDate = DateTime.UtcNow,
                IsActive = true
            };
        }

        public static Game CreateTestGame(int id = 1, int tableId = 1, string currentState = "Waiting")
        {
            return new Game
            {
                GameId = id,
                TableId = tableId,
                StartTime = DateTime.UtcNow,
                CurrentState = currentState,
                PotSize = 0
            };
        }

        public static GamePlayer CreateTestGamePlayer(int gameId = 1, int userId = 1, int seatPosition = 1, bool isActive = true)
        {
            return new GamePlayer
            {
                GameId = gameId,
                UserId = userId,
                SeatPosition = seatPosition,
                InitialChips = 1000,
                CurrentChips = 1000,
                IsActive = isActive,
                IsDealer = false,
                IsSmallBlind = false,
                IsBigBlind = false
            };
        }

        public static Card CreateTestCard(int id, string suit, string value)
        {
            return new Card
            {
                CardId = id,
                Suit = suit,
                Value = value
            };
        }

        public static List<Card> CreateTestDeck()
        {
            var cards = new List<Card>();
            string[] suits = { "Hearts", "Diamonds", "Clubs", "Spades" };
            string[] values = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" };
            int id = 1;

            foreach (var suit in suits)
            {
                foreach (var value in values)
                {
                    cards.Add(CreateTestCard(id++, suit, value));
                }
            }

            return cards;
        }

        public static Move CreateTestMove(int gameId = 1, int playerId = 1, string actionType = "Check", int amount = 0, string round = "PreFlop")
        {
            return new Move
            {
                GameId = gameId,
                PlayerId = playerId,
                ActionType = actionType,
                Amount = amount,
                MoveTime = DateTime.UtcNow,
                Round = round
            };
        }

        public static CommunityCard CreateTestCommunityCard(int gameId = 1, int cardId = 1, int position = 1)
        {
            return new CommunityCard
            {
                GameId = gameId,
                CardId = cardId,
                Position = position
            };
        }

        public static PlayerCard CreateTestPlayerCard(int gamePlayerId = 1, int cardId = 1, int position = 1)
        {
            return new PlayerCard
            {
                GamePlayerId = gamePlayerId,
                CardId = cardId,
                Position = position
            };
        }

        public static Game CreateTestGameWithCurrentTurn(int gameId = 1, int tableId = 1, int currentTurnUserId = 1, string currentState = "PreFlop")
        {
            return new Game
            {
                GameId = gameId,
                TableId = tableId,
                StartTime = DateTime.UtcNow,
                CurrentState = currentState,
                PotSize = 0,
                CurrentTurnUserId = currentTurnUserId
            };
        }
    }
}
