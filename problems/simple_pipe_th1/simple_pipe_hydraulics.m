clear
clc
close 'all'

%% set environment for EasyProp
% put location of EasyProp.py module on the python search path
if count(py.sys.path,' ') == 0  % <-- see if desired directory is on path
    insert(py.sys.path,int32(0),' '); %<-- if not; add it.
end

fluid = py.EasyProp.simpleFluid('Helium','SI');

%% System Parameters

% relevant fluid properties
P_in = 100; % kPa, inlet pressure
T_in = 27; % C, inlet temperature
m_dot = 1e-1; % kg/s, mass flow rate
rho_in = 1./fluid.v_pT(P_in,T_in); % kg/m^3, inlet density
mu = fluid.mu_pT(P_in,T_in); % Pa-s, dynamic viscosity
k = fluid.k_pT(P_in,T_in); % kW/m-K, thermal conductivity
MolarMass = fluid.M(); % kg/kmol, molar masss
fprintf('mu = %g Pa-s\n',mu);
fprintf('k = %g W/m-K\n',k*1000);
fprintf('molar mass = %g kg/mol\n',MolarMass/1000);
% geometry parameters
%r_channel = 0.00132; % m, channel radius

% set instead to parameters given in 01_flow_channel_01.i
A_chan = 7.2548e-3; % m^2, channel cross sectional area
D_h = 7.0636e-2; % m, channel hydraulic dyameter
L = 1; % m, channel length
rr = 0; % relative roughness, 0 = smooth channel

% derived parameters
%A_chan = 2*pi*r_channel^2; %, m^2, channel flow area
%D = 2*r_channel; % m, channel diameter
v_avg = m_dot/(rho_in*A_chan); % m/s, average velocity
fprintf('Average velocity = %g m/s\n',v_avg);
Re = rho_in*v_avg*D_h/mu;
g = 9.81; % m/s^2
fprintf('Reynolds number = %g \n',Re);


Colebrook = @(f,rr,D,Re) 1/sqrt(f) + ...
    2.0*log10((rr/D)/3.7 + 2.51/(Re*sqrt(f)));

f = fzero(@(f) Colebrook(f,rr,D_h,Re),0.11);
fprintf('Darcy Friction Factor = %g \n',f);

dP = f*(L/D_h)*((v_avg^2)/2)*rho_in; % Pa
fprintf('Estimated differential pressure = %g Pa \n',...
    dP);

%% MOOSE THM by default will use the Churchill correlation

f = (8/6.0516)*(log((rr/D_h)/3.7 + (7/Re)^0.9))^(-2);
dP = f*(L/D_h)*((v_avg^2)/2)*rho_in; % Pa
fprintf('Estimated differential pressure = %g Pa \n',...
    dP);

%% Try to read Exodus file in MATLAB
data_about = ncinfo('01_flow_channel_01_out.e');
coordz = ncread('01_flow_channel_01_out.e','coordz');
names_nod_var = ncread('01_flow_channel_01_out.e','name_nod_var');