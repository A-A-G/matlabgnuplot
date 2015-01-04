classdef gp < handle
    %gp Create publish quality gnuplots from matlab
    
    properties
        name                % name of the plot that is used for the files
        plotstring = ''     % string that consists of gnuplot code for function and data plots              
        index = -1          % data set index
    end
    
    methods
        %Constructor
        function p = gp(name)
            p.name = name;
            fw = filewriter([name '.gp'],'w');
            fw.writeToFile('set term epslatex color');
            fw.writeToFile(['set output ''' name '.tex'''])
            fw.delete()
        end
        
        function addCommand(p,command)
            fw = filewriter([p.name '.gp'],'a');
            fw.writeToFile(command)
            fw.delete()
        end
        
        function p = addFunction(p,funcstring)
            % Adds a function to the plotstring
            if ~isequal(p.plotstring,'')
                p.plotstring = [p.plotstring ', '];
            end
            p.plotstring = [p.plotstring funcstring];
        end
                
        function p = addData(p,data,modifiers)
            %Adds a data set to ~.dat and commands to plot string
            if ~isequal(p.plotstring,'')
                p.plotstring = [p.plotstring ', '];
            end
            if p.index == -1
                % Create empty data file or delete content of old data file
                % if exists
                dlmwrite('gpData.dat',zeros(0,0),'delimiter',' ')
            else
                % Add 2 empty lines to separate datasets
                dlmwrite('gpData.dat',zeros(2,0),'-append','delimiter',' ')
            end
            % increment data set index
            p.index = p.index+1;
            % append new data
            dlmwrite('gpData.dat',data,'-append','delimiter',' ');
            % expand plot string to account for new data plot
            p.plotstring = [p.plotstring ' ''gpData.dat'' index ' num2str(p.index) modifiers ];
        end
                
        function plot(p,ranges)
            % Adds the plot line to gnuplot script, unsets output and
            % executes the script
            fw = filewriter([p.name '.gp'],'a');
            fw.writeToFile(['plot ' ranges ' ' p.plotstring]);
            fw.writeToFile('unset output')
            fw.delete()
            eval(['!gnuplot ' p.name '.gp']) 
        end
            
        function testtex(gp)
        % Creates a test tex file
        tt = filewriter([gp.name '_test.tex'],'w');
        tt.writeToFile('\documentclass[a4paper,10pt]{scrartcl}')
        tt.writeToFile('\usepackage[utf8]{inputenc}')
        tt.writeToFile('\usepackage{graphicx}')
        tt.writeToFile('\begin{document}')
        tt.writeToFile(['\input{' gp.name '}'])
        tt.writeToFile('\end{document}')
        system(['epstopdf ' gp.name '.eps'])
        system(['pdflatex ' gp.name '_test.tex'])
        end   
    end
end

