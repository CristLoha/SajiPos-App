import 'package:equatable/equatable.dart';
import 'package:saji_pos_app/features/category/data/models/category_model.dart';

class CategoryResponse extends Equatable {                                                                                                              
  final List<CategoryModel> categoryList;                                                                                                               
                                                                                                                                                        
  const CategoryResponse({required this.categoryList});                                                                                                 
                                                                                                                                                        
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {                                                                                        
    return CategoryResponse(                                                                                                                            
      categoryList: List<CategoryModel>.from(                                                                                                           
        (json["data"] as List).map(                                                                                                                     
          (x) => CategoryModel.fromJson(x as Map<String, dynamic>),                                                                                     
        ),                                                                                                                                              
      ),                                                                                                                                                
    );                                                                                                                                                  
  }                                                                                                                                                     
                                                                                                                                                        
  Map<String, dynamic> toJson() {                                                                                                                       
    return {                                                                                                                                            
      "data": List<dynamic>.from(categoryList.map((x) => x.toJson())),                                                                                  
    };                                                                                                                                                  
  }                                                                                                                                                     
                                                                                                                                                        
  @override                                                                                                                                             
  List<Object> get props => [categoryList];                                                                                                             
}
