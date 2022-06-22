function value = rt_ar(t)

mat = [0   0.00 
       5   0.10
       7   0.12
       10  0.14
       15  0.15
       25  0.16
       50  0.16
       100 0.16
       300 0.16];
   
mat(:,1) = 1e-3*mat(:,1);   
   
for ii = 1:size(mat,1)-1
   rt1 = mat(ii,2);
   rt2 = mat(ii+1,2);
   t1 = mat(ii,1);
   t2 = mat(ii+1,1);
   if t>=t1 && t<t2
       value = interplin(t,t1,rt1,t2,rt2);
       break;
   end
end

if t>=300e-3
   value = 0.16; 
end

end