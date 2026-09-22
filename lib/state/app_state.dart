import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Global application state with full CRUD and reactive updates
class AppState extends ChangeNotifier {
  final List<KanbanBoard> _boards = [];

  AppState() {
    _initializeSampleData();
  }

  List<KanbanBoard> get boards => List.unmodifiable(_boards);

  int get totalBoards => _boards.length;

  int get totalColumns =>
      _boards.fold(0, (sum, board) => sum + board.lists.length);

  int get totalActiveCards =>
      _boards.fold(0, (sum, board) => sum + board.totalCards);

  int get totalCompletedTasks => _boards.fold(0, (sum, board) {
        if (board.lists.isEmpty) return sum;
        // The last list in each board represents the completed / launched stage
        return sum + board.lists.last.activeCards.length;
      });

  int get totalCompletedChecklistItems =>
      _boards.fold(0, (sum, board) => sum + board.totalChecklistDone);

  int get totalChecklistItems =>
      _boards.fold(0, (sum, board) => sum + board.totalChecklistItems);

  KanbanBoard? getBoardById(String id) {
    try {
      return _boards.firstWhere((board) => board.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==================== BOARD ACTIONS ====================

  void addBoard(KanbanBoard board) {
    _boards.add(board);
    notifyListeners();
  }

  void deleteBoard(String boardId) {
    _boards.removeWhere((board) => board.id == boardId);
    notifyListeners();
  }

  void updateBoardTitle(String boardId, String newTitle) {
    final index = _boards.indexWhere((b) => b.id == boardId);
    if (index != -1) {
      _boards[index].title = newTitle;
      notifyListeners();
    }
  }

  void updateBoard(
    String boardId, {
    String? title,
    String? description,
    Color? color,
  }) {
    final index = _boards.indexWhere((b) => b.id == boardId);
    if (index != -1) {
      if (title != null) _boards[index].title = title;
      if (description != null) _boards[index].description = description;
      if (color != null) _boards[index].color = color;
      notifyListeners();
    }
  }

  // ==================== LIST (COLUMN) ACTIONS ====================

  void addList(String boardId, String title) {
    final board = getBoardById(boardId);
    if (board != null) {
      final newList = KanbanList(
        id: 'col_${DateTime.now().millisecondsSinceEpoch}_${board.lists.length}',
        title: title,
        cards: [],
      );
      board.lists.add(newList);
      notifyListeners();
    }
  }

  void deleteList(String boardId, String listId) {
    final board = getBoardById(boardId);
    if (board != null) {
      board.lists.removeWhere((l) => l.id == listId);
      notifyListeners();
    }
  }

  void renameList(String boardId, String listId, String newTitle) {
    final board = getBoardById(boardId);
    if (board != null) {
      final list = board.lists.firstWhere((l) => l.id == listId);
      list.title = newTitle;
      notifyListeners();
    }
  }

  // ==================== CARD ACTIONS ====================

  void addCard(String boardId, String listId, KanbanCard card) {
    final board = getBoardById(boardId);
    if (board != null) {
      final listIndex = board.lists.indexWhere((l) => l.id == listId);
      if (listIndex != -1) {
        board.lists[listIndex].cards.add(card);
        notifyListeners();
      }
    }
  }

  void deleteCard(String boardId, String listId, String cardId) {
    final board = getBoardById(boardId);
    if (board != null) {
      final list = board.lists.firstWhere((l) => l.id == listId);
      list.cards.removeWhere((c) => c.id == cardId);
      notifyListeners();
    }
  }

  void updateCard(String boardId, String listId, KanbanCard updatedCard) {
    final board = getBoardById(boardId);
    if (board != null) {
      final list = board.lists.firstWhere((l) => l.id == listId);
      final cardIdx = list.cards.indexWhere((c) => c.id == updatedCard.id);
      if (cardIdx != -1) {
        list.cards[cardIdx] = updatedCard;
        notifyListeners();
      }
    }
  }

  void moveCard(
    String boardId,
    String fromListId,
    String toListId,
    KanbanCard card,
  ) {
    if (fromListId == toListId) return;
    final board = getBoardById(boardId);
    if (board != null) {
      final fromList = board.lists.firstWhere((l) => l.id == fromListId);
      final toList = board.lists.firstWhere((l) => l.id == toListId);

      fromList.cards.removeWhere((c) => c.id == card.id);
      toList.cards.add(card);
      notifyListeners();
    }
  }

  void toggleChecklistItem(
    String boardId,
    String listId,
    String cardId,
    String itemId,
  ) {
    final board = getBoardById(boardId);
    if (board != null) {
      final list = board.lists.firstWhere((l) => l.id == listId);
      final card = list.cards.firstWhere((c) => c.id == cardId);
      final item = card.checklist.firstWhere((i) => i.id == itemId);
      item.isDone = !item.isDone;
      notifyListeners();
    }
  }

  void addChecklistItem(
    String boardId,
    String listId,
    String cardId,
    String title,
  ) {
    if (title.trim().isEmpty) return;
    final board = getBoardById(boardId);
    if (board != null) {
      final list = board.lists.firstWhere((l) => l.id == listId);
      final card = list.cards.firstWhere((c) => c.id == cardId);
      card.checklist.add(
        ChecklistItem(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}_${card.checklist.length}',
          title: title.trim(),
        ),
      );
      notifyListeners();
    }
  }

  void deleteChecklistItem(
    String boardId,
    String listId,
    String cardId,
    String itemId,
  ) {
    final board = getBoardById(boardId);
    if (board != null) {
      final list = board.lists.firstWhere((l) => l.id == listId);
      final card = list.cards.firstWhere((c) => c.id == cardId);
      card.checklist.removeWhere((i) => i.id == itemId);
      notifyListeners();
    }
  }

  // ==================== SAMPLE DATA INITIALIZATION ====================

  void _initializeSampleData() {
    final now = DateTime.now();

    // 1. Bridal Collection Launch (Gold)
    final board1 = KanbanBoard(
      id: 'board_bridal',
      title: 'Bridal Collection Launch',
      color: NGColors.gold,
      description: 'High-jewelry bridal sets, bespoke craftsmanship, and royal launch campaign.',
      createdAt: now.subtract(const Duration(days: 14)),
      lists: [
        KanbanList(
          id: 'list_b_planning',
          title: 'Planning',
          cards: [
            KanbanCard(
              id: 'card_b_1',
              title: 'Design Concept Approval',
              description: 'Approve royal floral motifs, polki diamond accents, and 22K yellow gold choker blueprints.',
              labelColor: NGColors.emerald,
              labelText: 'Design',
              dueDate: now.add(const Duration(days: 3)),
              checklist: [
                ChecklistItem(id: 'chk_1', title: 'Select bridal heritage themes', isDone: true),
                ChecklistItem(id: 'chk_2', title: 'Finalize gemstone color palette', isDone: true),
                ChecklistItem(id: 'chk_3', title: 'Client preview signoff', isDone: false),
              ],
            ),
            KanbanCard(
              id: 'card_b_2',
              title: 'Diamond & Polki Sourcing',
              description: 'Procure VVS-1 clarity certified brilliant cut diamonds and uncut Syndicate Polki gems from Jaipur.',
              labelColor: NGColors.ruby,
              labelText: 'Procurement',
              dueDate: now.add(const Duration(days: 5)),
              checklist: [
                ChecklistItem(id: 'chk_4', title: 'Supplier quote comparison', isDone: true),
                ChecklistItem(id: 'chk_5', title: 'IGI certificate verification', isDone: true),
                ChecklistItem(id: 'chk_6', title: 'Weight & grading calibration check', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_b_progress',
          title: 'In Progress',
          cards: [
            KanbanCard(
              id: 'card_b_3',
              title: 'Master Craftsman Casting',
              description: 'Handcrafted filigree framework, laser micro-welding, and tension-prong security tests.',
              labelColor: NGColors.champagne,
              labelText: 'Workshop',
              dueDate: now.add(const Duration(days: 7)),
              checklist: [
                ChecklistItem(id: 'chk_7', title: '3D wax casting mould prep', isDone: true),
                ChecklistItem(id: 'chk_8', title: 'Laser soldering & gem setting', isDone: false),
                ChecklistItem(id: 'chk_9', title: 'Prong durability inspection', isDone: false),
              ],
            ),
            KanbanCard(
              id: 'card_b_4',
              title: 'Photoshoot & Lookbook Shoot',
              description: 'Editorial luxury shoot with high-fashion models showcasing the 5 signature bridal tiers.',
              labelColor: NGColors.rose,
              labelText: 'Marketing',
              dueDate: now.add(const Duration(days: 9)),
              checklist: [
                ChecklistItem(id: 'chk_10', title: 'Contract royal palace studio', isDone: true),
                ChecklistItem(id: 'chk_11', title: 'Style 5 bridal couture sets', isDone: false),
                ChecklistItem(id: 'chk_12', title: 'High-res color grading & retouching', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_b_qc',
          title: 'Quality Check',
          cards: [
            KanbanCard(
              id: 'card_b_5',
              title: 'BIS Hallmarking Certification',
              description: 'Mandatory Bureau of Indian Standards laser hallmarking and carat purity validation.',
              labelColor: NGColors.goldLight,
              labelText: 'Compliance',
              dueDate: now.add(const Duration(days: 12)),
              checklist: [
                ChecklistItem(id: 'chk_13', title: 'Submit samples for assay test', isDone: true),
                ChecklistItem(id: 'chk_14', title: 'HUID barcode engraving', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_b_launched',
          title: 'Launched',
          cards: [
            KanbanCard(
              id: 'card_b_6',
              title: 'VIP Gala Exhibition',
              description: 'Private preview exhibition for high net-worth patrons and bridal couture houses.',
              labelColor: NGColors.sapphire,
              labelText: 'Event',
              dueDate: now.subtract(const Duration(days: 1)),
              checklist: [
                ChecklistItem(id: 'chk_15', title: 'Send velvet embossed invites', isDone: true),
                ChecklistItem(id: 'chk_16', title: 'Curate luxury champagne lounge', isDone: true),
                ChecklistItem(id: 'chk_17', title: 'Pre-order booking register setup', isDone: true),
              ],
            ),
          ],
        ),
      ],
    );

    // 2. Digital Marketing (Rose)
    final board2 = KanbanBoard(
      id: 'board_marketing',
      title: 'Digital Marketing & Growth',
      color: NGColors.rose,
      description: 'Omnichannel luxury brand presence, viral social reels, and high-conversion PPC campaigns.',
      createdAt: now.subtract(const Duration(days: 20)),
      lists: [
        KanbanList(
          id: 'list_m_ideation',
          title: 'Ideation',
          cards: [
            KanbanCard(
              id: 'card_m_1',
              title: 'Social Media Heritage Reels',
              description: 'Macro 4K video reels capturing light refraction in Colombian emeralds and solitaire cuts.',
              labelColor: NGColors.rose,
              labelText: 'Social',
              dueDate: now.add(const Duration(days: 2)),
              checklist: [
                ChecklistItem(id: 'chk_m1', title: 'Script 6 macro lighting concepts', isDone: true),
                ChecklistItem(id: 'chk_m2', title: 'Record voiceover narration', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_m_production',
          title: 'In Production',
          cards: [
            KanbanCard(
              id: 'card_m_2',
              title: 'Influencer Styling Partnerships',
              description: 'Collabs with top bridal fashion influencers for exclusive red-carpet unboxing stories.',
              labelColor: NGColors.platinum,
              labelText: 'Influencer',
              dueDate: now.add(const Duration(days: 6)),
              checklist: [
                ChecklistItem(id: 'chk_m3', title: 'Select 8 luxury lifestyle creators', isDone: true),
                ChecklistItem(id: 'chk_m4', title: 'Dispatch custom velvet gift boxes', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_m_live',
          title: 'Live Campaigns',
          cards: [
            KanbanCard(
              id: 'card_m_3',
              title: 'Google Shopping Solitaire Ads',
              description: 'Targeted search campaigns for certified engagement rings and custom wedding bands.',
              labelColor: NGColors.sapphire,
              labelText: 'PPC',
              dueDate: now.add(const Duration(days: 10)),
              checklist: [
                ChecklistItem(id: 'chk_m5', title: 'Negative keywords audit', isDone: true),
                ChecklistItem(id: 'chk_m6', title: 'A/B test ad copy variations', isDone: true),
                ChecklistItem(id: 'chk_m7', title: 'Daily ROAS target monitoring', isDone: true),
              ],
            ),
          ],
        ),
      ],
    );

    // 3. Store Operations (Graphite)
    final board3 = KanbanBoard(
      id: 'board_operations',
      title: 'Store Operations & Security',
      color: NGColors.graphite,
      description: 'Boutique flagship management, staff luxury training, and vault security compliance.',
      createdAt: now.subtract(const Duration(days: 30)),
      lists: [
        KanbanList(
          id: 'list_o_todo',
          title: 'To Do',
          cards: [
            KanbanCard(
              id: 'card_o_1',
              title: 'POS & RFID Scanner Upgrade',
              description: 'Install ultra-fast RFID diamond tray readers for real-time inventory counter reconciliation.',
              labelColor: NGColors.platinum,
              labelText: 'Tech',
              dueDate: now.add(const Duration(days: 4)),
              checklist: [
                ChecklistItem(id: 'chk_o1', title: 'Hardware scanner installation', isDone: false),
                ChecklistItem(id: 'chk_o2', title: 'Cloud POS data synchronization', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_o_execution',
          title: 'In Execution',
          cards: [
            KanbanCard(
              id: 'card_o_2',
              title: 'Staff Diamond 4C Certification',
              description: 'Masterclass on Cut, Color, Clarity, and Carat grading to elevate client consultation.',
              labelColor: NGColors.amber,
              labelText: 'Training',
              dueDate: now.add(const Duration(days: 1)),
              checklist: [
                ChecklistItem(id: 'chk_o3', title: 'Distribute GIA study guides', isDone: true),
                ChecklistItem(id: 'chk_o4', title: 'Conduct live loupe inspection drill', isDone: true),
                ChecklistItem(id: 'chk_o5', title: 'Final oral evaluation', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_o_audited',
          title: 'Audited & Completed',
          cards: [
            KanbanCard(
              id: 'card_o_3',
              title: 'Annual Vault Biometric Audit',
              description: 'Complete inspection of double-key security vaults, surveillance logs, and transit lockers.',
              labelColor: NGColors.ruby,
              labelText: 'Security',
              dueDate: now.subtract(const Duration(days: 3)),
              checklist: [
                ChecklistItem(id: 'chk_o6', title: 'Biometric firmware update', isDone: true),
                ChecklistItem(id: 'chk_o7', title: 'CCTV 90-day archive validation', isDone: true),
                ChecklistItem(id: 'chk_o8', title: 'Underwriter compliance signoff', isDone: true),
              ],
            ),
          ],
        ),
      ],
    );

    // 4. Design Studio (Bronze)
    final board4 = KanbanBoard(
      id: 'board_studio',
      title: 'Bespoke Design Studio',
      color: NGColors.bronze,
      description: 'Exclusive custom client commissions, CAD 3D modeling, and artisanal polki choker settings.',
      createdAt: now.subtract(const Duration(days: 10)),
      lists: [
        KanbanList(
          id: 'list_d_backlog',
          title: 'Backlog',
          cards: [
            KanbanCard(
              id: 'card_d_1',
              title: 'Royal Kundan Choker Commission',
              description: 'Multi-strand choker crafted with uncut Colombian emerald drops and meenakari back-enameling.',
              labelColor: NGColors.gold,
              labelText: 'Bespoke',
              dueDate: now.add(const Duration(days: 14)),
              checklist: [
                ChecklistItem(id: 'chk_d1', title: 'Initial client sketch alignment', isDone: true),
                ChecklistItem(id: 'chk_d2', title: 'Meenakari color test on silver', isDone: false),
              ],
            ),
          ],
        ),
        KanbanList(
          id: 'list_d_cad',
          title: '3D CAD & Render',
          cards: [
            KanbanCard(
              id: 'card_d_2',
              title: 'Tension-Set Solitaire Ring',
              description: 'Modern minimalist diamond ring engineered with structural titanium inner reinforcement.',
              labelColor: NGColors.emerald,
              labelText: 'Innovation',
              dueDate: now.add(const Duration(days: 8)),
              checklist: [
                ChecklistItem(id: 'chk_d3', title: 'Finite element stress simulation', isDone: true),
                ChecklistItem(id: 'chk_d4', title: 'Print 1:1 resin casting prototype', isDone: false),
              ],
            ),
          ],
        ),
      ],
    );

    _boards.addAll([board1, board2, board3, board4]);
  }

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}

/// InheritedNotifier for AppState
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);
}
