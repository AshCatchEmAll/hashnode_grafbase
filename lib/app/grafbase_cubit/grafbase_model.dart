class Post {
  String caption;

  String content;
 

 
 
  String sub;

  String id;
  String createdAt;

  Post({
    required this.caption,
   
    required this.content,
   
  
    required this.sub,
   
    required this.id,
    required this.createdAt,
  });

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      caption: json['caption'],

      content: json['content'],
      
    
     
      sub: json['sub'],
     
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;

    data['content'] = content;
    
    
    data['sub'] = sub;
   
    data['id'] = id;
    data['createdAt'] = createdAt;
    return data;
  }
}



class GrafBaseUser{
  String email;
  String sub;
  String? id;
  String? createdAt;

  GrafBaseUser({
    required this.email,
    required this.sub,
    this.id,
    this.createdAt,
  });

  static GrafBaseUser fromJson(Map<String, dynamic> json) {
    return GrafBaseUser(
      email: json['email'],
      sub: json['sub'],
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['sub'] = sub;
    data['id'] = id;
    data['createdAt'] = createdAt;
    return data;
  }
}

