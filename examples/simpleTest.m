%% Taser Simple 2D Forearm
% by Leonard Spiering 07.12.2019 
% 20microsec puls -> frequency of 50kHz 
% PeakVoltage of 500kV
% Material Parameter: dry Skin (thickness?!)
%                       Nerves completely ignored. 
%https://itis.swiss/virtual-population/tissue-properties/database/dielectric-properties/
close all;
clear all; 

%% Defining Variables
PotentialLeft = 0; %[V]
PotentialRight = 1; %[V]

%% Importing the Geometry
fileLeg = [pwd,'\geometry\Simple2D']; 

mesh = Geometry(); 
mesh.load_from_msh(fileLeg);

%% Choose function Space
element = P1Element(mesh); 

%% Setting up the Model Problem 
% electro quasi steady:
Voltkappa = Physical_Problem(element, mesh, 1,0,0);
Voltepsilon = Physical_Problem(element, mesh, 1,0,0);
%% Boundary Condition
leftElectrode = DirichletBC(PotentialLeft, 'leftElectrode', mesh); 
rightElectrode = DirichletBC(PotentialRight, 'rightElectrode', mesh); 

Voltkappa.setBoundaryCondition(leftElectrode);
Voltkappa.setBoundaryCondition(rightElectrode);
Voltepsilon.setBoundaryCondition(leftElectrode);
Voltepsilon.setBoundaryCondition(rightElectrode);
%% Setting up the Material

e0 = 8.8541878176E-12;
skin = Material(); 
skin.epsilon = 1.13E+3*e0; 
skin.kappa =2.73E-4; 

muscle = Material(); 
muscle.epsilon =1.01E+4*e0; 
muscle.kappa = 3.52E-1; 

bone = Material(); % Parameter of Cortical bone
bone.epsilon =2.64E+2*e0;
bone.kappa =2.06E-2; 

fat = Material();
fat.epsilon =1.63E+2*e0; 
fat.kappa =4.33E-2; 

blood = Material();
blood.epsilon = 5.20E+3*e0;
blood.kappa = 7.01E-1; 

dt = 1e-3; 
% mesh.setMaterial(blood)  // steckt das mat zum part
%Voltkappa.setParaS('kappa');
mesh.setMaterial('skin',fat);
% mesh.setMaterial('muscle',muscle);
% mesh.setMaterial('bone',bone);
mesh.setMaterial('fat',muscle);

Voltkappa.setParaS('kappa');
Voltepsilon.setParaS('epsilon');

%% Assembly of the matrices
Voltkappa.assemble(); 
Voltepsilon.assemble();

%% Test- Solving as Elliptic Problem
u_init= Initial_Condition(0);
u_i = zeros(mesh.Nco,1);
u_i(Voltepsilon.dof) = u_init.value;  %Maximum variable size allowed by the program is exceeded.
n = 500;

A = Voltkappa.S + Voltepsilon.S/dt;
%A = Voltkappa.S;

L = ichol(A(Voltepsilon.dof,Voltepsilon.dof));
b_diri = zeros(mesh.Nco,1);
u_diri = zeros(mesh.Nco,1);

% Testing if the puls makes problems: 
% Only epsilon + Constant pulse + simplesolver

%Checking if Matrix is positive def. 
% eig_A = eig(A); 
% flag = 0;
% for i = 1:rank(A)
%   if eig_A(i) <= 0 
%   flag = 1;
%   end
% end
% if flag == 1
%   disp('the matrix is not positive definite')
%   else
%   disp('the matrix is positive definite')
% end
% --> Matrix is not sym and not skew sym. 
% ***********Matrix is not Positive definite******************

% for i =1:n+1
%     u_imin1 = u_i;
% 	u_diri(leftElectrode.boundary) = pulse(i*dt);
% 	u_i = u_diri;
% 	b_diri = A*u_diri;
%     b = -b_diri + Voltepsilon.S/dt*u_imin1;  % ./ !?
%     u_i(Voltepsilon.dof) = A(Voltepsilon.dof,Voltepsilon.dof)\b(Voltepsilon.dof);
%     %u_i(Voltepsilon.dof) = cgs(A(Voltepsilon.dof,Voltepsilon.dof),b(Voltepsilon.dof),1e-7,1000,L,L');
%     
% 	mesh.export_UCD([pwd, '/exportTest'],['exportBackslash',num2str(i-1)], {'u', u_i, ''});
%     
% end
% 
% u_i = zeros(mesh.Nco,1);
% u_i(Voltepsilon.dof) = u_init.value;  %Maximum variable size allowed by the program is exceeded.
% b_diri = zeros(mesh.Nco,1);
% u_diri = zeros(mesh.Nco,1);

kappa = matrixarray(zeros(1,1,size(mesh.el,1)));
kappa(mesh.parts{3,1}) = fat.kappa;
kappa(mesh.parts{3,2}) = muscle.kappa;
u_idir1 = zeros(mesh.Nco,1);


for i =1:n+1
    u_imin1 = u_i;
	u_diri(leftElectrode.boundary) = pulse(i*dt);
	u_i = u_diri;
	u_idir1(leftElectrode.boundary) = u_i(leftElectrode.boundary);
	b_diri = A*u_diri;
    b = -b_diri - Voltepsilon.S*u_idir1/dt + Voltepsilon.S/dt*u_imin1;  % ./ !?
    u_i(Voltepsilon.dof) = bicgstab(A(Voltepsilon.dof,Voltepsilon.dof),b(Voltepsilon.dof),1e-7,1000,L,L');
	E = -Voltkappa.gradCell(u_i);
	E(3,:,:) = 0;
	Eexp = reshape(E,3,[])';
	J = E*kappa;
	Jexp = reshape(J,3,[])';
    %u_i(Voltepsilon.dof) = cgs(A(Voltepsilon.dof,Voltepsilon.dof),b(Voltepsilon.dof),1e-7,1000,L,L');
    
	mesh.export_UCD([pwd, '/exportTest'],['exportCGS',num2str(i-1)], {'u', u_i, ''},{'E',Eexp,'','Cell'},{'J',Jexp,'','Cell'});
    
end
% Constant pulse
% for i =1:n+1
%     u_imin1 = u_i;
% 	b_diri(leftElectrode.boundary) = 5;
% 	u_i = b_diri;
% 	b_diri = A*b_diri;
%     b = -b_diri+Voltepsilon.S/dt * u_imin1;  % ./ !?
%     u_i(Voltepsilon.dof) = cgs(A(Voltepsilon.dof,Voltepsilon.dof),b(Voltepsilon.dof),1e-7,1000,L,L');
%     
% 	mesh.export_UCD([pwd, '/exportLeg'],['exportSimple2DepsilonConstPulse5',num2str(i-1)], {'u', u_i, ''});
%     
% end
% 
% u_i = zeros(mesh.Nco,1);
% u_i(Voltepsilon.dof) = u_init.value;  %Maximum variable size allowed by the program is exceeded.
% 
% % Only Epsilon
% for i =1:n+1
%     u_imin1 = u_i;
% 	b_diri(leftElectrode.boundary) = pulse(i*dt);
% 	u_i = b_diri;
% 	b_diri = A*b_diri;
%     b = -b_diri+Voltepsilon.S/dt * u_imin1;  % ./ !?
%     u_i(Voltepsilon.dof) = cgs(A(Voltepsilon.dof,Voltepsilon.dof),b(Voltepsilon.dof),1e-7,1000,L,L');
%     
% 	mesh.export_UCD([pwd, '/exportLeg'],['exportSimple2Depsilon',num2str(i-1)], {'u', u_i, ''});
%     
% end
