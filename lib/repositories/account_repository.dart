import '../db/mock_db.dart';
import '../models/account_model.dart';
import 'account_interface.dart';

class AccountRepository implements IAccountRepository {
  final VirtualDB _db;

  AccountRepository(this._db);

  @override
  Future<Account?> getCurrentUser() async {
    var item = await _db.findOne(0);
    return item != null ? Account.fromMap(item) : null;
  }

  @override
  Future<bool> insert(Account account) async {
    //todo implement getting current user
    await _db.insert(account.toMap());
    return false;
  }

  @override
  Future<bool> update(Account account) async {
    await _db.update(account.toMap());
    return false;
  }

  @override
  Future<bool> delete(int id) async {
    await _db.remove(id);
    return false;
  }
}
