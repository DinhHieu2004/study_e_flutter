import 'package:flutter/material.dart';

class UnlockedFlashcardTile extends StatelessWidget {
  final String word;
  final String? phonetic;
  final String? imageUrl;
  final bool large;

  const UnlockedFlashcardTile({
    super.key,
    required this.word,
    this.phonetic,
    this.imageUrl,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final double borderRadius = large ? 22 : 18;
    final double padding = large ? 20 : 12;
    final double titleSize = large ? 22 : 16;
    final double phoneticSize = large ? 16 : 13;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: large
            ? const [
                BoxShadow(
                  blurRadius: 18,
                  color: Colors.black26,
                  offset: Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius),
                    ),
                    child: Image.network(imageUrl!, fit: BoxFit.contain),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(borderRadius),
                      ),
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
          ),

          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (phonetic != null && phonetic!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      phonetic!,
                      style: TextStyle(
                        fontSize: phoneticSize,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
