import 'package:kevin_app/models/group.dart';
import 'package:kevin_app/repository/group_repository.dart';
import 'package:rxdart/rxdart.dart';

class GroupService {
  static List<Group> dbGroups = [];
  BehaviorSubject<List<Group>> _groupList = BehaviorSubject.seeded(<Group>[]);

  Stream get stream => _groupList.stream;

  List<Group> get currentList => _groupList.value;

  final GroupRepository _groupRepository = GroupRepository();

  GroupService() {
    _getGroups();
  }
  void _getGroups() async {
    dbGroups = await _groupRepository.getAllGroups();

    _groupList.add(dbGroups ?? []);
  }

  add(Group group) async {
    _groupList.value.add(group);
    _groupList.add(List<Group>.from(currentList));
    _groupRepository.insertGroup(group);
    _getGroups();
  }

  update(Group group) async {
    await _groupRepository.updateGroup(group);
    _getGroups();
  }

  remove(int id) async {
    _groupList.value.removeWhere((group) => group.id == id);
    _groupList.add(List<Group>.from(currentList));
    await _groupRepository.deleteGroupById(id);
    _getGroups();
  }

  getgroupId(Group group) async {
    int id = await _groupRepository.getGroupId(group);
    return id;
  }

  void orderGroupsAscending() {
    List<Group> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    _groupList.add(orderList);
  }

  void orderGroupsDescending() {
    List<Group> orderList = currentList;
    orderList.sort((a, b) => a.name.compareTo(b.name));
    List<Group> reversedList = orderList.reversed.toList();
    _groupList.add(reversedList);
  }
}

GroupService groupService = GroupService();
