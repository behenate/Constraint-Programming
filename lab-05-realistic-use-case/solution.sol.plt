set term postscript font "sans,9"        # can set pdf as well 
set output 'solution.sol.plt.ps'
set title "Pad & Machine Schedule for solution with obj value 62"
set autoscale
set xlabel 'Time' offset 0,-1.5
set ylabel 'Pad position'
set xtics out
set ytics out
unset colorbox
set border lw 0.5
set key outside above right horizontal
plot  '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle  fill pattern border , '-' with boxxyerrorbars notitle lt -1 fill empty, '-' with labels font "12" offset 0.5,0.5 notitle , '-' with linespoints ls 2 lw 6 title 'R_1'
# Dwell: putting first to have the empty fill pattern: x y xlow xhigh ylow yhigh (color?)
1 1 12 12 8 12
1 1 24 24 0 8
1 1 38 40 5 7
1 1 47 47 0 5
end
# Stacking: x y xlow xhigh ylow yhigh (color?)
1 1 0 12 8 12
1 1 0 24 0 8
1 1 32 38 5 7
1 1 32 47 0 5
end
# Reclaim: x y xlow xhigh ylow yhigh (color?)
1 1 12 16 8 12
1 1 24 32 0 8
1 1 40 42 5 7
1 1 47 52 0 5
end
# Whole boxes: x y xlow xhigh ylow yhigh (color?)
1 1 0 16 8 12 1
1 1 0 32 0 8 2
1 1 32 42 5 7 3
1 1 32 52 0 5 4
end
# Labels: x y text (rgbcolor)
12 10 1
24 4 2
39 6 3
47 2 4
end
 # Recl schedule: x y 
12 8
16 8
24 0
32 0
40 5
42 5
47 0
52 0
end
set title "\n\n\n\nThe input data: obj value 62 and:\n\n\neastend = [12, 8, 7, 5];\nendstack = [12, 24, 38, 47];\nfinish = [16, 32, 42, 52];\nreclaim = [12, 24, 40, 47];\nstack = [0, 0, 32, 32];\nwestend = [8, 0, 5, 0];\nwhich = [1, 1, 1, 1];\n" font "sans,12"
set yrange[-1:0]
unset ytics; unset xtics; unset border
plot x*x notitle

