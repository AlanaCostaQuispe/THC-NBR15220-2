close all; clc; clear;

B =	0.14;
H = 0.19;
L = 0.29;
B1 = 0.025;
B2 = 0.035;
B3 = 0.02;
L1 = 0.025;
L2 = 0.0945;
L3 = 0.02;
L4 = 0.011;

e1 = 2.5e-2;
e2 = 2.0e-2;
e  = 1e-2;

k_rv1 = 1.15; ce_rv1 = 1.00; p_rv1 = 1800;
k_cer = 1.00; ce_cer = 0.92; p_cer = 1800;
k_rv2 = 1.15; ce_rv2 = 1.00; p_rv2 = 1800;
k_arg = 1.15; ce_arg = 1.00; p_arg = 1800;

Lvet = [L1, L2, L3, L4, L3, L2, L1];
Bmat = [  B,         0,  0,  0,  0
         B1, (2*B2+B3), B1,  0,  0
          B,         0,  0,  0,  0
         B1,        B2, B3, B2, B1
          B,         0,  0,  0,  0
         B1, (2*B2+B3), B1,  0,  0
          B,         0,  0,  0,  0 ];

figure()
hold on;
c = [0.9290 0.6940 0.1250]; 
fill([0 L L 0],[0 0 B B],c)      

Avet = H*Lvet;
RTvet = zeros(1,length(Lvet));
CTvet = zeros(1,length(Lvet));
for ii = 1:size(Bmat,1)
    RT = 0;
    CT = 0;
    for jj = 1:size(Bmat,2)
        val = Bmat(ii,jj);
        if val && rem(jj,2) 
            RT = RT + val/k_cer;
            CT = CT + val*ce_cer*p_cer; 
        end    
        if val && ~rem(jj,2)
            dl = Lvet(ii);
            db = Bmat(ii,jj);
            L0 = sum(Lvet(1:ii-1));
            B0 = sum(Bmat(ii,1:jj-1));
            fill([L0 L0+dl L0+dl L0],[B0 B0 B0+db B0+db],'w')
            if val>=1e-2 && val<=2e-2
                RT = RT + 0.14;
            end
            if val>2e-2 && val<=5e-2
                RT = RT + 0.16;
            end
            if val>5e-2
                RT = RT + 0.17;
            end
        end
    end
    RTvet(ii) = RT;
    CTvet(ii) = CT;
end

%% BLOCK %%

RT_block = sum(Avet)/sum(Avet./RTvet);
UT_block = 1/(RT_block + 0.13 + 0.04);
CT_block = sum(Avet)/sum(Avet./CTvet);
      
%% BLOCK w/ REV %%

RT_block_rev = e1/k_rv1 + RT_block + e2/k_rv2 + 0.13 + 0.04;
UT_block_rev = 1/RT_block_rev;

CT_block_rev = e1*ce_rv1*p_rv1 + CT_block + e2*ce_rv2*p_rv2;

%% PRISM %%

SA = L*e;
SB = L*H;

RTA = e1/k_rv1 + B/k_arg + e2/k_rv2;
RTB = e1/k_rv1 + RT_block + e2/k_rv2;

RT_prism = (SA + 2*SB)/(SA/RTA + 2*SB/RTB) + 0.13 + 0.04;
UT_prism = 1/RT_prism;

CTA = e1*ce_rv1*p_rv1 + B*ce_arg*p_arg + e2*ce_rv2*p_rv2;
CTB = e1*ce_rv1*p_rv1 + CT_block + e2*ce_rv2*p_rv2;

CT_prism = (SA + 2*SB)/(SA/CTA + 2*SB/CTB);

%% WALL %%

SA = L*e + (H + e)*e;
SB = L*H;

% RTA = e1/k_rv1 + B/k_arg + e2/k_rv2;
% RTB = e1/k_rv1 + RT_block + e2/k_rv2;

RT_wall = (SA + SB)/(SA/RTA + SB/RTB) + 0.13 + 0.04;
UT_wall = 1/RT_wall;

% CTA = e1*ce_rv1*p_rv1 + B*ce_arg*p_arg + e2*ce_rv2*p_rv2;
% CTB = e1*ce_rv1*p_rv1 + CT_block + e2*ce_rv2*p_rv2;

CT_wall = (SA + SB)/(SA/CTA + SB/CTB);

fprintf('          Bloco: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_block,CT_block);
fprintf('Bloco Revestido: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_block_rev,CT_block_rev);
fprintf('         Prisma: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_prism,CT_prism);
fprintf('         Parede: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_wall,CT_wall);
