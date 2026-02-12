import 'package:Al_Zab_township_guide/Helper/Constant/Constant.dart';
import 'package:Al_Zab_township_guide/Helper/Service/service.dart';
import 'package:Al_Zab_township_guide/Services/cloudflare_api.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'DialogCirculerProgress.dart';

class ManageListingDialog {
  static Future<void> showEditDialog({
    required BuildContext context,
    required String collection,
    required Map<String, dynamic> item,
    required Future<void> Function() onCompleted,
  }) async {
    final id = (item['id'] ?? '').toString();
    if (id.isEmpty) {
      await showSnakeBar(context, 'تعذر تعديل هذا العنصر');
      return;
    }

    // السماح بالتعديل فقط للإيميل أو الرقم المطلوب
    final emailUser = shared?.getString('emailUser') ?? '';
    final phoneUser = shared?.getString('phoneUser') ?? '';
    if (!(emailUser == 'amhmeed31@gmail.com' || phoneUser == '07824854526')) {
      await showSnakeBar(
        context,
        'ليس لديك صلاحية التعديل. فقط الأدمن يمكنه التعديل.',
      );
      return;
    }

    final type = _collectionType(collection);
    if (type == null) {
      await showSnakeBar(context, 'نوع الخدمة غير مدعوم للتعديل');
      return;
    }

    final nameController = TextEditingController(
      text: (item['name'] ?? '').toString(),
    );
    final numberController = TextEditingController(
      text: (item['number'] ?? '').toString(),
    );
    final locationController = TextEditingController(
      text: (item['location'] ?? '').toString(),
    );
    final specializationController = TextEditingController(
      text: (item['specialization'] ?? '').toString(),
    );
    final presenceController = TextEditingController(
      text: (item['presence'] ?? '').toString(),
    );
    final titleController = TextEditingController(
      text: (item['title'] ?? '').toString(),
    );
    final vehicleTypeController = TextEditingController(
      text: (item['type'] ?? '').toString(),
    );
    final timeController = TextEditingController(
      text: (item['time'] ?? '').toString(),
    );
    final routeFromController = TextEditingController(
      text: (item['from'] ?? '').toString(),
    );
    final professionController = TextEditingController(
      text: (item['nameProfession'] ?? '').toString(),
    );

    final fields = _buildFields(
      context,
      type,
      nameController,
      numberController,
      locationController,
      specializationController,
      presenceController,
      titleController,
      vehicleTypeController,
      timeController,
      routeFromController,
      professionController,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).edit_Data_and_delete),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: fields),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                for (final controller in _controllersForType(
                  type,
                  nameController,
                  numberController,
                  locationController,
                  specializationController,
                  presenceController,
                  titleController,
                  vehicleTypeController,
                  timeController,
                  routeFromController,
                  professionController,
                )) {
                  if (controller.text.trim().isEmpty) {
                    await showSnakeBar(context, S.of(context).fields);
                    return;
                  }
                }

                Navigator.pop(dialogContext);
                showCirculerProgress(context);
                try {
                  final payload = _buildPayload(
                    type,
                    collection,
                    nameController.text.trim(),
                    numberController.text.trim(),
                    locationController.text.trim(),
                    specializationController.text.trim(),
                    presenceController.text.trim(),
                    titleController.text.trim(),
                    vehicleTypeController.text.trim(),
                    timeController.text.trim(),
                    routeFromController.text.trim(),
                    professionController.text.trim(),
                  );
                  await CloudflareApi.instance.updateItem(type, id, payload);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  await onCompleted();
                  if (context.mounted) {
                    await showSnakeBar(context, S.of(context).done);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    await showSnakeBar(context, e.toString());
                  }
                }
              },
              child: Text(S.of(context).confirm),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showDeleteDialog({
    required BuildContext context,
    required String collection,
    required Map<String, dynamic> item,
    required Future<void> Function() onCompleted,
  }) async {
    final id = (item['id'] ?? '').toString();
    if (id.isEmpty) {
      await showSnakeBar(context, 'تعذر حذف هذا العنصر');
      return;
    }

    final type = _collectionType(collection);
    if (type == null) {
      await showSnakeBar(context, 'نوع الخدمة غير مدعوم للحذف');
      return;
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).delete_account),
          content: Text('سيتم حذف هذا العنصر نهائياً. هل تريد المتابعة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                showCirculerProgress(context);
                try {
                  await CloudflareApi.instance.deleteItem(type, id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  await onCompleted();
                  if (context.mounted) {
                    await showSnakeBar(context, S.of(context).done);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    await showSnakeBar(context, e.toString());
                  }
                }
              },
              child: Text(S.of(context).confirm),
            ),
          ],
        );
      },
    );
  }

  static String? _collectionType(String collection) {
    if (collection == 'Doctor') {
      return 'doctor';
    }
    if (collection == 'professions') {
      return 'profession';
    }
    if (collection == 'line') {
      return 'car';
    }
    if (collection == 'Satota') {
      return 'satota';
    }
    if (collection == Constant.A_Plus ||
        collection == Constant.A_Minus ||
        collection == Constant.B_Plus ||
        collection == Constant.B_Minus ||
        collection == Constant.O_Plus ||
        collection == Constant.O_Minus ||
        collection == Constant.AB_Plus ||
        collection == Constant.AB_Minus) {
      return 'donor';
    }
    return null;
  }

  static List<Widget> _buildFields(
    BuildContext context,
    String type,
    TextEditingController nameController,
    TextEditingController numberController,
    TextEditingController locationController,
    TextEditingController specializationController,
    TextEditingController presenceController,
    TextEditingController titleController,
    TextEditingController vehicleTypeController,
    TextEditingController timeController,
    TextEditingController routeFromController,
    TextEditingController professionController,
  ) {
    final fields = <Widget>[
      _field(nameController, S.of(context).name),
      _field(numberController, S.of(context).number_phone),
    ];

    if (type == 'donor' || type == 'satota') {
      fields.add(_field(locationController, S.of(context).title_service));
    }

    if (type == 'doctor') {
      fields.add(
        _field(specializationController, S.of(context).specialization),
      );
      fields.add(_field(presenceController, S.of(context).time));
      fields.add(_field(titleController, S.of(context).title_service));
    }

    if (type == 'car') {
      fields.add(_field(vehicleTypeController, S.of(context).type));
      fields.add(_field(timeController, S.of(context).time));
      fields.add(_field(routeFromController, S.of(context).from));
    }

    if (type == 'profession') {
      fields.add(_field(professionController, S.of(context).profession));
    }

    return fields;
  }

  static List<TextEditingController> _controllersForType(
    String type,
    TextEditingController nameController,
    TextEditingController numberController,
    TextEditingController locationController,
    TextEditingController specializationController,
    TextEditingController presenceController,
    TextEditingController titleController,
    TextEditingController vehicleTypeController,
    TextEditingController timeController,
    TextEditingController routeFromController,
    TextEditingController professionController,
  ) {
    final list = <TextEditingController>[nameController, numberController];

    if (type == 'donor' || type == 'satota') {
      list.add(locationController);
    }
    if (type == 'doctor') {
      list.addAll([
        specializationController,
        presenceController,
        titleController,
      ]);
    }
    if (type == 'car') {
      list.addAll([vehicleTypeController, timeController, routeFromController]);
    }
    if (type == 'profession') {
      list.add(professionController);
    }

    return list;
  }

  static Map<String, dynamic> _buildPayload(
    String type,
    String collection,
    String name,
    String phone,
    String location,
    String specialization,
    String presence,
    String title,
    String vehicleType,
    String time,
    String routeFrom,
    String nameProfession,
  ) {
    if (type == 'donor') {
      return {
        'name': name,
        'phone': phone,
        'location': location,
        'bloodType': collection,
      };
    }

    if (type == 'doctor') {
      return {
        'name': name,
        'phone': phone,
        'specialization': specialization,
        'presence': presence,
        'title': title,
      };
    }

    if (type == 'car') {
      return {
        'name': name,
        'phone': phone,
        'vehicleType': vehicleType,
        'time': time,
        'routeFrom': routeFrom,
      };
    }

    if (type == 'profession') {
      return {'name': name, 'phone': phone, 'nameProfession': nameProfession};
    }

    return {'name': name, 'phone': phone, 'location': location};
  }

  static Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
