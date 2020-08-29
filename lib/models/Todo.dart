class Todo {
  String titulo;
  String descricao;
  String status;

  Todo(this.titulo, this.descricao, this.status);

  Todo.fromJson(Map<String, dynamic> json)
      : titulo = json['titulo'],
        descricao = json['descricao'],
        status = json['status'];

  Map toJson() => {'titulo': titulo, 'descricao': descricao, 'status': status};
}
