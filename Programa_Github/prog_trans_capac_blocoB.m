close all; clc; clear;

BHL = [0.14, 0.19, 0.29];
ees = [1.0e-2, 2.0e-2, 1e-2]; % [e1, e2,  e]

kcp_blk = [1.00, 0.92, 1800]; % [k, ce, p]
kcp_rv1 = [1.15, 1.00, 1800];
kcp_rv2 = [1.15, 1.00, 1800];
kcp_arg = [1.15, 1.00, 1800];

Lvet = [0.02, 0.1, 0.02, 0.011, 0.02, 0.1, 0.02];

Bmat = zeros(7,5);
Bmat(1,1)   =  BHL(1);
Bmat(2,1:3)   = [ 0.02, 0.1, 0.02];
Bmat(3,1)   =  BHL(1);
Bmat(4,:) = [0.02, 0.04, 0.02, 0.04, 0.02];
Bmat(5,1)   =  BHL(1);
Bmat(6,1:3)   = [ 0.02, 0.1, 0.02];
Bmat(7,1)   =  BHL(1);

nome = 'BlocoB';

[area_brut,area_liq,ratio_area,UT_block,CT_block,...
 UT_block_rv,CT_block_rv,UT_prism,CT_prism,UT_wall,CT_wall] = ...
   fun_UC_NBR15220(BHL,ees,kcp_blk,kcp_rv1,kcp_rv2,kcp_arg,Lvet,Bmat,nome);

k = (BHL(1) + ees(1) + ees(2))*UT_prism
ce = CT_prism/((BHL(1) + ees(1) + ees(2))*kcp_blk(3))
p = ((area_brut-area_liq)*1.164 + area_liq*1800)/area_brut