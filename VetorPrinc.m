classdef VetorPrinc
   properties
      Matriz;
      Grupo;
      
   end
   methods
      function obj = VetorPrinc(m,g)
         if nargin >0 
             disp('dentro if');
            obj.Matriz=m;
            obj.Grupo =g;
         end
      end           
   end
end