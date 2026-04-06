import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/data.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  late List<ShopItem> _items;

  @override
  void initState() {
    super.initState();
    _items = AppData.shopItems.map((e) => ShopItem(
      name: e.name,
      quantity: e.quantity,
      category: e.category,
      isChecked: e.isChecked,
    )).toList();
  }

  List<String> get _categories {
    final cats = <String>[];
    for (final item in _items) {
      if (!cats.contains(item.category)) cats.add(item.category);
    }
    return cats;
  }

  int get _checkedCount => _items.where((e) => e.isChecked).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('🛒  Список покупок'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _shareList(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress banner
          Container(
            color: AppColors.greenMid,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Неделя 2 · ${_items.length} продуктов',
                        style: GoogleFonts.rubik(fontSize: 13, color: Colors.white70)),
                    Text('$_checkedCount из ${_items.length}',
                        style: GoogleFonts.rubik(
                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.white)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _checkedCount / _items.length,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(AppColors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ..._categories.map((cat) {
                  final catItems = _items.where((i) => i.category == cat).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(cat,
                            style: GoogleFonts.rubik(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                                letterSpacing: 0.08)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.greenBorder, width: 0.5),
                        ),
                        child: Column(
                          children: catItems.map((item) {
                            final idx = _items.indexOf(item);
                            return _ShopItemTile(
                              item: item,
                              onToggle: () => setState(() => _items[idx].isChecked = !_items[idx].isChecked),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                }),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _shareList(context),
                  icon: const Text('✈️'),
                  label: const Text('Отправить в Telegram'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    for (final i in _items) i.isChecked = false;
                  }),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Сбросить отметки'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.greenMid,
                    side: const BorderSide(color: AppColors.greenBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Список отправлен в Telegram 📤',
            style: GoogleFonts.rubik(fontSize: 13)),
        backgroundColor: AppColors.greenMid,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ShopItemTile extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onToggle;

  const _ShopItemTile({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: item == AppData.shopItems.last ? Colors.transparent : AppColors.greenSurface,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.isChecked ? AppColors.greenMid : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isChecked ? AppColors.greenMid : AppColors.greenAccent,
                  width: 1.5,
                ),
              ),
              child: item.isChecked
                  ? const Icon(Icons.check_rounded, color: AppColors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: item.isChecked ? AppColors.textMuted : AppColors.textDark,
                  decoration: item.isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Text(
              item.quantity,
              style: GoogleFonts.rubik(
                fontSize: 13,
                color: item.isChecked ? AppColors.textMuted : AppColors.greenAccent,
                fontWeight: item.isChecked ? FontWeight.w400 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
