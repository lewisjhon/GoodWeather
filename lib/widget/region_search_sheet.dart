import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/helper/app_theme.dart';
import 'package:weather/helper/regions.dart';
import 'package:weather/model/region.dart';

/// 지역 검색 + 추가된 지역 관리 모달.
/// 검색 결과를 탭하면 추가하고 시트를 닫는다. 추가된 지역은 X 로 삭제한다.
class RegionSearchSheet extends StatefulWidget {
  final List<Region> saved;
  final void Function(Region) onAdd;
  final void Function(Region) onRemove;

  const RegionSearchSheet({
    required this.saved,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  @override
  State<RegionSearchSheet> createState() => _RegionSearchSheetState();
}

class _RegionSearchSheetState extends State<RegionSearchSheet> {
  String _query = '';
  late List<Region> _saved;

  @override
  void initState() {
    super.initState();
    _saved = [...widget.saved];
  }

  bool _alreadySaved(Region r) => _saved.any((s) => s.key == r.key);

  @override
  Widget build(BuildContext context) {
    final results = searchRegions(_query).where((r) => !_alreadySaved(r)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F2FB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kTextSecondary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              CupertinoSearchTextField(
                placeholder: '지역 검색 (예: 부산)',
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    if (_saved.isNotEmpty) ...[
                      _sectionLabel('내가 추가한 지역'),
                      for (final r in _saved) _savedTile(r),
                      const SizedBox(height: 18),
                    ],
                    _sectionLabel('지역 추가'),
                    for (final r in results) _addTile(r),
                    if (results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text('검색 결과가 없어요',
                              style: TextStyle(color: kTextSecondary)),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: kTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _addTile(Region r) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onAdd(r);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0x1A000000))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(r.name,
                  style: const TextStyle(fontSize: 16, color: kTextPrimary)),
            ),
            const Icon(CupertinoIcons.add_circled,
                color: kTextSecondary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _savedTile(Region r) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1A000000))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(r.name,
                style: const TextStyle(fontSize: 16, color: kTextPrimary)),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.onRemove(r);
              setState(() {
                _saved = _saved.where((s) => s.key != r.key).toList();
              });
            },
            child: const Icon(CupertinoIcons.minus_circled,
                color: Color(0xFFD98A8A), size: 22),
          ),
        ],
      ),
    );
  }
}
