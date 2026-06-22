    import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {                                                                                                                      
      const OrderItem({                                                                                                                                      
        required this.id,                                                                                                                                    
        required this.orderId,                                                                                                                               
        required this.productId,                                                                                                                             
        required this.quantity,                                                                                                                              
        required this.price,                                                                                                                                 
        required this.note,                                                                                                                                  
      });                                                                                                                                                    
                                                                                                                                                             
      final int id;                                                                                                                                          
      final int orderId;                                                                                                                                     
      final int productId;                                                                                                                                   
      final int quantity;                                                                                                                                    
      final int price;                                                                                                                                       
      final String note;                                                                                                                                     
                                                                                                                                                             
      @override                                                                                                                                              
      List<Object?> get props => [id, orderId, productId, quantity, price, note];                                                                            
    }