
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ShiftMateApp());
}

class ShiftMateApp extends StatelessWidget {
  const ShiftMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShiftMate Business',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16845B),
        ),
      ),
      home: const BusinessDashboard(),
    );
  }
}

// Model representing one shift
class Shift {
  final String title;
  final String location;
  final String time;
  final String pay;
  final String status;

  const Shift({
    required this.title,
    required this.location,
    required this.time,
    required this.pay,
    this.status = 'Finding workers',
  });
}

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() =>
      _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  // Temporary sample shifts
  final List<Shift> _shifts = [
    const Shift(
      title: 'Restaurant Waiter',
      location: 'Jaipur, Rajasthan',
      time: '10:00 AM - 6:00 PM',
      pay: '₹800 / shift',
      status: 'Active',
    ),
    const Shift(
      title: 'Event Helper',
      location: 'Jaipur, Rajasthan',
      time: '4:00 PM - 10:00 PM',
      pay: '₹600 / shift',
    ),
  ];

  // Open the form and receive the newly created shift
  Future<void> _openPostShiftPage() async {
    final newShift = await Navigator.push<Shift>(
      context,
      MaterialPageRoute(
        builder: (context) => const PostShiftPage(),
      ),
    );

    if (!mounted) return;

    if (newShift != null) {
      setState(() {
        _shifts.insert(0, newShift);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New shift added successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.work_outline, color: Color(0xFF16845B)),
            SizedBox(width: 8),
            Text(
              'ShiftMate',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon!'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business Dashboard',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18352A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage your shifts and temporary workforce.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openPostShiftPage,
                  icon: const Icon(Icons.add),
                  label: const Text('Post a New Shift'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16845B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SummaryCard(
                    title: 'Total Shifts',
                    value: '${_shifts.length}',
                    icon: Icons.work_history_outlined,
                    color: const Color(0xFF16845B),
                  ),
                  const SummaryCard(
                    title: 'Workers',
                    value: '12',
                    icon: Icons.people_outline,
                    color: Color(0xFF2879C7),
                  ),
                  const SummaryCard(
                    title: 'Pending',
                    value: '03',
                    icon: Icons.pending_actions,
                    color: Color(0xFFE49A22),
                  ),
                  const SummaryCard(
                    title: 'Completed',
                    value: '18',
                    icon: Icons.task_alt,
                    color: Color(0xFF7954B5),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Shifts',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_shifts.length} shifts',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_shifts.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No shifts yet. Post your first shift!',
                    ),
                  ),
                )
              else
                ..._shifts.map(
                  (shift) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ShiftCard(shift: shift),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE8EEEA)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShiftCard extends StatelessWidget {
  final Shift shift;

  const ShiftCard({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE8EEEA)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE5F4EC),
                  child: Icon(
                    Icons.work_outline,
                    color: Color(0xFF16845B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    shift.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            InfoRow(
              icon: Icons.location_on_outlined,
              text: shift.location,
            ),
            const SizedBox(height: 8),
            InfoRow(
              icon: Icons.access_time,
              text: shift.time,
            ),
            const SizedBox(height: 8),
            InfoRow(
              icon: Icons.currency_rupee,
              text: shift.pay,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F4EC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                shift.status,
                style: const TextStyle(
                  color: Color(0xFF16845B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class PostShiftPage extends StatefulWidget {
  const PostShiftPage({super.key});

  @override
  State<PostShiftPage> createState() => _PostShiftPageState();
}

class _PostShiftPageState extends State<PostShiftPage> {
  final _formKey = GlobalKey<FormState>();
  final _roleController = TextEditingController();
  final _locationController = TextEditingController();
  final _payController = TextEditingController();

  String _shiftTime = '9:00 AM - 5:00 PM';

  @override
  void dispose() {
    _roleController.dispose();
    _locationController.dispose();
    _payController.dispose();
    super.dispose();
  }

  void _submitShift() {
    if (!_formKey.currentState!.validate()) return;

    final newShift = Shift(
      title: _roleController.text.trim(),
      location: _locationController.text.trim(),
      time: _shiftTime,
      pay: '₹${_payController.text.trim()} / shift',
    );

    // Return the new shift to the dashboard
    Navigator.pop(context, newShift);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post a New Shift')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shift Details',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the details to find temporary workers.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Job role',
                  hintText: 'e.g. Restaurant Waiter',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a job role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Work location',
                  hintText: 'e.g. Jaipur',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                value: _shiftTime,
                decoration: const InputDecoration(
                  labelText: 'Shift timing',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: '9:00 AM - 5:00 PM',
                    child: Text('9:00 AM - 5:00 PM'),
                  ),
                  DropdownMenuItem(
                    value: '10:00 AM - 6:00 PM',
                    child: Text('10:00 AM - 6:00 PM'),
                  ),
                  DropdownMenuItem(
                    value: '4:00 PM - 10:00 PM',
                    child: Text('4:00 PM - 10:00 PM'),
                  ),
                  DropdownMenuItem(
                    value: '6:00 PM - 12:00 AM',
                    child: Text('6:00 PM - 12:00 AM'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _shiftTime = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 18),

              TextFormField(
                controller: _payController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Payment per shift (₹)',
                  hintText: 'e.g. 800',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final amount = int.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid payment amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitShift,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16845B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit Shift'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

