# CFreeType

---

## Install

### Mac

> brew install freetype 


### [ExampleC](https://yycking.pixnet.net/blog/post/154177252)


### Bitmap 

text to bitmap

``` bash
swift build
.build/debug/bitmap \
    -f "/System/Library/Fonts/Supplemental/Arial Unicode.ttf" \
    -t "ABCabc新年快樂こんにちは" \
    -s 24
      ■■■       
      ■■■       
     ■■ ■■      
     ■■ ■■      
     ■■ ■■      
    ■■   ■■     
    ■■   ■■     
   ■■■    ■■    
   ■■     ■■    
   ■■     ■■    
  ■■■■■■■■■■■   
  ■■■■■■■■■■■   
 ■■■       ■■■  
 ■■         ■■  
 ■■         ■■  
■■           ■■ 
■■           ■■ 
■■■■■■■■        
■■■■■■■■■■      
■■      ■■      
■■       ■■     
■■       ■■     
■■       ■■     
■■      ■■      
■■■■■■■■■       
■■■■■■■■■■      
■■       ■■     
■■        ■■    
■■        ■■    
■■        ■■    
■■        ■■    
■■       ■■     
■■■■■■■■■■■     
■■■■■■■■■       
     ■■■■■      
   ■■■■■■■■■    
  ■■■     ■■■   
 ■■■       ■■   
 ■■        ■■■  
■■          ■■  
■■              
■■              
■■              
■■              
■■              
■■          ■■  
 ■■        ■■■  
 ■■■       ■■   
  ■■■     ■■■   
   ■■■■■■■■■    
    ■■■■■■      
  ■■■■■■        
 ■■■■■■■■       
■■■    ■■■      
■■      ■■      
      ■■■■      
  ■■■■■■■■      
 ■■■■■  ■■      
■■      ■■      
■■      ■■      
■■■   ■■■■      
 ■■■■■■■■■      
  ■■■■   ■■     
■■              
■■              
■■              
■■              
■■              
■■ ■■■■         
■■■■■■■■■       
■■■    ■■       
■■      ■■      
■■      ■■      
■■      ■■      
■■      ■■      
■■      ■■      
■■      ■■      
■■■    ■■       
■■■■■■■■■       
■■ ■■■■         
   ■■■■         
 ■■■■■■■        
 ■■   ■■■       
■■     ■■       
■■              
■■              
■■              
■■              
■■     ■■       
 ■■   ■■■       
 ■■■■■■■        
   ■■■■         
     ■■            ■■           
     ■■        ■■■■             
     ■■     ■■■■                
 ■■■■■■■■■■ ■■                  
  ■■    ■■  ■■                  
  ■■■   ■■  ■■                  
   ■■  ■■   ■■                  
   ■■  ■■   ■■■■■■■■■■          
■■■■■■■■■■■ ■■   ■■             
     ■■     ■■   ■■             
     ■■     ■■   ■■             
     ■■     ■■   ■■             
 ■■■■■■■■■■■■■   ■■             
    ■■■ ■   ■■   ■■             
   ■■■■■■■  ■■   ■■             
   ■ ■■  ■■ ■■   ■■             
  ■■ ■■   ■■■    ■■             
 ■■  ■■    ■■    ■■             
■■   ■■    ■■    ■■             
     ■■   ■■     ■■             
     ■■    ■     ■■             
    ■                           
    ■■                          
   ■■■                          
   ■■■■■■■■■■■■■■■■             
  ■■■     ■■                    
  ■■      ■■                    
 ■■■      ■■                    
■■■       ■■                    
 ■ ■■■■■■■■■■■■■■■              
   ■■     ■■                    
   ■■     ■■                    
   ■■     ■■                    
   ■■     ■■                    
   ■■     ■■                    
■■■■■■■■■■■■■■■■■■■■            
          ■■                    
          ■■                    
          ■■                    
          ■■                    
          ■■                    
          ■■                    
          ■■                    
          ■■                    
    ■■      ■■                  
    ■■      ■■                  
    ■■      ■■                  
    ■■      ■■                  
    ■■      ■■                  
  ■■■■■■■■■■■■■■■■■             
  ■■■■■■    ■■   ■■             
  ■■■■■■    ■■   ■■             
 ■■■■■ ■■   ■■   ■■             
 ■■ ■■ ■■   ■■   ■■             
■■■ ■■ ■■   ■■   ■■             
 ■  ■■      ■■   ■■             
    ■■ ■■■■■■■■■■■■■■           
    ■■      ■■■■                
    ■■     ■■ ■■                
    ■■     ■■  ■                
    ■■     ■■  ■■               
    ■■    ■■    ■■              
    ■■   ■■     ■■              
    ■■  ■■       ■■             
    ■■ ■■         ■■■           
    ■■■■            ■■          
          ■■                    
   ■     ■■     ■               
   ■■  ■■■■■■■  ■■              
   ■■ ■■■   ■■ ■■ ■             
 ■■■  ■■■   ■■■■■ ■■            
  ■■ ■■■■   ■■ ■■■■             
   ■■■ ■■■■■■■  ■■■             
    ■■ ■■   ■■  ■■              
   ■■■ ■■   ■■  ■■■■            
  ■■ ■■■■   ■■ ■■ ■■            
 ■■■■■■■■■■■■■■■■■■■            
      ■■ ■■       ■■            
         ■■                     
 ■■■■■■■■■■■■■■■■■■■            
      ■■■■■■■■                  
     ■■■ ■■ ■■■                 
    ■■■  ■■   ■■■               
  ■■■    ■■     ■■■             
■■■      ■■       ■■■           
         ■■                     
  ■■■■■■■■■     
  ■■■■■■■■■■■■  
           ■■■  
                
                
                
                
                
  ■             
 ■■■            
 ■■             
■■■             
■■              
■■              
■■■          ■■■
 ■■■■■■■■■■■■■■■
   ■■■■■■■■■■   
         ■                      
        ■■■                     
        ■■                      
       ■■■                      
       ■■                       
      ■■                        
      ■■                        
     ■■ ■■■■                    
     ■■■■■■■■                   
    ■■■■   ■■                   
   ■■■■    ■■                   
   ■■■     ■■                   
  ■■■     ■■      ■             
  ■■      ■■     ■■■            
 ■■■      ■■    ■■■             
 ■■       ■■   ■■■              
■■■       ■■■■■■■               
 ■         ■■■■                 
  ■                             
 ■■■                            
 ■■    ■■■■■■■■■■               
 ■■    ■■■■■■■■■■               
 ■■                             
■■■                             
■■                              
■■                              
■■                              
■■                              
■■                              
■■                              
■■  ■■                          
■■ ■■■■■                        
■■■■■ ■■                        
 ■■■■ ■■                        
 ■■■■ ■■■■■■■■■■■■              
 ■■■   ■■■■■■■■■■■              
  ■■                            
      ■                         
      ■■                        
     ■■■                        
     ■■                         
     ■■     ■■■■                
■■■■■■■■■■■■■■■■                
■■■■■■■■■■■■                    
    ■■                          
   ■■■                          
   ■■                           
  ■■■■■■■■■■■                   
  ■■■■■■■■■■■■■                 
 ■■■■■■      ■■■                
  ■■          ■■■               
               ■■               
               ■■               
               ■■               
  ■           ■■■               
  ■■■■      ■■■■                
  ■■■■■■■■■■■■■                 
     ■■■■■■■■                   
  ■■        ■■                  
  ■■        ■■                  
 ■■         ■■                  
 ■■         ■■  ■■              
 ■■  ■■■■■■■■■■■■■              
 ■   ■■■■■■■■■■■                
■■          ■■                  
■■          ■■                  
■■          ■■                  
■■          ■■                  
■■          ■■                  
■■      ■■■■■■                  
■■ ■  ■■■■■■■■■■                
■■■■■■■■    ■■■■■■              
■■■■ ■■     ■■  ■■■             
■■■■ ■■     ■■   ■              
■■■■ ■■■   ■■                   
 ■■   ■■■■■■■                   
 ■■    ■■■■■                    
 ```