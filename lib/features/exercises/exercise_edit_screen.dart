import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/equipment_checklist.dart';
import '../../core/muscle_group.dart';
import '../../core/tracking_mode.dart';
import '../../data/repositories.dart';
import '../../providers.dart';

class ExerciseEditScreen extends ConsumerStatefulWidget {
  const ExerciseEditScreen({super.key, this.existing});

  final ExerciseInfo? existing;

  @override
  ConsumerState<ExerciseEditScreen> createState() => _ExerciseEditScreenState();
}

class _ExerciseEditScreenState extends ConsumerState<ExerciseEditScreen> {
  late final _name = TextEditingController(
    text: widget.existing?.exercise.name,
  );
  late MuscleGroup _primary =
      widget.existing?.exercise.primaryMuscle ?? MuscleGroup.peito;
  late final Set<MuscleGroup> _secondary = {
    ...?widget.existing?.exercise.secondaryMuscles,
  };
  late Set<int> _equipment = {...?widget.existing?.equipmentIds};
  late String? _mediaPath = widget.existing?.exercise.mediaPath;
  late TrackingMode _mode =
      widget.existing?.exercise.trackingMode ?? TrackingMode.reps;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// Copia o GIF/imagem escolhido para a pasta do app, para não depender do original.
  Future<void> _pickMedia() async {
    final picked = await FilePicker.pickFiles(type: FileType.image);
    final source = picked.firstOrNull?.path;
    if (source == null) return;
    final dir = Directory(
      p.join((await getApplicationDocumentsDirectory()).path, 'media'),
    );
    await dir.create(recursive: true);
    final target = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}${p.extension(source)}',
    );
    await File(source).copy(target);
    setState(() => _mediaPath = target);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return _message('Informe o nome do exercício.');
    try {
      await ref
          .read(catalogProvider)
          .saveExercise(
            id: widget.existing?.exercise.id,
            name: name,
            primary: _primary,
            secondary: (_secondary..remove(_primary)).toList(),
            equipmentIds: _equipment,
            mediaPath: _mediaPath,
            trackingMode: _mode,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      _message('Já existe um exercício com esse nome.');
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir exercício?'),
        content: const Text(
          'As séries deste exercício também saem do histórico.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(catalogProvider)
        .deleteExercise(widget.existing!.exercise.id);
    if (mounted) Navigator.of(context).pop();
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final media = _mediaPath;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing == null ? 'Novo exercício' : 'Editar exercício',
        ),
        actions: [
          if (widget.existing != null)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Excluir',
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          if (media != null && File(media).existsSync())
            Image.file(File(media), height: 200, fit: BoxFit.contain),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                DropdownButtonFormField<MuscleGroup>(
                  initialValue: _primary,
                  decoration: const InputDecoration(
                    labelText: 'Grupo muscular principal',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final g in MuscleGroup.values)
                      DropdownMenuItem(value: g, child: Text(g.label)),
                  ],
                  onChanged: (g) => setState(() => _primary = g!),
                ),
                const Text(
                  'Modo padrão no treino (pode ser trocado durante a execução)',
                ),
                SegmentedButton<TrackingMode>(
                  segments: [
                    for (final m in TrackingMode.values)
                      ButtonSegment(value: m, label: Text(m.label)),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (s) => setState(() => _mode = s.single),
                ),
                const Text('Grupos secundários'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final g in MuscleGroup.values)
                      if (g != _primary)
                        FilterChip(
                          label: Text(g.label),
                          selected: _secondary.contains(g),
                          onSelected: (on) => setState(
                            () => on ? _secondary.add(g) : _secondary.remove(g),
                          ),
                        ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.gif_box),
                      label: Text(
                        media == null
                            ? 'Adicionar GIF/imagem'
                            : 'Trocar GIF/imagem',
                      ),
                      onPressed: _pickMedia,
                    ),
                    if (media != null)
                      TextButton(
                        onPressed: () => setState(() => _mediaPath = null),
                        child: const Text('Remover'),
                      ),
                  ],
                ),
                const Text('Equipamentos necessários (todos são obrigatórios)'),
              ],
            ),
          ),
          EquipmentChecklist(
            selected: _equipment,
            onChanged: (s) => setState(() => _equipment = s),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.check),
        label: const Text('Salvar'),
        onPressed: _save,
      ),
    );
  }
}
