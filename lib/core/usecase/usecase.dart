import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

//  generics used here
//  success can depend   ,,  we can not hard code
//  whenever the user is implementing the usecase class they need to mention the successType
abstract interface class UseCases<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams{}