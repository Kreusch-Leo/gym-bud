import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/equipment_checklist.dart';
import '../../data/repositories.dart';
import '../../providers.dart';
import '../../services/location_service.dart';

class GymsScreen extends ConsumerWidget {
  const GymsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gyms = ref.watch(gymsProvider);
    void edit([GymInfo? info]) => Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => GymEditScreen(existing: info)));

    return Scaffold(
      appBar: AppBar(title: const Text('Academias e locais')),
      body: gyms.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar locais: $e')),
        data: (list) => list.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Cadastre onde você treina e marque os equipamentos disponíveis. '
                    'Sem um local, as sugestões usam só peso corporal.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  for (final info in list)
                    ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(info.gym.name),
                      subtitle: Text(
                        '${info.equipmentIds.length} equipamentos · '
                        '${info.gym.latitude == null ? 'sem GPS' : 'raio de ${info.gym.radiusM.round()} m'}',
                      ),
                      onTap: () => edit(info),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo local',
        onPressed: edit,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GymEditScreen extends ConsumerStatefulWidget {
  const GymEditScreen({super.key, this.existing});

  final GymInfo? existing;

  @override
  ConsumerState<GymEditScreen> createState() => _GymEditScreenState();
}

class _GymEditScreenState extends ConsumerState<GymEditScreen> {
  late final _name = TextEditingController(text: widget.existing?.gym.name);
  late final _lat = TextEditingController(
    text: widget.existing?.gym.latitude?.toString(),
  );
  late final _lng = TextEditingController(
    text: widget.existing?.gym.longitude?.toString(),
  );
  late final _radius = TextEditingController(
    text: (widget.existing?.gym.radiusM ?? 100).round().toString(),
  );
  late Set<int> _equipment = {...?widget.existing?.equipmentIds};
  bool _locating = false;

  @override
  void dispose() {
    for (final c in [_name, _lat, _lng, _radius]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parse(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _useCurrentPosition() async {
    setState(() => _locating = true);
    final position = await currentPosition();
    if (!mounted) return;
    setState(() => _locating = false);
    if (position == null) {
      return _message(
        'Não foi possível obter a localização. Verifique o GPS e a permissão.',
      );
    }
    _lat.text = position.lat.toStringAsFixed(6);
    _lng.text = position.lng.toStringAsFixed(6);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final lat = _parse(_lat), lng = _parse(_lng), radius = _parse(_radius);
    if (name.isEmpty) return _message('Informe o nome do local.');
    final hasCoordinates =
        _lat.text.trim().isNotEmpty || _lng.text.trim().isNotEmpty;
    if (hasCoordinates &&
        (lat == null || lng == null || lat.abs() > 90 || lng.abs() > 180)) {
      return _message(
        'Coordenadas inválidas (latitude −90 a 90, longitude −180 a 180).',
      );
    }
    if (radius == null || radius <= 0) {
      return _message('Informe um raio maior que zero.');
    }
    try {
      await ref
          .read(gymRepoProvider)
          .saveGym(
            id: widget.existing?.gym.id,
            name: name,
            latitude: lat,
            longitude: lng,
            radiusM: radius,
            equipmentIds: _equipment,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      _message('Já existe um local com esse nome.');
    }
  }

  Future<void> _delete() async {
    final id = widget.existing!.gym.id;
    await ref.read(gymRepoProvider).deleteGym(id);
    if (ref.read(locationProvider).gymId == id) {
      ref.read(locationProvider.notifier).selectManually(null);
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder();
    const decimal = TextInputType.numberWithOptions(
      decimal: true,
      signed: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Novo local' : 'Editar local'),
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
                    border: border,
                  ),
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _lat,
                        keyboardType: decimal,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: border,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _lng,
                        keyboardType: decimal,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: border,
                        ),
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  icon: _locating
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Usar minha localização atual'),
                  onPressed: _locating ? null : _useCurrentPosition,
                ),
                TextField(
                  controller: _radius,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Raio de tolerância (metros)',
                    border: border,
                  ),
                ),
                const Text('Equipamentos disponíveis'),
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
