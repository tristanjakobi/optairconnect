import 'package:optairconnect/models/device_model.dart';

import '../models/account_model.dart';

abstract class IAccountRepository {
  Future<Account?> getCurrentUser();
  Future<void> insert(Account account);
  Future<void> update(Account account);
  Future<void> delete(int id);
}
