%% Nomenclature
% wa - without air
% a - with air flow 

%% Instructions:
% Run Sectionwise to see the results in order
%% 

%%
clear;
clc;

%% Data Reading and Pre Processing

% Data Reading (No air flow case)
data_wa = readmatrix("without_air_T1_to_T5.txt");
data_wa_t6_t10 = readmatrix("without_air_T6_to_T10.txt");

T1_wa = data_wa(:,1)+273.15; % Fin Base Temperature (in K)
T2_wa = data_wa(:,2)+273.15; % Fin Tip Temperature (in K)
T3_wa = data_wa(:,3)+273.15; % Water Temperature (in K)
T4_wa = data_wa(:,4)+273.15; % Container Base (outer) Temperature (in K)
T5_wa = data_wa(:,5)+273.15; % Ambient Temperature (in K)
T6_wa = data_wa_t6_t10(:,1)+273.15; % Top Temperature (in K)
T7_wa = data_wa_t6_t10(:,2)+273.15; % Back Temperature (in K)
T8_wa = data_wa_t6_t10(:,3)+273.15; % Front Temperature (in K)
T9_wa = data_wa_t6_t10(:,4)+273.15; % Left Temperature (in K)
T10_wa = data_wa_t6_t10(:,5)+273.15; % Right Temperature (in K)
V_wa = data_wa(:,6); % Voltage Produced (in V)

valid_indices_wa = ~isnan(T1_wa) & ~isnan(T2_wa) & ~isnan(T3_wa) & ~isnan(T4_wa) & ~isnan(T5_wa) & ~isnan(T6_wa) & ~isnan(T7_wa) & ~isnan(T8_wa) & ~isnan(T9_wa) & ~isnan(T10_wa) & ~isnan(V_wa); % Removing NaN values

% Preprocessed Data:
T1_wa = T1_wa(valid_indices_wa);
T2_wa = T2_wa(valid_indices_wa);
T3_wa = T3_wa(valid_indices_wa);
T4_wa = T4_wa(valid_indices_wa);
T5_wa = T5_wa(valid_indices_wa);
T6_wa = T6_wa(valid_indices_wa);
T7_wa = T7_wa(valid_indices_wa);
T8_wa = T8_wa(valid_indices_wa);
T9_wa = T9_wa(valid_indices_wa);
T10_wa = T10_wa(valid_indices_wa);
V_wa = V_wa(valid_indices_wa);



% Data Reading (Air flow case)
data_a = readmatrix("with_air_T1_to_T5.txt");
data_a_t6_t10 = readmatrix("with_air_T6_to_T10.txt");

T1_a = data_a(:,1)+273.15; % Fin Base Temperature (in K)
T2_a = data_a(:,2)+273.15; % Fin Tip Temperature (in K)
T3_a = data_a(:,3)+273.15; % Water Temperature (in K)
T4_a = data_a(:,4)+273.15; % Container Base (outer) Temperature (in K)
T5_a = data_a(:,5)+273.15; % Ambient Temperature (in K)
T6_a = data_a_t6_t10(:,1)+273.15; % Top Temperature (in K)
T7_a = data_a_t6_t10(:,2)+273.15; % Back Temperature (in K)
T8_a = data_a_t6_t10(:,3)+273.15; % Front Temperature (in K)
T9_a = data_a_t6_t10(:,4)+273.15; % Left Temperature (in K)
T10_a = data_a_t6_t10(:,5)+273.15; % Right Temperature (in K)
V_a = data_a(:,6); % Voltage Produced (in V)

valid_indices_a = ~isnan(T1_a) & ~isnan(T2_a) & ~isnan(T3_a) & ~isnan(T4_a) & ~isnan(T5_a) & ~isnan(T6_a) & ~isnan(T7_a) & ~isnan(T8_a) & ~isnan(T9_a) & ~isnan(T10_a) & ~isnan(V_a); % Removing NaN values

