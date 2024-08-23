import 'dart:io';

import 'package:blogapp/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blogapp/core/common/widgets/loader.dart';
import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:blogapp/core/utils/pick_image.dart';
import 'package:blogapp/core/utils/show_snackbar.dart';
import 'package:blogapp/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blogapp/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogapp/feature/blog/presentation/pages/bloc_page.dart';
import 'package:blogapp/feature/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final List<String> selectedTopic = [];
  final _formKey = GlobalKey<FormState>();

  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (_formKey.currentState!.validate() &&
        selectedTopic.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUploaEvent(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopic,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done_rounded),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
         if(state is BlogErrorState){
          showSnakBar(context, state.errorMsg, Colors.red);
         }else if( state is BlogSuccesState){
          Navigator.pushAndRemoveUntil(context,BlogPage.route(), (route)=> false);
          showSnakBar(context, "blog uploaded", Colors.green);
         }
        },
        builder: (context, state) {
          if(state is BlogLoadingState){
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: DottedBorder(
                        color: AppPalette.borderColor,
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeCap: StrokeCap.round,
                        dashPattern: const [20, 4],
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select your image",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          "Technology",
                          "Business",
                          "Programming",
                          "Entertainment",
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopic.contains(e)) {
                                        selectedTopic.remove(e);
                                      } else {
                                        selectedTopic.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      color: selectedTopic.contains(e)
                                          ? const WidgetStatePropertyAll(
                                              AppPalette.gradient1)
                                          : null,
                                      label: Text(e),
                                      side: const BorderSide(
                                          color: AppPalette.borderColor),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controller: titleController, hintText: "Blog title"),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      controller: contentController,
                      hintText: "Blog Content",
                      maxLine: null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
