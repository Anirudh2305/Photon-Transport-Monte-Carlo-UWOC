classdef Photon
    properties
       x
       y
       z
       mux
       muy
       muz
       wt
    end
    methods
        function obj = updateDir(obj,s)
            obj.x=obj.x+obj.mux*s;
            obj.y=obj.y+obj.muy*s;
            obj.z=obj.z+obj.muz*s;    
        end
        function obj = updateDC(obj,theta,phi)

            prev_mux=obj.mux;
            prev_muy=obj.muy;
            prev_muz=obj.muz;

            stheta=sqrt(1-prev_muz^2); % Mobley check for straight along z.

            %if abs((obj.muz-1))>1e-10
            if stheta>1e-12
            obj.mux=(sin(theta)*(prev_mux*prev_muz*cos(phi)-prev_muy*sin(phi)))/sqrt(1-prev_muz^2)+prev_mux*cos(theta);
            obj.muy=(sin(theta)*(prev_muy*prev_muz*cos(phi)+prev_mux*sin(phi)))/sqrt(1-prev_muz^2)+prev_muy*cos(theta);
            obj.muz=-sqrt(1-prev_muz^2)*sin(theta)*cos(phi)+prev_muz*cos(theta);
            else
             
                mus=cos(theta);
                obj.mux=Signum(prev_muz)*sqrt(1-mus^2)*cos(phi);
                obj.muy=Signum(prev_muz)*sqrt(1-mus^2)*sin(phi);
                obj.muz=Signum(prev_muz)*mus;
            end
            mag=sqrt(obj.mux^2 + obj.muy^2 + obj.muz^2);
            obj.mux=obj.mux/mag;
            obj.muy=obj.muy/mag;
            obj.muz=obj.muz/mag;

        end
    end
end
