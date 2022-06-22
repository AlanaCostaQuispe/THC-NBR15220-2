close all; clc; clear;

BHL = [0.10, 0.32, 0.16];
ees = [2e-2, 2e-2, 1e-2];

kcp_blk = [0.90, 0.92, 1600]; % [k, ce, p]
kcp_rv1 = [1.15, 1.00, 2000];
kcp_rv2 = [1.15, 1.00, 2000];
kcp_arg = [1.15, 1.00, 2000];

Lvet = [1, 4, 1, 4, 1, 4, 1]*1e-2;

Bmat = zeros(7,5);
Bmat(1,1)   =  BHL(1);
Bmat(2,1:5)   = [1.5, 3, 1, 3, 1.5]*1e-2;
Bmat(3,1)   =  BHL(1);
Bmat(4,1:5) = [1.5, 3, 1, 3, 1.5]*1e-2;
Bmat(5,1)   =  BHL(1);
Bmat(6,1:5) = [1.5, 3, 1, 3, 1.5]*1e-2;
Bmat(7,1)   =  BHL(1);

nome = 'Exemplo_3_norma';

[area_brut,area_liq,ratio_area,UT_block,CT_block,...
 UT_block_rv,CT_block_rv,UT_prism,CT_prism,UT_wall,CT_wall] = ...
   fun_UC_NBR15220(BHL,ees,kcp_blk,kcp_rv1,kcp_rv2,kcp_arg,Lvet,Bmat,nome);