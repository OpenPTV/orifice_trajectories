numTraj=nan(1000000,1);
leng=nan(1000000,1);
travel_time=nan(1000000,1);


first=	1;
last=5000;
minLength=20;
for i=first:last
    if mod(i,5)==0
        i
    end

    name=['../data/trajPoint.',num2Str(i)]; % on Windows change from / to \
    f=load(name);
    s=size(f);
    clear x y z;

    if s(1,1)>0
        x=f(:,1);
        y=f(:,2);
        z=f(:,3);

        u=f(:,4);
        v=f(:,5);
        w=f(:,6);

        age=f(:,10);
        zero=find(age==0);

        le=length(zero);
        if age(end)==0
            traj=le-1;
        else
            traj=le
        end

        [kk]=[i traj]
        for j=1:traj-1 %------------ALL TRAJECTORY IN A SINGLE FRAME

            begi=zero(j)+1;
            ende=zero(j+1)-1;
            long=ende-begi+1;
            %leng(j)=long;

            if long>minLength-1
                y_i=y(begi);
                y_e=y(ende);
                z_i=z(begi);
                z_e=z(ende);
                if y_i<.0225 && y_e>.0265 %&& z_i>0.008 && z_e<0.012 %% Condition such that a traj must pass the entrance which is at y=24.5 mm
                    del_t=0;
                    for p=1:long-1%-----------------SINGLE TRAJECTORY TRAVEL TIME
                        del_d=sqrt((x(begi+p)-x(begi+p-1))^2+(y(begi+p)-y(begi+p-1))^2+(z(begi+p)-z(begi+p-1))^2);
                        del_v=sqrt((u(begi+p)-u(begi+p-1))^2+(v(begi+p)-v(begi+p-1))^2+(w(begi+p)-w(begi+p-1))^2);
                        
                        del_t=del_t+del_d/del_v;
                    end


                    %                     travel_time(j)=del_t;
                    %                     H=find(~isnan(travel_time));
                    %                     zeit=travel_time(H);


                    hold on,box on,grid on
                    plot3(x(begi:ende),y(begi:ende),z(begi:ende));
                    scatter3(x(begi),y(begi),z(begi),'g','filled')
                    %txtr=annotation('textarrow',x(begi),y(begi),z(begi),'String','We are here.','FontSize',14)
                    scatter3(x(ende),y(ende),z(ende),'r','filled')
                    drawnow
                    hold off
                end
            end
        end
    end
end

