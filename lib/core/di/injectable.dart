/**
 * 日期: 2025/4/29
 * 文件: injectable
 * 包名: core.di
 * 用户: allenaaron
 */

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Import the generated file (will be created by build_runner)
import 'injectable.config.dart';

// Create a GetIt instance
final getIt = GetIt.instance;

// Annotation to initialize injectable
@InjectableInit(
  initializerName: r'$initGetIt', // default initializer name
  preferRelativeImports: true, // prefer relative imports
  asExtension: false, // generate as a function not extension
)
Future<void> configureDependencies() async => $initGetIt(getIt);

// You can also configure environments here if needed, e.g.:
// const String dev = 'dev';
// const String prod = 'prod';
// @InjectableInit(...)
// Future<void> configureDependencies({String environment = dev}) async =>
//     $initGetIt(getIt, environment: environment);

