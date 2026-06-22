 import 'package:equatable/equatable.dart';                                                                                                               
    import 'order_item_request.dart';                                                                                                                        
                                                                                                                                                             
    class OrderRequest extends Equatable {                                                                                                                   
      const OrderRequest({                                                                                                                                   
        required this.cashierId,                                                                                                                             
        required this.transactionTime,                                                                                                                       
        required this.subTotal,                                                                                                                              
        this.discountAmount = 0.0,                                                                                                                           
        this.shippingCost = 0.0,                                                                                                                             
        required this.serviceCharge,                                                                                                                         
        required this.tax,                                                                                                                                   
        required this.total,                                                                                                                                 
        required this.paymentMethod,                                                                                                                         
        required this.orderItems,                                                                                                                            
      });                                                                                                                                                    
                                                                                                                                                             
      final int cashierId;                                                                                                                                   
      final String transactionTime;                                                                                                                          
      final double subTotal;                                                                                                                                 
      final double discountAmount;                                                                                                                           
      final double shippingCost;                                                                                                                             
      final double serviceCharge;                                                                                                                            
      final double tax;                                                                                                                                      
      final double total;                                                                                                                                    
      final String paymentMethod;                                                                                                                            
      final List<OrderItemRequest> orderItems;                                                                                                               
                                                                                                                                                             
      @override                                                                                                                                              
      List<Object?> get props => [                                                                                                                           
            cashierId,                                                                                                                                       
            transactionTime,                                                                                                                                 
            subTotal,                                                                                                                                        
            discountAmount,                                                                                                                                  
            shippingCost,                                                                                                                                    
            serviceCharge,                                                                                                                                   
            tax,                                                                                                                                             
            total,                                                                                                                                           
            paymentMethod,                                                                                                                                   
            orderItems,                                                                                                                                      
          ];                                                                                                                                                 
    }                            