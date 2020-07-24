import 'package:kevin_app/dao/group_dao.dart';
import 'package:kevin_app/models/group.dart';

class GroupRepository {
  final groupDao = GroupDao();

  Future getAllGroups({String query}) => groupDao.groups();

  Future getGroupId(Group group) => groupDao.getGroupId(group);

  Future insertGroup(Group group) => groupDao.insertGroup(group);

  Future updateGroup(Group group) => groupDao.updateGroup(group);

  Future deleteGroupById(int id) => groupDao.deleteGroup(id);

  Future deleteAllGroups() => groupDao.deleteAllGroups();
}
