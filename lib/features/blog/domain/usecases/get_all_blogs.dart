import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/core/usecase/usecase.dart';
import 'package:blog_app_supabase/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

class GetAllBlogs implements UseCases<List<Blog>, NoParams> {
  final BlogRepositories blogRepositories;
  GetAllBlogs(this.blogRepositories);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepositories.getAllBlogs();
  }
}