% Preprocessed Data:
T1_a = T1_a(valid_indices_a);
T2_a = T2_a(valid_indices_a);
T3_a = T3_a(valid_indices_a);
T4_a = T4_a(valid_indices_a);
T5_a = T5_a(valid_indices_a);
T6_a = T6_a(valid_indices_a);
T7_a = T7_a(valid_indices_a);
T8_a = T8_a(valid_indices_a);
T9_a = T9_a(valid_indices_a);
T10_a = T10_a(valid_indices_a);
V_a = V_a(valid_indices_a);

%% Fitting a curve to V vs delta T plot
delta_T_wa = T4_wa-T1_wa; % Temperature Difference across peltier chips without air flow
delta_T_a = T4_a-T1_a; % Temperature Difference across peltier chips with air flow

V_vs_deltaT_wa = polyfit(delta_T_wa,V_wa,1); % Fitting a line to plot Temperature Difference across peltier vs Voltage Produced (no air flow case)
V_vs_deltaT_a = polyfit(delta_T_a,V_a,1); % Fitting a line to plot Temperature Difference across peltier vs Voltage Produced (with air flow case)

% Generating points to plot the fitted line 
delta_T_wa_values = linspace(min(delta_T_wa),max(delta_T_wa),200);
delta_T_a_values = linspace(min(delta_T_a),max(delta_T_a),200);
V_wa_values = polyval(V_vs_deltaT_wa,delta_T_wa_values);
V_a_values = polyval(V_vs_deltaT_a,delta_T_a_values);

%% Plotting Raw Data and Fitted Curved (V vs delta T graph)
figure(1)
plot(delta_T_wa,V_wa,'o',LineWidth=1.5);
hold on;
plot(delta_T_a,V_a,'o',LineWidth=1.5);
plot(delta_T_wa_values,V_wa_values,'-',LineWidth=2.0);
plot(delta_T_a_values,V_a_values,'-',LineWidth=2.0);
xlabel('Temperature Difference (in ^0C)','FontSize',15);
ylabel('Voltage Produced (in V)','FontSize',15);
title('Voltage Variation with Temperature difference across TEG','FontSize',20);
legend('Raw Data (Without Air)','Raw Data (With Air)','Fitted Curve (Without Air)','Fitted Curve (With Air)')
grid('on');
hold off;

%% Seeback Coefficient (alpha) Calculation
alpha_wa = mean(V_wa./delta_T_wa); % Seeback coefficint in no airflow case (in V/K)
alpha_a = mean(V_a./delta_T_a); % Seeback coefficint in airflow case (in V/K)

%% Time Stamps

% The data values were logged at irregular time intervals of mostly 1 sec
% and sometimes 2 sec. So, the time stamps have been generated accordingly. Since, we are interested in local time derivates to calculate heat flux, it doesn't matter much. 

% Specifying the given lengths and properties of the box, water and time stamps for the logged data values (no air flow case).
t0 = 0;
t_wa = [0,]; % Time values at which data was logged in case of no air flow
for i=2:length(T1_wa)
    if rem(i,3)==0
        t0 = t0+2;
    else
        t0 = t0+1;
    end
    t_wa(i) = t0;
end

t_wa = t_wa'; 

% Specifying the given lengths and properties of the box, water and time stamps for the logged data values (with air flow case).
t0 = 0;
t_a = [0,]; % Time values at which data was logged in case of air flow
for i=2:length(T1_a)
    if rem(i,3)==0
        t0 = t0+2;
    else
        t0 = t0+1;
    end
    t_a(i) = t0;
end

t_a = t_a';

