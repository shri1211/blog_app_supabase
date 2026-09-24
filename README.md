# blog_app_supabase

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
===========================================================================================================


Blog App Documents

https://dartpub.dev/framework      ----------------   Dart Native



clean architecture

https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?queryGroups=database-method&database-method=sql      Supabase link


Data     -   it contains real implementation

Domain   -   it has repository layer(  folder  )  --  it contains Data layer interface only ( not implementation )

Presentation

**   feature first approach


Auto fix  in Mac
command + .

v s code extensions  - --  >  error lens

multi-line curser  ===>  command  and select line


principle of seperation of concerns   -    in clean architecture

Domain layer is independent from Data Layer


NEXT_PUBLIC_SUPABASE_URL=https://zijpcfjjpuvvikinikpz.supabase.co
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_IQXUyuSxuXfBHQbIhRx77w_iF1c5Jej


V S code --   auto savee ==  setting   ---   format on save  tik mark

final SupabaseClient supabaseClient;  ----- >   this is a DI   --- dont include late kewword   (  create a constructor and pass arguments )

return response.user!.id;   ----> here user gives an error  because need to write async and await properly  ----> without async keyword ---> it is giving an error


in Domain --->  useCases

we need to create a interface to expose high level functionalities to the bloc


1 domain --  repository

2. data layer -- remote data source

3. data layer --  repositories

4. domain layer - usecases

Bloc

bloc state,  event , bloc

main , MultiBlocProvider
Provide :[
BlocProvider
]

when we run the app and click on register , the details is showing in the supabase, click on three dots will show , --- full json   raw_usr_meta_data

DI

registerFactory --  instance is to be created on demand,

register singleton ---  it should be created only once   ( supabase )

registerlazysingleton  ---  one state to be persisted


Build a User Management App with Flutter   ----   triggers     REfference Supabase

create a Entity in Domain

create a Model in Data


if we are in domain layer, we can not accept data from Data layer  --  this is important

whereever we give String that should be replace with User ( entity )  and User Model  , repository and repoImpl


Login feature

1 , Data Layer  --  AuthRemotedatasource

2. Domain layer ---  repository

3 . Data layer  --  repoImpl


UseCase for login

Bloc - Business logic

first -   Event

second -- state

third --- Bloc

//   whatever you are adding in the usecases , need to register in the DI

after bloc --  >   register in the DI

after DI  registration

go to UI to bind the bloc to the UI

go to supabase , in the email --> disable -->>>>> Secure email change   for email confirmation

Domain layer is a higher layer module

Domain layer is a lower layer module


clean architecture --   you should be depend on abstractiton ,  not implementation
   
=================================================================================================================================

persisting the auth state , means ( if the user is logged in ,  he should be logged in  , until logout )

1 ..  supabase stream ,  whenever sign up . sign in sign out etc

2.  Session (  access token )


after authRemoteDataSource

//  after tap on login , you need to store the credentials in profile table
============================================================


Session Storing

    1 Data layer -- auth remote data source
   
    2 Domain layer -- auth repository
   
    3 AuthRepo_Impl implementing the session storing in the  auth remote data source
    
    4 UseCases --   if no params found just add it in core / usecases  as empty class   and then import it in Use cases
    
    5 Presentation - bloc   --  constructor ,  event -  res.fold((l) => l.message), (r)=> r.message))



if i want to add email to the model ,,add with  copyWith method


**  core cannot depend on other feature
** other features can depend on core



Auth cubit created and implemented in Auth bloc --  why ?   3:55  start watch


***   Appwide implementation --  means only specific id of the user can add blog in his own account


***  Auth feature is totally dependent on core

need image picker implementation in Ios requires som config in info.plist


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Blog   ===  implementation starts here

Domain --  entity

data  -- model

data -- data source

domain -- repository

create a model with factory  fromjson and toJson    and import it in remoteDataSource

data --  remote_data_source

domain --  repository

data --  repository_impl

domain -- usecase

presentation --  bloc

state

event -- take values from usecases parameter

Bloc --- import the usecases   from  UseCases  primarily and  add the values of parmas    ,,,   then    res.fold   fialure state and success state


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

IMPORTANT

Use fromJson() when you receive data from an API or database.

Use toJson() when you want to send data to an API or database.



***  supabaseClient.storage --   for storage,     auth --  for authentication,  from --> for accessing Database

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



Display all blogs on screen

1 data layer -- datasource  --  added posterName field from profile table ,,, -- added in entity, models, and join operation in datasource using postrId field   and copyWith method

2 - domain layer -- repository

3. data layer -- blog  repo impl,

usecase

Bloc  -- import Blogrepositoriy  from domain

register in Get it dependency

in UI always call the event

write seperate card --- pass the entity as constructer



call it in BlOc

display on screen

   
==========================


internet connection checker plus
in core ,   abstract interface and impl

    then register in DI
    
    
    internet checker in authImpl  for current user is need to check 
    
    -----------------------------------------------
    
    implementing the local storage via Hive 
    
    if blogRepoImpl  --  if (internet not there ) then show blogs 
    
    // in   DI  
    
    add path to store the values and HIve
    
    impl  
    
      ..registerFactory<BlogLocalDataSources>(
      () => BlogLocalDataSourcesImpl(serviceLocator()),
    )
    
    
    **   <BlogLocalDataSources>  to mention this is important