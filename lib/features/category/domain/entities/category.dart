import 'package:equatable/equatable.dart';

class Category extends Equatable {                                                                                                                      
  const Category({                                                                                                                                      
    required this.id,                                                                                                                                   
    required this.name,                                                                                                                                 
    this.description,                                                                                                                                   
    this.image,                                                                                                                                         
    required this.createdAt,                                                                                                                            
    required this.updatedAt,                                                                                                                            
  });                                                                                                                                                   
                                                                                                                                                        
  final int id;                                                                                                                                         
  final String name;                                                                                                                                    
  final String? description;                                                                                                                            
  final String? image;                                                                                                                                  
  final String createdAt;                                                                                                                               
  final String updatedAt;                                                                                                                               
                                                                                                                                                        
  @override                                                                                                                                             
  List<Object?> get props => [id, name, description, image, createdAt, updatedAt];                                                                      
}