L_box = 0.17; % Length of the steel box (in m)
W_box = 0.10; % Width of the steel box (in m)
H_box = 0.05; % Height of the steel box (in m)
peltier_size = 0.04; % TEG Chips size (in m)
% H_water = 0.025; % Height of Water in container (in m)
C_water = 4186.5; % Specific Heat of Water (in J/(kg K))
p_water = 980.56; % Water Density (in kg/m3)
v_air = 1.51e-5; % Kinematic Viscosity of air
alpha_air = 1.9e-5; % Thermal Diffusivity of air
k_air = 0.026; % Thermal Conductivity of air
g = 9.81; % Accl due to gravity
V_wa_water = 220e-6; % Volume of water in without air flow case
V_a_water = 250e-6; % Volume of water in with air flow case
M_wa_water = p_water*V_wa_water; % Mass of water in without air flow case
M_a_water = p_water*V_a_water; % Mass of water in with air flow case
k_teg = 0.1815; % Thermal conductivity of peltier
H_peltier = 1e-3; % Thickness of Peltier Chips

%% Variation of water temperature with time
figure(2)
plot(t_wa,T3_wa-273.15,'LineWidth',1.5);
hold on;
plot(t_a,T3_a-273.15,'LineWidth',1.5);
xlabel('Time (in sec)','FontSize',15);
ylabel('Water Temperature (in ^0C)','FontSize',15);
title('Variation of water temperature with time','FontSize',20);
legend('Without Air','With Air','FontSize',15);
grid ('on');
hold off;

dT3_wa_dt = polyfit(t_wa,T3_wa,1);
dT3_wa_dt = dT3_wa_dt(1);
dT3_a_dt = polyfit(t_a,T3_a,1);
dT3_a_dt = dT3_a_dt(1);

%% Thermal Calculations

% back, front, left, right
Area_top = L_box*W_box;
Area_side = [L_box*H_box,L_box*H_box,W_box*H_box,W_box*H_box];
T_wa_top = T6_wa;
T_wa_side = [T7_wa,T8_wa,T9_wa,T10_wa];
T_film_top_wa = (T_wa_top+T5_wa)./2;
T_film_wa = (T_wa_side+T5_wa)./2;
beta_wa = 1./T_film_wa;
beta_wa_top = 1./T_film_top_wa;
Ra_wa = (g.*beta_wa.*(T_wa_side-T5_wa).*H_box.^3)./(v_air.*alpha_air); % Ra- Rayleigh Number
Ra_wa_top = (g.*beta_wa_top.*(T_wa_top-T5_wa).*(Area_top/(2*(L_box+W_box))).^3)./(v_air.*alpha_air);
Pr = v_air/alpha_air; % Pr: Prandtl Number
Nu_wa = (0.825+0.387*Ra_wa.^(1/6)./(1+(0.492./Pr).^(9./16)).^(8./27)).^2;

for i=1:length(Ra_wa_top)
    if Ra_wa_top(i)>10^4 && Ra_wa_top(i)<10^7
        Nu_wa_top(i) = 0.54*Ra_wa_top(i)^0.25;
    else
        Nu_wa_top(i) = 0.15*Ra_wa_top(i)^(1/3);
    end
end

Nu_wa_top = Nu_wa_top';
h_wa = Nu_wa.*k_air./H_box;
h_wa_top = Nu_wa_top.*k_air./(Area_top/(2*(L_box+W_box)));

h_wa = horzcat(h_wa_top,h_wa);

Area_side = [Area_top,Area_side];

T_wa_side = [T_wa_top,T_wa_side]; 

q_wa_side = h_wa.*Area_side.*(T_wa_side-T5_wa);

q_wa_total = -M_wa_water*C_water*dT3_wa_dt;

q_wa_bottom = q_wa_total - sum(q_wa_side,2);

Area_teg = peltier_size^2 * 6;
q_peltier_wa = k_teg*(Area_teg)*(T4_wa-T1_wa)/H_peltier;

figure(3)
plot(t_wa, q_wa_bottom, 'LineWidth', 1.5); 
xlabel('Time (in sec)', 'FontSize', 15);
ylabel('Heat Transfer Through bottom surface (W)', 'FontSize', 15);
title('Heat Transfer vs Time (Without air case)', 'FontSize', 20);
grid on;