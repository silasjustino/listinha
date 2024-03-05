import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:listinha/src/shared/stores/app_store.dart';
import 'package:listinha/src/shared/widgets/user_image_button.dart';
import 'package:rx_notifier/rx_notifier.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final appStore = context.read<AppStore>();

    final syncDate = context.select(() => appStore.syncDate.value);

    var syncDateText = 'DataTime';

    if (syncDate != null) {
      final format = DateFormat('HH:mm - dd/MM/yyyy');
      syncDateText = format.format(syncDate);
    }

    return NavigationDrawer(
      onDestinationSelected: (index) {
        if (index == 0) {
          appStore.syncDate.value = DateTime.now();
        } else if (index == 1) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/config');
        }
      },
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              UserImageButton(),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Silas Justino',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('silasjustino@gmail.com'),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding:
              const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 15),
          child: Text(
            'Opções',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.sync),
          label: SizedBox(
            width: 210,
            child: Row(
              children: [
                const Text('Sincronizar'),
                const Spacer(),
                Text(
                  syncDateText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.settings),
          label: Text('Configurações'),
        ),
      ],
    );
  }
}
