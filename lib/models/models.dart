import 'package:flutter/material.dart';

/// Single item in a card's task checklist
class ChecklistItem {
  final String id;
  String title;
  bool isDone;

  ChecklistItem({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  ChecklistItem copyWith({
    String? id,
    String? title,
    bool? isDone,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
  };

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
    );
  }
}

/// Task card in a Kanban list column
class KanbanCard {
  final String id;
  String title;
  String description;
  Color labelColor;
  String labelText;
  DateTime? dueDate;
  List<ChecklistItem> checklist;
  bool archived;

  KanbanCard({
    required this.id,
    required this.title,
    this.description = '',
    required this.labelColor,
    required this.labelText,
    this.dueDate,
    List<ChecklistItem>? checklist,
    this.archived = false,
  }) : checklist = checklist ?? [];

  int get checklistTotal => checklist.length;
  int get checklistDone => checklist.where((item) => item.isDone).length;
  double get checklistProgress =>
      checklistTotal == 0 ? 0.0 : (checklistDone / checklistTotal);

  bool get isOverdue {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return due.isBefore(today);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  KanbanCard copyWith({
    String? id,
    String? title,
    String? description,
    Color? labelColor,
    String? labelText,
    DateTime? dueDate,
    List<ChecklistItem>? checklist,
    bool? archived,
  }) {
    return KanbanCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      labelColor: labelColor ?? this.labelColor,
      labelText: labelText ?? this.labelText,
      dueDate: dueDate ?? this.dueDate,
      checklist: checklist ?? this.checklist.map((e) => e.copyWith()).toList(),
      archived: archived ?? this.archived,
    );
  }
}

/// Column list containing Kanban task cards
class KanbanList {
  final String id;
  String title;
  List<KanbanCard> cards;

  KanbanList({
    required this.id,
    required this.title,
    List<KanbanCard>? cards,
  }) : cards = cards ?? [];

  List<KanbanCard> get activeCards =>
      cards.where((card) => !card.archived).toList();

  KanbanList copyWith({
    String? id,
    String? title,
    List<KanbanCard>? cards,
  }) {
    return KanbanList(
      id: id ?? this.id,
      title: title ?? this.title,
      cards: cards ?? this.cards.map((e) => e.copyWith()).toList(),
    );
  }
}

/// Top-level project Kanban Board
class KanbanBoard {
  final String id;
  String title;
  Color color;
  String description;
  List<KanbanList> lists;
  final DateTime createdAt;

  KanbanBoard({
    required this.id,
    required this.title,
    required this.color,
    this.description = '',
    List<KanbanList>? lists,
    DateTime? createdAt,
  })  : lists = lists ?? [],
        createdAt = createdAt ?? DateTime.now();

  int get totalCards =>
      lists.fold(0, (sum, list) => sum + list.activeCards.length);

  int get totalChecklistDone => lists.fold(
        0,
        (sum, list) =>
            sum +
            list.activeCards.fold(
              0,
              (cSum, card) => cSum + card.checklistDone,
            ),
      );

  int get totalChecklistItems => lists.fold(
        0,
        (sum, list) =>
            sum +
            list.activeCards.fold(
              0,
              (cSum, card) => cSum + card.checklistTotal,
            ),
      );

  double get overallProgress {
    if (totalChecklistItems == 0) {
      if (totalCards == 0) return 0.0;
      // If no checklist items, check if cards are in the last list
      if (lists.isEmpty) return 0.0;
      final doneCards = lists.last.activeCards.length;
      return doneCards / totalCards;
    }
    return totalChecklistDone / totalChecklistItems;
  }

  KanbanBoard copyWith({
    String? id,
    String? title,
    Color? color,
    String? description,
    List<KanbanList>? lists,
    DateTime? createdAt,
  }) {
    return KanbanBoard(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      description: description ?? this.description,
      lists: lists ?? this.lists.map((e) => e.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
