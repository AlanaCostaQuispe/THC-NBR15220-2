close all; clc; clear;

BHL = [0.09, 0.19, 0.39]; % [B,   H,  L]
ees = [0e-2, 0e-2, 0e-2]; % [e1, e2,  e]

kcp_blk = [1.75, 1.00, 2400]; % [k, ce, p]
kcp_rv1 = [1.15, 1.00, 1800];
kcp_rv2 = [1.15, 1.00, 1800];
kcp_arg = [1.15, 1.00, 1800];

Lvet = [2, 16.5, 2, 16.5, 2]*1e-2;

Bmat = zeros(5,3);
Bmat(1,1)   =  BHL(1);
Bmat(2,1:3)   = [2, 5, 2]*1e-2;
Bmat(3,1)   =  BHL(1);
Bmat(4,:) = [2, 5, 2]*1e-2;
Bmat(5,1)   =  BHL(1);

nome = 'Exemplo_2_norma';

[area_brut,area_liq,ratio_area,UT_block,CT_block,...
 UT_block_rv,CT_block_rv,UT_prism,CT_prism,UT_wall,CT_wall] = ...
   fun_UC_NBR15220(BHL,ees,kcp_blk,kcp_rv1,kcp_rv2,kcp_arg,Lvet,Bmat,nome);