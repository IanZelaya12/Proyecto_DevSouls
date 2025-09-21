import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../data/services/availability_service.dart';

class CalendarPage extends StatefulWidget {
  final String canchaId;
  final String usuarioId;
  const CalendarPage({
    super.key,
    required this.canchaId,
    required this.usuarioId,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _availability = AvailabilityService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedSlot;
  List<String> _slots = const [];

  Future<void> _loadSlots() async {
    if (_selectedDay == null) return;
    final slots = await _availability.fetchSlots(
      canchaId: widget.canchaId,
      fecha: _selectedDay!,
    );
    setState(() => _slots = slots);
  }

  Future<void> _confirmar() async {
    if (_selectedDay == null || _selectedSlot == null) return;
    final ok = await _availability.reservar(
      canchaId: widget.canchaId,
      fecha: _selectedDay!,
      hora: _selectedSlot!,
      usuarioId: widget.usuarioId,
    );
    final msg = ok
        ? 'Reserva confirmada: ${_selectedDay!.toLocal().toString().split(' ').first} a las $_selectedSlot'
        : 'No se pudo reservar. Intente de nuevo.';
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de reserva')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 1)),
              lastDay: DateTime.now().add(const Duration(days: 60)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
              calendarFormat: CalendarFormat.twoWeeks,
              onDaySelected: (sel, foc) async {
                setState(() {
                  _selectedDay = sel;
                  _focusedDay = foc;
                  _selectedSlot = null;
                  _slots = const [];
                });
                await _loadSlots();
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Text(
                  'Horarios:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _slots.map((s) {
                  final selected = _selectedSlot == s;
                  return ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: _selectedDay == null
                        ? null
                        : (_) => setState(() => _selectedSlot = s),
                  );
                }).toList(),
              ),
            ),
            FilledButton.icon(
              onPressed: (_selectedDay != null && _selectedSlot != null)
                  ? _confirmar
                  : null,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar (demo)'),
            ),
          ],
        ),
      ),
    );
  }
}
