import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'card_detail_sheet.dart';

class BoardScreen extends StatefulWidget {
  final String boardId;

  const BoardScreen({
    super.key,
    required this.boardId,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  void _showAddListDialog(BuildContext context, AppState appState) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Column'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'e.g. In Review, Testing, Launched',
            labelText: 'Column Title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                appState.addList(widget.boardId, title);
                Navigator.of(ctx).pop();
                // Scroll to end of list
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (_horizontalController.hasClients) {
                    _horizontalController.animateTo(
                      _horizontalController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });
              }
            },
            child: const Text('Create Column'),
          ),
        ],
      ),
    );
  }

  void _showRenameListDialog(
    BuildContext context,
    AppState appState,
    String listId,
    String currentTitle,
  ) {
    final titleController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Column'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Column Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                appState.renameList(widget.boardId, listId, title);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog(
    BuildContext context,
    AppState appState,
    String listId,
  ) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    Color selectedColor = NGColors.gold;
    String selectedLabel = 'General';
    DateTime? selectedDate;

    final tags = [
      {'name': 'General', 'color': NGColors.gold},
      {'name': 'Design', 'color': NGColors.emerald},
      {'name': 'Marketing', 'color': NGColors.rose},
      {'name': 'Procurement', 'color': NGColors.ruby},
      {'name': 'Workshop', 'color': NGColors.champagne},
      {'name': 'Urgent', 'color': NGColors.ruby},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: NGColors.cardBgElevated,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: NGColors.goldBorder, width: 1.2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create Task Card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white60, size: 20),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'e.g. Client Signoff on Solitaire Blueprint',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Brief context or deliverable specifications...',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tag Chips
                  const Text(
                    'LABEL / CATEGORY',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final tag = tags[i];
                        final name = tag['name'] as String;
                        final color = tag['color'] as Color;
                        final isSel = selectedLabel == name;
                        return GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              selectedLabel = name;
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? color.withValues(alpha: 0.25)
                                  : NGColors.inputBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSel ? color : NGColors.subtleBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 3.5, backgroundColor: color),
                                const SizedBox(width: 5),
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.white60,
                                    fontSize: 11,
                                    fontWeight: isSel
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Due Date Selection Row
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 3)),
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 3)),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: NGColors.gold,
                              onPrimary: Colors.black,
                              surface: NGColors.cardBgElevated,
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setSheetState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: NGColors.inputBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: NGColors.subtleBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 16, color: NGColors.gold),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate == null
                                ? 'Select Due Date (Optional)'
                                : DateFormat('MMM dd, yyyy')
                                    .format(selectedDate!),
                            style: TextStyle(
                              color: selectedDate == null
                                  ? Colors.white54
                                  : Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Add Card Button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isNotEmpty) {
                          final newCard = KanbanCard(
                            id: 'card_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            description: descController.text.trim(),
                            labelColor: selectedColor,
                            labelText: selectedLabel,
                            dueDate: selectedDate,
                            checklist: [],
                          );
                          appState.addCard(widget.boardId, listId, newCard);
                          Navigator.of(ctx).pop();
                        }
                      },
                      child: const Text('CREATE CARD'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final board = appState.getBoardById(widget.boardId);

    if (board == null) {
      return Scaffold(
        backgroundColor: NGColors.obsidian,
        appBar: AppBar(title: const Text('Board Not Found')),
        body: const Center(
          child: Text(
            'This board has been removed.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final totalCards = board.totalCards;
    final totalLists = board.lists.length;

    return Scaffold(
      backgroundColor: NGColors.obsidian,
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              board.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$totalLists columns  •  $totalCards active cards',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: AppLogo(height: 22),
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add_rounded, color: NGColors.gold),
            tooltip: 'Add Column',
            onPressed: () => _showAddListDialog(context, appState),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white70),
            color: NGColors.cardBgElevated,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: NGColors.goldBorder),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Board?'),
                    content: Text(
                      'Are you sure you want to delete "${board.title}" and all its columns?',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white60)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          appState.deleteBoard(board.id);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NGColors.ruby,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Delete Board'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 18, color: NGColors.ruby),
                    SizedBox(width: 8),
                    Text('Delete Board',
                        style: TextStyle(color: NGColors.ruby)),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            height: 3.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  board.color,
                  board.color.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: GlowingOrbsBackground(
        child: Column(
          children: [
            // Horizontal Kanban Columns
            Expanded(
              child: board.lists.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_column_outlined,
                            size: 56,
                            color: NGColors.gold.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No Columns Yet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Add your first workflow stage column',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showAddListDialog(context, appState),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add Column'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _horizontalController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: board.lists.length + 1,
                      itemBuilder: (context, index) {
                        // End "+ Add List" Column card
                        if (index == board.lists.length) {
                          return _buildAddColumnCard(context, appState);
                        }

                        final list = board.lists[index];
                        return _buildKanbanColumn(
                          context,
                          appState,
                          board,
                          list,
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context,
    AppState appState,
    KanbanBoard board,
    KanbanList list,
    int columnIndex,
  ) {
    final activeCards = list.activeCards;

    return Container(
      width: 290,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: NGColors.cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NGColors.goldBorder.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
            decoration: BoxDecoration(
              color: NGColors.charcoal,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: const Border(
                bottom: BorderSide(color: NGColors.subtleBorder),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: board.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    list.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: NGColors.inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: NGColors.subtleBorder),
                  ),
                  child: Text(
                    '${activeCards.length}',
                    style: const TextStyle(
                      color: NGColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded,
                      size: 18, color: Colors.white60),
                  color: NGColors.cardBgElevated,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: NGColors.goldBorder),
                  ),
                  onSelected: (action) {
                    if (action == 'add_card') {
                      _showAddCardDialog(context, appState, list.id);
                    } else if (action == 'rename') {
                      _showRenameListDialog(
                          context, appState, list.id, list.title);
                    } else if (action == 'delete') {
                      appState.deleteList(board.id, list.id);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'add_card',
                      child: Row(
                        children: [
                          Icon(Icons.add_rounded,
                              size: 18, color: NGColors.gold),
                          SizedBox(width: 8),
                          Text('Add Card',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'rename',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined,
                              size: 18, color: Colors.white70),
                          SizedBox(width: 8),
                          Text('Rename Column',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 18, color: NGColors.ruby),
                          SizedBox(width: 8),
                          Text('Delete Column',
                              style: TextStyle(color: NGColors.ruby)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Column Task Cards List
          Expanded(
            child: activeCards.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.post_add_rounded,
                            size: 36,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No Tasks',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.35),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: activeCards.length,
                    itemBuilder: (context, cardIdx) {
                      final card = activeCards[cardIdx];
                      return _buildKanbanTaskCard(
                        context,
                        appState,
                        board,
                        list,
                        card,
                      );
                    },
                  ),
          ),

          // Bottom "+ Add Task" quick button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: NGColors.subtleBorder)),
            ),
            child: InkWell(
              onTap: () => _showAddCardDialog(context, appState, list.id),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_rounded,
                        size: 16, color: NGColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      'Add Card',
                      style: TextStyle(
                        color: NGColors.gold.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanTaskCard(
    BuildContext context,
    AppState appState,
    KanbanBoard board,
    KanbanList currentList,
    KanbanCard card,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: NGColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => CardDetailSheet.show(
            context,
            boardId: board.id,
            listId: currentList.id,
            card: card,
          ),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: card.isOverdue
                    ? NGColors.ruby.withValues(alpha: 0.6)
                    : NGColors.subtleBorder,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Tag Pill & Quick Menu
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: card.labelColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: card.labelColor.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        card.labelText.toUpperCase(),
                        style: TextStyle(
                          color: card.labelColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.more_horiz_rounded,
                          size: 16, color: Colors.white38),
                      color: NGColors.cardBgElevated,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: NGColors.goldBorder),
                      ),
                      onSelected: (targetListId) {
                        if (targetListId == 'delete') {
                          appState.deleteCard(
                              board.id, currentList.id, card.id);
                        } else {
                          appState.moveCard(
                              board.id, currentList.id, targetListId, card);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            enabled: false,
                            child: Text(
                              'MOVE TO COLUMN:',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: NGColors.gold,
                              ),
                            ),
                          ),
                          ...board.lists
                              .where((l) => l.id != currentList.id)
                              .map(
                                (l) => PopupMenuItem<String>(
                                  value: l.id,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_forward_rounded,
                                          size: 14, color: Colors.white70),
                                      const SizedBox(width: 6),
                                      Text(l.title,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                          const PopupMenuDivider(),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded,
                                    size: 14, color: NGColors.ruby),
                                SizedBox(width: 6),
                                Text('Delete Task',
                                    style: TextStyle(
                                        color: NGColors.ruby, fontSize: 12)),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Card Title
                Text(
                  card.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),

                // Card Description snippet
                if (card.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    card.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                  ),
                ],
                const SizedBox(height: 10),

                // Bottom Meta: Due Date & Checklist Badges
                Row(
                  children: [
                    // Due Date Badge
                    if (card.dueDate != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: card.isOverdue
                              ? NGColors.ruby.withValues(alpha: 0.25)
                              : NGColors.charcoal,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: card.isOverdue
                                ? NGColors.ruby
                                : NGColors.subtleBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 11,
                              color: card.isOverdue
                                  ? const Color(0xFFFF8B9A)
                                  : NGColors.gold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d').format(card.dueDate!),
                              style: TextStyle(
                                color: card.isOverdue
                                    ? const Color(0xFFFF8B9A)
                                    : Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Checklist Progress Badge
                    if (card.checklistTotal > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: card.checklistDone == card.checklistTotal
                              ? NGColors.emerald.withValues(alpha: 0.25)
                              : NGColors.charcoal,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: card.checklistDone == card.checklistTotal
                                ? NGColors.emerald
                                : NGColors.subtleBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              card.checklistDone == card.checklistTotal
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.checklist_rounded,
                              size: 11,
                              color:
                                  card.checklistDone == card.checklistTotal
                                      ? const Color(0xFF76D275)
                                      : Colors.white60,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${card.checklistDone}/${card.checklistTotal}',
                              style: TextStyle(
                                color:
                                    card.checklistDone == card.checklistTotal
                                        ? const Color(0xFF76D275)
                                        : Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddColumnCard(BuildContext context, AppState appState) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: NGColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NGColors.goldBorder.withValues(alpha: 0.4),
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () => _showAddListDialog(context, appState),
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NGColors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: NGColors.gold),
                ),
                child: const Icon(Icons.add_rounded,
                    color: NGColors.gold, size: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                'Add Column',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
