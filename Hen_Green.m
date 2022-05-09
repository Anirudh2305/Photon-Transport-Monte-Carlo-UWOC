function angle = Hen_Green(g)
val= (1+g^2-((1-g^2)/(1-g+2*g*rand))^2)*(1/(2*g));
angle=acos(val);
end


