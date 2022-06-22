function y = interplin(x,x1,y1,x2,y2)

y = y1 + (x-x1)*(y2-y1)/(x2-x1);

end