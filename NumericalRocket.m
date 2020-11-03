format shortg

%Written by James Stewart for use by Alabama Rocketry Association, Deimos II%
%Contact Info : jrstewart3@crimson.ua.edu%

%ugly as hell so feel free to pretty it up% 

%SI UNITS% 

%Paramaters%
g = 9.81;
P0 = 101325;
L = 0.0065;
M = 0.0289654;
R = 8.31447;
T0 = 288.15;

%Design Parameters%
Arock = 0.0324128384;
Cd = 0.75;
mEmpt = 15;
mEng = 15.258;
mProp = 7.512;
I = 14041;
T = 3168;
mEngCase = mEng - mProp;
tBurn = I/T;
dm = (mProp/tBurn);

%Recovery Parameters%
DPara = 6.72;
CdPara = 1.5;
APara = 3.14 * (DPara/2) * (DPara/2);
recov = false

%Iterate and loop variables%
idx = .10
testvar=[]
n = 30000;
dt = .005;

for mEmpt = 0:idx:30 %X axis variable

    dat = [0, mEmpt+mEng, 0, 0, 0, 0, 0, 0, ((P0*M)/(R*T0))*((1-((L*0)/T0)).^((g*M)/((R*L)-1))), 0];
    for i = 1:n

        V = zeros(1,10);
        V(1) = dat(i,1) + dt; %time%

        V(2) = dat(i,2)- dm*dt; %mass%
        if V(1) > tBurn, V(2) = mEmpt+mEngCase;
        end

        %if dat(i,8) <500 & dat(i,7)<0 & recov == false%parahcute or not so
            %V(3) = 0.5*dat(i,9)*CdPara*APara*dat(i,7)*dat(i,7)*sign(dat(i,7));
            %recov = true
        %else
            V(3) = 0.5*dat(i,9)*Cd*Arock*dat(i,7)*dat(i,7)*sign(dat(i,7)); %drag force%
        %end

        if V(1)<tBurn, V(4) = T; %thrust%
        else V(4) = 0; 
        end

        V(5) = V(4)-V(3) - (V(2)*g); %net force%
        if V(5) > 1000000, V(5) = 0; 
        end

        V(6) = V(5)/V(2); %acceleration%
        if V(7) < -100000, V(7) = 0; 
        end

        V(7) = dat(i,7)+ (V(6)*dt); %velocity%
        if V(7) < -100000, V(7) = 0;
        end

        V(8) = dat(i,8) + (V(7)*dt) + (0.5*V(6)*dt*dt); %altitude%
        if V(8) < 0, break
        end

        V(9) = ((P0*M)/(R*T0))*((1-(L*V(8)/T0)).^((g*M)/((R*L)-1))); %air density%

        V(10) = .5*V(7)*V(7)*V(9); %dynamic pressure%

        dat = [dat;V];
    end

    
    dat;
    i;
    testvar = [testvar;[mEmpt,max(dat(:,8))]]
end


%Plotting%
plot(testvar(:,1),testvar(:,2))
xlabel('Dry Mass (kg)');
ylabel('Max Altitude(m)');
hold on
