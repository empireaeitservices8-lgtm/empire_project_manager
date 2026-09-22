import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class CardDetailSheet extends StatefulWidget {
  final String boardId;
  final String listId;
  final KanbanCard card;

  const CardDetailSheet({
    super.key,
    required this.boardId,
    required this.listId,
    required this.card,
  });

  static Future<void> show(
    BuildContext context, {
    required String boardId,
    required String listId,
    required KanbanCard card,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardDetailSheet(
        boardId: boardId,
        listId: listId,
        card: card,
      ),
    );
  }

  @override
  State<CardDetailSheet> createState() => _CardDetailSheetState();
}

class _CardDetailSheetState extends State<CardDetailSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final TextEditingController _newChecklistController = TextEditingController();
  final FocusNode _newChecklistFocus = FocusNode();

  late Color _selectedColor;
  late String _selectedLabel;
  DateTime? _selectedDueDate;
  late String _currentListId;

  // Preset Luxury Tags
  final List<Map<String, dynamic>> _presetLabels = [
    {'name': 'Design', 'color': NGColors.emerald},
    {'name': 'Marketing', 'color': NGColors.rose},
    {'name': 'Procurement', 'color': NGColors.ruby},
    {'name': 'Workshop', 'color': NGColors.champagne},
    {'name': 'Compliance', 'color': NGColors.goldLight},
    {'name': 'Bespoke', 'color': NGColors.gold},
    {'name': 'Security', 'color': NGColors.ruby},
    {'name': 'Tech', 'color': NGColors.platinum},
    {'name': 'Training', 'color': NGColors.amber},
    {'name': 'Urgent', 'color': NGColors.ruby},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.card.title);
    _descController = TextEditingController(text: widget.card.description);
    _selectedColor = widget.card.labelColor;
    _selectedLabel = widget.card.labelText;
    _selectedDueDate = widget.card.dueDate;
    _currentListId = widget.listId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _newChecklistController.dispose();
    _newChecklistFocus.dispose();
    super.dispose();
  }

  void _saveCardChanges(AppState appState) {
    final updatedCard = widget.card.copyWith(
      title: _titleController.text.trim().isEmpty
          ? widget.card.title
          : _titleController.text.trim(),
      description: _descController.text.trim(),
      labelColor: _selectedColor,
      labelText: _selectedLabel,
      dueDate: _selectedDueDate,
    );

    appState.updateCard(widget.boardId, _currentListId, updatedCard);
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: NGColors.gold,
              onPrimary: Colors.black,
              surface: NGColors.cardBgElevated,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: NGColors.cardBgElevated,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
      if (mounted) {
        final appState = AppState.of(context);
        _saveCardChanges(appState);
      }
    }
  }

  void _addChecklistItem(AppState appState) {
    final text = _newChecklistController.text.trim();
    if (text.isEmpty) return;

    appState.addChecklistItem(
      widget.boardId,
      _currentListId,
      widget.card.id,
      text,
    );

    _newChecklistController.clear();
    _newChecklistFocus.requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final board = appState.getBoardById(widget.boardId);

    // Refresh card reference from state
    final currentList = board?.lists.firstWhere(
      (l) => l.id == _currentListId,
      orElse: () => KanbanList(id: '', title: ''),
    );
    final liveCard = currentList?.cards.firstWhere(
      (c) => c.id == widget.card.id,
      orElse: () => widget.card,
    );

    final checklist = liveCard?.checklist ?? [];
    final totalChecklist = checklist.length;
    final doneChecklist = checklist.where((e) => e.isDone).length;
    final double progress =
        totalChecklist == 0 ? 0.0 : doneChecklist / totalChecklist;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.45,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: NGColors.cardBgElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: NGColors.goldBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: NGColors.gold.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // Header bar with actions
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: _selectedColor.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: _selectedColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _selectedLabel.toUpperCase(),
                            style: TextStyle(
                              color: _selectedColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 22),
                      onPressed: () {
                        _saveCardChanges(appState);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    // Title Field
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Card Title',
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onChanged: (text) => _saveCardChanges(appState),
                    ),
                    const SizedBox(height: 16),

                    // Column Location / Move Card Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: NGColors.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NGColors.subtleBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.view_column_rounded,
                              size: 18, color: NGColors.gold),
                          const SizedBox(width: 10),
                          const Text(
                            'Column:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentListId,
                                dropdownColor: NGColors.cardBgElevated,
                                icon: const Icon(Icons.arrow_drop_down_rounded,
                                    color: NGColors.gold),
                                style: const TextStyle(
                                  color: NGColors.gold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                isExpanded: true,
                                items: (board?.lists ?? []).map((l) {
                                  return DropdownMenuItem<String>(
                                    value: l.id,
                                    child: Text(l.title),
                                  );
                                }).toList(),
                                onChanged: (newListId) {
                                  if (newListId != null &&
                                      newListId != _currentListId) {
                                    appState.moveCard(
                                      widget.boardId,
                                      _currentListId,
                                      newListId,
                                      widget.card,
                                    );
                                    setState(() {
                                      _currentListId = newListId;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Label / Tag Selector Section
                    const Text(
                      'TAG & CATEGORY',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _presetLabels.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final item = _presetLabels[index];
                          final label = item['name'] as String;
                          final color = item['color'] as Color;
                          final isSelected = _selectedLabel == label;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLabel = label;
                                _selectedColor = color;
                              });
                              _saveCardChanges(appState);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.25)
                                    : NGColors.inputBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? color
                                      : NGColors.subtleBorder,
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 3.5,
                                    backgroundColor: color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white70,
                                      fontSize: 12,
                                      fontWeight: isSelected
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
                    const SizedBox(height: 20),

                    // Due Date Selector
                    const Text(
                      'DUE DATE',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickDueDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: NGColors.inputBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.card.isOverdue
                                ? NGColors.ruby
                                : NGColors.subtleBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: widget.card.isOverdue
                                  ? NGColors.ruby
                                  : NGColors.gold,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _selectedDueDate == null
                                  ? 'Set Due Date'
                                  : DateFormat('EEEE, MMM d, yyyy')
                                      .format(_selectedDueDate!),
                              style: TextStyle(
                                color: widget.card.isOverdue
                                    ? const Color(0xFFFF8B9A)
                                    : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.card.isOverdue) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: NGColors.ruby.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'OVERDUE',
                                  style: TextStyle(
                                    color: NGColors.ruby,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            if (_selectedDueDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    size: 16, color: Colors.white54),
                                onPressed: () {
                                  setState(() => _selectedDueDate = null);
                                  _saveCardChanges(appState);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                            else
                              const Icon(Icons.chevron_right_rounded,
                                  size: 18, color: Colors.white38),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Description Section
                    const Text(
                      'DESCRIPTION',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      style: const TextStyle(color: Colors.white, fontSize: 13.5),
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Add a detailed description or notes...',
                      ),
                      onChanged: (text) => _saveCardChanges(appState),
                    ),
                    const SizedBox(height: 24),

                    // Checklist Section Header with Progress
                    Row(
                      children: [
                        const Icon(Icons.checklist_rounded,
                            color: NGColors.gold, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'CHECKLIST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Spacer(),
                        if (totalChecklist > 0)
                          Text(
                            '$doneChecklist / $totalChecklist (${(progress * 100).toInt()}%)',
                            style: const TextStyle(
                              color: NGColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                    if (totalChecklist > 0) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: NGColors.graphite,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(NGColors.gold),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Checklist items
                    ...checklist.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: NGColors.inputBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: NGColors.subtleBorder),
                          ),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.0,
                                child: Checkbox(
                                  value: item.isDone,
                                  onChanged: (_) {
                                    appState.toggleChecklistItem(
                                      widget.boardId,
                                      _currentListId,
                                      widget.card.id,
                                      item.id,
                                    );
                                    setState(() {});
                                  },
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    color: item.isDone
                                        ? Colors.white38
                                        : Colors.white,
                                    fontSize: 13,
                                    decoration: item.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: NGColors.gold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 16, color: Colors.white38),
                                onPressed: () {
                                  appState.deleteChecklistItem(
                                    widget.boardId,
                                    _currentListId,
                                    widget.card.id,
                                    item.id,
                                  );
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // Add new checklist input
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newChecklistController,
                            focusNode: _newChecklistFocus,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Add an item...',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              prefixIcon: const Icon(Icons.add_rounded,
                                  color: NGColors.gold, size: 18),
                            ),
                            onSubmitted: (_) => _addChecklistItem(appState),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () => _addChecklistItem(appState),
                          icon: const Icon(Icons.check_rounded, size: 18),
                          style: IconButton.styleFrom(
                            backgroundColor: NGColors.gold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Lifecycle Actions (Archive & Delete)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final updated = widget.card.copyWith(
                                archived: !widget.card.archived,
                              );
                              appState.updateCard(
                                widget.boardId,
                                _currentListId,
                                updated,
                              );
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              widget.card.archived
                                  ? Icons.unarchive_rounded
                                  : Icons.archive_outlined,
                              size: 16,
                            ),
                            label: Text(
                              widget.card.archived ? 'Restore Card' : 'Archive Card',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Task Card?'),
                                  content: Text(
                                    'Are you sure you want to permanently delete "${widget.card.title}"?',
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
                                        appState.deleteCard(
                                          widget.boardId,
                                          _currentListId,
                                          widget.card.id,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: NGColors.ruby,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_forever_rounded,
                                size: 16, color: NGColors.ruby),
                            label: const Text(
                              'Delete Card',
                              style: TextStyle(
                                  color: NGColors.ruby, fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: NGColors.ruby),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
