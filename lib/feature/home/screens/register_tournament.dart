import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_play/feature/auth/presentation/providers/firebase_uid_provider.dart';
import 'package:team_play/feature/home/models/tournament_register_request.dart';
import 'package:team_play/feature/home/providers/tournament_provider.dart';

class RegisterTournament extends ConsumerStatefulWidget {
  final String tournamentId;
  final String teamID;

  const RegisterTournament({
    required this.tournamentId,
    required this.teamID,
    super.key,
  });

  @override
  RegisterTournamentState createState() => RegisterTournamentState();
}

class RegisterTournamentState extends ConsumerState<RegisterTournament> {
  final picker = ImagePicker();
  String voucherb64 = '';
  File? _image;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      final bytes = _image!.readAsBytesSync();
      voucherb64 = base64Encode(bytes);
    } else {
      return;
    }
  }

  Future<List> initData(BuildContext context, WidgetRef ref) async {
    try {
      final uid = await ref.read(firebaseUIDProvider.notifier).getUid();
      if (uid == null) {
        Future.microtask(() => context.go('/login'));
        return [];
      }
      return [uid];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initData(context, ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final uid = snapshot.data![0] as String;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                Future.microtask(() => context.go('/home/:$uid'));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Registrate al Torneo'),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      "El pago es por Yape (QR)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/qr_image2.png',
                      height: 300,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    _image == null
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              color: Colors.grey,
                            ),
                            width: 200,
                            height: 200,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Sube tu pago",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Image.file(
                            _image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Toma una foto'),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Foto de la galeria'),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Debes subir una foto'),
                        ),
                      );
                      return;
                    }

                    final registerTournament = TournamentRegisterRequest(
                      teamId: widget.teamID,
                      voucher: voucherb64,
                    );

                    final registro =
                        tuple2(widget.tournamentId, registerTournament);

                    final isRegister = await ref
                        .read(registerTournamentProvider(registro).future);

                    if (isRegister) {
                      Future.microtask(() {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registro Exitoso'),
                          ),
                        );
                        return context.go('/home/:$uid');
                      });
                    }
                    if (!isRegister) {
                      Future.microtask(() {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registro Fallido'),
                          ),
                        );
                      });
                    }
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
