import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_play/feature/home/entities/profile.dart';
import 'package:team_play/feature/home/models/comment_request.dart';
import 'package:team_play/feature/home/providers/profile_provider.dart';
import 'package:team_play/feature/shared/models/comment.dart';

class CommentFormField extends ConsumerStatefulWidget {
  const CommentFormField({
    required this.otherId,
    required this.id,
    required this.profile,
    Key? key,
  }) : super(key: key);
  final String id;
  final String otherId;
  final Profile profile;

  @override
  CommentFormFieldState createState() => CommentFormFieldState();
}

class CommentFormFieldState extends ConsumerState<CommentFormField> {
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  int? selectedRating;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.25,
                child: widget.profile.comments.isEmpty
                    ? const Center(
                        child: Text("No hay comentarios"),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 13,
                            ),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(widget
                                    .profile.comments[index].rating
                                    .toString()),
                              ),
                              title: Text(
                                widget.profile.comments[index].comment,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                        itemCount: widget.profile.comments.length,
                      ),
              ),
              if (widget.id != widget.otherId)
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Escribe un comentario'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, introduce un comentario';
                          }
                          return null;
                        },
                      ),
                      DropdownButton<int>(
                        hint: const Text('Selecciona una clasificación'),
                        value: selectedRating,
                        items: [1, 2, 3, 4, 5]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedRating = newValue;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _formKey.currentState!.validate() &&
                              selectedRating != null) {
                            final comment = ComentRequest(
                              comment: _controller.text,
                              rating: selectedRating!,
                            );
                            final comentario = Comment(
                                id: widget.id,
                                comment: _controller.text,
                                rating: selectedRating!,
                                v: 1);
                            final tupleData = Tuple2(widget.id, comment);
                            await ref
                                .read(postCommentaryProvider(tupleData).future);
                            _controller.clear();
                            widget.profile.comments.add(comentario);
                            setState(() {
                              selectedRating = null;
                              _scrollToBottom();
                            });
                          }
                          return;
                        },
                        child: const Text('Enviar comentario'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
