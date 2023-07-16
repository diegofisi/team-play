// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:team_play/feature/home/models/profile_update.dart';
// import 'package:team_play/feature/home/providers/profile_provider.dart';

// class UpdateNameForm extends ConsumerStatefulWidget {
//   const UpdateNameForm({ required this.userId, super.key});
//   final String userId;

//   @override
//   UpdateNameFormState createState() => UpdateNameFormState();
// }

// class UpdateNameFormState extends ConsumerState<UpdateNameForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               controller: _nameController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a name';
//                 }
//                 return null;
//               },
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   ProfileUpdate profileUpdate = ProfileUpdate(
//                     name: _nameController.text,
//                   );
//                   ref.read(profileUpdateProvider(userId, profileUpdate));
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Submit'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
