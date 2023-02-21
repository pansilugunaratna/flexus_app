import 'package:objectbox/objectbox.dart';

@Entity()
class PostEntity {
  @Id()
  int id;
  String description;

  PostEntity({this.id = 0, required this.description});
}
