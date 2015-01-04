classdef filewriter < handle
% Property data is private to the class
   properties (SetAccess = private, GetAccess = private)
      fileID
   end % properties

   methods
   % Construct an object and 
   % save the file ID  
      function obj = filewriter(filename,permission) 
         obj.fileID = fopen(filename,permission);
      end
 
      function writeToFile(obj,text_str)
         fprintf(obj.fileID,'%s\n',text_str);
      end
      
      function writeGpdata(obj,text_str)
         fprintf(obj.fileID,'%e',text_str);
      end
      % Delete methods are always called before a object 
      % of the class is destroyed 
      function delete(obj)
         fclose(obj.fileID);
      end 
   end  % methods
end % class 