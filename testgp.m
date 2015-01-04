clear all
clc

% Some sample data
x1 = linspace(0,1,100)';
y1 = x1.^2;
x2 = linspace(1,3,100)';
y2 = sqrt(x2);

% A gnuplot with two function and 2 data plots from different data sets 
mygp = gp('Myplot');
mygp.addCommand('set title ''My Titel''');
mygp.addFunction('sin(x)');
mygp.addFunction('cos(x)');
mygp.addData([x1,y1],'with lines lw 8');
mygp.addData([x2,y2],'with lines');
% Once the plot line string is set up, we add the line to the gnuplot
% script
mygp.plot('[x=0:3]');
% Finally, we include the epslatex output into a test tex file
mygp.testtex();
