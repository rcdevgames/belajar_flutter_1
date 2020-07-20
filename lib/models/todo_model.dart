import 'dart:convert';

List<Todo> todoFromMap(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromMap(x)));

String todoToMap(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Todo {
    Todo({
        this.id,
        this.title,
        this.description,
        this.done,
    });

    final int id;
    final String title;
    final String description;
    final int done;

    factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        done: json["done"] == null ? null : json["done"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "done": done == null ? null : done,
    };
}
