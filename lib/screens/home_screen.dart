import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'board_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  void _showNewBoardDialog(BuildContext context, AppState appState) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    Color selectedColor = NGColors.gold;

    final palette = [
      {'name': 'Gold', 'color': NGColors.gold},
      {'name': 'Rose', 'color': NGColors.rose},
      {'name': 'Graphite', 'color': NGColors.graphite},
      {'name': 'Bronze', 'color': NGColors.bronze},
      {'name': 'Emerald', 'color': NGColors.emerald},
      {'name': 'Sapphire', 'color': NGColors.sapphire},
      {'name': 'Ruby', 'color': NGColors.ruby},
      {'name': 'Platinum', 'color': NGColors.platinum},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.dashboard_customize_rounded,
                      color: selectedColor, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'New Project Board',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Board Title',
                      hintText: 'e.g. Autumn Royal Showcase',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'High-level purpose and milestone goals...',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'THEME ACCENT COLOR',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: palette.map((p) {
                      final c = p['color'] as Color;
                      final isSel = selectedColor == c;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => selectedColor = c);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: c.withValues(alpha: 0.6),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSel
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.black)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.white60)),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    final newBoard = KanbanBoard(
                      id: 'board_${DateTime.now().millisecondsSinceEpoch}',
                      title: title,
                      color: selectedColor,
                      description: descController.text.trim(),
                      lists: [
                        KanbanList(
                          id: 'col_${DateTime.now().millisecondsSinceEpoch}_1',
                          title: 'To Do',
                          cards: [],
                        ),
                        KanbanList(
                          id: 'col_${DateTime.now().millisecondsSinceEpoch}_2',
                          title: 'In Progress',
                          cards: [],
                        ),
                        KanbanList(
                          id: 'col_${DateTime.now().millisecondsSinceEpoch}_3',
                          title: 'Done',
                          cards: [],
                        ),
                      ],
                    );
                    appState.addBoard(newBoard);
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Create Board'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditBoardDialog(
    BuildContext context,
    AppState appState,
    KanbanBoard board,
  ) {
    final titleController = TextEditingController(text: board.title);
    final descController = TextEditingController(text: board.description);
    Color selectedColor = board.color;

    final palette = [
      {'name': 'Gold', 'color': NGColors.gold},
      {'name': 'Rose', 'color': NGColors.rose},
      {'name': 'Graphite', 'color': NGColors.graphite},
      {'name': 'Bronze', 'color': NGColors.bronze},
      {'name': 'Emerald', 'color': NGColors.emerald},
      {'name': 'Sapphire', 'color': NGColors.sapphire},
      {'name': 'Ruby', 'color': NGColors.ruby},
      {'name': 'Platinum', 'color': NGColors.platinum},
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Project Board'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Board Title'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'THEME ACCENT COLOR',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: palette.map((p) {
                      final c = p['color'] as Color;
                      final isSel = selectedColor == c;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => selectedColor = c);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: c.withValues(alpha: 0.6),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSel
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.black)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.white60)),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    appState.updateBoard(
                      board.id,
                      title: title,
                      description: descController.text.trim(),
                      color: selectedColor,
                    );
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final allBoards = appState.boards;
    final filteredBoards = _searchQuery.isEmpty
        ? allBoards
        : allBoards.where((b) {
            return b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                b.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

    return Scaffold(
      backgroundColor: NGColors.obsidian,
      body: GlowingOrbsBackground(
        child: CustomScrollView(
          slivers: [
            // Luxury SliverAppBar
            SliverAppBar(
              expandedHeight: 160.0,
              floating: false,
              pinned: true,
              backgroundColor: NGColors.obsidian,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: NGColors.goldGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.diamond_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'EMPIRE PM',
                      style: TextStyle(
                        color: NGColors.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF221A0C),
                            Color(0xFF141414),
                            NGColors.obsidian,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Decorative subtitle in background
                    Positioned(
                      left: 20,
                      top: 48,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: NGColors.cardBg.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: NGColors.goldBorder,
                                    width: 1,
                                  ),
                                ),
                                child: const AppLogo(
                                  height: 28,
                                  withGlow: false,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXECUTIVE PORTFOLIO',
                                    style: TextStyle(
                                      color:
                                          NGColors.gold.withValues(alpha: 0.85),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Empire AEI Atelier',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout_rounded,
                                color: Colors.white60, size: 20),
                            tooltip: 'Sign Out',
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Metrics Strip & Search Section
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Metrics Strip (4 metrics)
                    _buildMetricsStrip(appState),
                    const SizedBox(height: 20),

                    // Search & Filter Bar
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: NGColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NGColors.subtleBorder),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search workspaces, campaigns, or tasks...',
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: NGColors.gold, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 16, color: Colors.white54),
                                  onPressed: () =>
                                      setState(() => _searchQuery = ''),
                                )
                              : null,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section Heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PROJECT WORKSPACES',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          '${filteredBoards.length} Active',
                          style: const TextStyle(
                            color: NGColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // 2-Column Board Grid or Empty State
            if (filteredBoards.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(context, appState),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final board = filteredBoards[index];
                      return _buildBoardCard(context, appState, board);
                    },
                    childCount: filteredBoards.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewBoardDialog(context, appState),
        backgroundColor: NGColors.gold,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          'NEW BOARD',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsStrip(AppState appState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Active Boards',
                value: '${appState.totalBoards}',
                icon: Icons.dashboard_outlined,
                accentColor: NGColors.gold,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'Total Columns',
                value: '${appState.totalColumns}',
                icon: Icons.view_column_outlined,
                accentColor: NGColors.rose,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'Active Tasks',
                value: '${appState.totalActiveCards}',
                icon: Icons.assignment_outlined,
                accentColor: NGColors.champagne,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                title: 'Completed',
                value: '${appState.totalCompletedTasks}',
                icon: Icons.verified_outlined,
                accentColor: NGColors.emerald,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: NGColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: accentColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardCard(
    BuildContext context,
    AppState appState,
    KanbanBoard board,
  ) {
    final progress = board.overallProgress;

    return Material(
      color: NGColors.cardBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BoardScreen(boardId: board.id),
            ),
          );
        },
        onLongPress: () => _showEditBoardDialog(context, appState, board),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: board.color.withValues(alpha: 0.4),
              width: 1.2,
            ),
            gradient: LinearGradient(
              colors: [
                board.color.withValues(alpha: 0.08),
                NGColors.cardBg,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Color Tag and Menu Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: board.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: board.color.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.more_horiz_rounded,
                        size: 18, color: Colors.white54),
                    color: NGColors.cardBgElevated,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: NGColors.goldBorder),
                    ),
                    onSelected: (action) {
                      if (action == 'edit') {
                        _showEditBoardDialog(context, appState, board);
                      } else if (action == 'delete') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Board?'),
                            content: Text(
                              'Are you sure you want to delete "${board.title}"?',
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
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 16, color: Colors.white70),
                            SizedBox(width: 8),
                            Text('Edit Info',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded,
                                size: 16, color: NGColors.ruby),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(color: NGColors.ruby)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                board.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),

              // Description Snippet
              Expanded(
                child: Text(
                  board.description.isEmpty
                      ? 'No description provided'
                      : board.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: NGColors.graphite,
                  valueColor: AlwaysStoppedAnimation<Color>(board.color),
                ),
              ),
              const SizedBox(height: 10),

              // Footer: Columns count & Cards count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.view_column_rounded,
                          size: 12, color: Colors.white.withValues(alpha: 0.4)),
                      const SizedBox(width: 4),
                      Text(
                        '${board.lists.length} cols',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: NGColors.inputBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: NGColors.subtleBorder),
                    ),
                    child: Text(
                      '${board.totalCards} tasks',
                      style: const TextStyle(
                        color: NGColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: NGColors.cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: NGColors.goldBorder, width: 1.5),
              ),
              child: const Icon(
                Icons.dashboard_outlined,
                size: 40,
                color: NGColors.gold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Workspaces Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No boards matched your search query.'
                  : 'Organize your luxury collections, campaigns, and operations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showNewBoardDialog(context, appState),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create New Board'),
            ),
          ],
        ),
      ),
    );
  }
}
