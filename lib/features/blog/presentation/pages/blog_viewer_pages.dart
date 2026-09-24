import 'package:flutter/material.dart';

import '../../domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [Text(blog.title),    // if it is stf ---->  widget.blog.title
        Image.network(blog.imageUrl)  //  if it is stf  -->  widget.blog.imageUrl
        ],
      ),
    );
  }
}
