import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// Check-list de equipamentos granulares, com campo para cadastrar um novo.
/// Não rola sozinha: deve ficar dentro de uma lista rolável.
class EquipmentChecklist extends ConsumerStatefulWidget {
  const EquipmentChecklist({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  ConsumerState<EquipmentChecklist> createState() => _EquipmentChecklistState();
}

class _EquipmentChecklistState extends ConsumerState<EquipmentChecklist> {
  final _newName = TextEditingController();

  @override
  void dispose() {
    _newName.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _newName.text.trim();
    if (name.isEmpty) return;
    final id = await ref.read(catalogProvider).ensureEquipment(name);
    _newName.clear();
    widget.onChanged({...widget.selected, id});
  }

  @override
  Widget build(BuildContext context) {
    final equipment = ref.watch(equipmentProvider).value ?? const [];
    return Column(
      children: [
        for (final e in equipment)
          CheckboxListTile(
            dense: true,
            title: Text(e.name),
            value: widget.selected.contains(e.id),
            onChanged: (on) => widget.onChanged(
              on == true
                  ? {...widget.selected, e.id}
                  : ({...widget.selected}..remove(e.id)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _newName,
            decoration: InputDecoration(
              labelText: 'Novo equipamento (ex.: Halteres até 40kg)',
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Cadastrar',
                onPressed: _add,
              ),
            ),
            onSubmitted: (_) => _add(),
          ),
        ),
      ],
    );
  }
}
