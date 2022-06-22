close all; clc; clear;

BHL = [0.14, 0.19, 0.29];
ees = [1.0e-2, 2.0e-2, 1e-2]; % [e1, e2,  e]

kcp_blk = [1.00, 0.92, 1800]; % [k, ce, p]
kcp_rv1 = [1.15, 1.00, 1800];
kcp_rv2 = [1.15, 1.00, 1800];
kcp_arg = [1.15, 1.00, 1800];

Lvet = [0.012, 0.0204 0.006, 0.031, 0.006, 0.031, 0.006, 0.0296, 0.003];
Bmat = zeros(7,9);
Bmat(1,1)   =  BHL(1);
Bmat(2,:)   = [ 0.012, 0.0180, 0.006, 0.031, 0.006, 0.031, 0.006, 0.018, 0.012];
Bmat(3,1)   =  BHL(1);
Bmat(4,1:7) = [0.012, 0.0180, 0.006, 0.068, 0.006, 0.0180, 0.012];
Bmat(5,1:3) = [(0.012 + 0.018 + 0.006), 0.068, (0.012 + 0.018 + 0.006)];
Bmat(6,1:7) = [0.012, 0.0180, 0.006, 0.068, 0.006, 0.0180, 0.012];
Bmat(7,1)   =  BHL(1);
Bmat(8,1:7) = [0.012, 0.033, 0.006, 0.038, 0.006, 0.033, 0.012];
Bmat(9,1:3) = [(0.012+0.033+0.006), 0.038, (0.012+0.033+0.006)]; 

Lvet = [Lvet, Lvet(end:-1:1)];
Bmat = [Bmat; Bmat(end:-1:1,:)];

nome = 'BlocoA';

[area_brut,area_liq,ratio_area,UT_block,CT_block,...
 UT_block_rv,CT_block_rv,UT_prism,CT_prism,UT_wall,CT_wall] = ...
   fun_UC_NBR15220(BHL,ees,kcp_blk,kcp_rv1,kcp_rv2,kcp_arg,Lvet,Bmat,nome);

k = (BHL(1) + ees(1) + ees(2))*UT_prism
ce = CT_prism/((BHL(1) + ees(1) + ees(2))*kcp_blk(3))
p = ((area_brut-area_liq)*1.164 + area_liq*1800)/area_brut