import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/data.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(AppData.chatMessages);
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _hexColor(String hex) => Color(int.parse('FF$hex', radix: 16));

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        initials: 'Я',
        text: text,
        time: '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
        isMe: true,
      ));
      _msgController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💬  Сообщество'),
            Text('248 участниц онлайн',
                style: GoogleFonts.rubik(fontSize: 11, color: Colors.white60)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.people_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Pinned announcement
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.greenCard,
            child: Row(
              children: [
                const Icon(Icons.push_pin_rounded, size: 16, color: AppColors.greenMid),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '📌 Завтра в 19:00 — прямой эфир с куратором!',
                    style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: AppColors.greenDark,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                return msg.isMe
                    ? _MyMessage(msg: msg)
                    : _OtherMessage(msg: msg, hexColor: _hexColor);
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.greenBorder, width: 0.5)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.greenSurface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.greenBorder, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _msgController,
                              style: GoogleFonts.rubik(fontSize: 14, color: AppColors.textDark),
                              decoration: InputDecoration(
                                hintText: 'Написать...',
                                hintStyle: GoogleFonts.rubik(
                                    fontSize: 14, color: AppColors.textMuted),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              maxLines: null,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.attach_file_rounded,
                                color: AppColors.textMuted, size: 20),
                            padding: const EdgeInsets.all(8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.greenMid,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: AppColors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherMessage extends StatelessWidget {
  final ChatMessage msg;
  final Color Function(String) hexColor;

  const _OtherMessage({required this.msg, required this.hexColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: hexColor(msg.avatarColor),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(msg.initials,
                  style: GoogleFonts.rubik(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.greenDark)),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(msg.text,
                      style: GoogleFonts.rubik(fontSize: 14, color: AppColors.textDark, height: 1.4)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4),
                  child: Text(msg.time,
                      style: GoogleFonts.rubik(fontSize: 10, color: AppColors.textMuted)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyMessage extends StatelessWidget {
  final ChatMessage msg;
  const _MyMessage({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.greenMid,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(msg.text,
                      style: GoogleFonts.rubik(
                          fontSize: 14, color: AppColors.white, height: 1.4)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, right: 4),
                  child: Text(msg.time,
                      style: GoogleFonts.rubik(fontSize: 10, color: AppColors.textMuted)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
