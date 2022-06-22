function [area_brut,area_liq,ratio_area,UT_block,CT_block,...
          UT_block_rv,CT_block_rv,UT_prism,CT_prism,UT_wall,CT_wall] = ...
    fun_UC_NBR15220(BHL,ees,kcp_blk,kcp_rv1,kcp_rv2,kcp_arg,Lvet,Bmat,nome)

B = BHL(1); 
H = BHL(2); 
L = BHL(3);

e1 = ees(1);
e2 = ees(2);
 e = ees(3);
 
k_rv1 = kcp_rv1(1); ce_rv1 = kcp_rv1(2); p_rv1 = kcp_rv1(3);
k_rv2 = kcp_rv2(1); ce_rv2 = kcp_rv2(2); p_rv2 = kcp_rv2(3);
k_arg = kcp_arg(1); ce_arg = kcp_arg(2); p_arg = kcp_arg(3);
k_blk = kcp_blk(1); ce_blk = kcp_blk(2); p_blk = kcp_blk(3);

fig = figure();
hold on;
c = [0.9290 0.6940 0.1250]; 
fill([0 L L 0],[0 0 B B],c)      

Avet = H*Lvet;
RTvet = zeros(1,length(Lvet));
CTvet = zeros(1,length(Lvet));
area_vaz = 0;
for ii = 1:size(Bmat,1)
    RT = 0;
    CT = 0;
    for jj = 1:size(Bmat,2)
        val = Bmat(ii,jj);
        if val && rem(jj,2) 
            RT = RT + val/k_blk;
            CT = CT + val*ce_blk*p_blk; 
        end    
        if val && ~rem(jj,2)
            dl = Lvet(ii);
            db = Bmat(ii,jj);
            area_vaz = area_vaz + dl*db;
            L0 = sum(Lvet(1:ii-1));
            B0 = sum(Bmat(ii,1:jj-1));
            fill([L0 L0+dl L0+dl L0],[B0 B0 B0+db B0+db],'w')
            value = rt_ar(val);
            RT = RT + value;
%             if val>=1e-2 && val<=2e-2
%                 RT = RT + 0.14;
%             end
%             if val>2e-2 && val<=5e-2
%                 RT = RT + 0.16;
%             end
%             if val>5e-2
%                 RT = RT + 0.17;
%             end
        end
    end
    RTvet(ii) = RT;
    CTvet(ii) = CT;
end

fill([0 L L 0],[-e1 -e1 0 0],[0.5 0.5 0.5]);
fill([0 L L 0],[B B B+e2 B+e2],[0.5 0.5 0.5]);

axis equal;
axis off;
set(fig, 'Color', 'w');
nome_fig = strcat('Figuras/',nome,'.png');
export_fig(nome_fig,'-m3');
%% BLOCK %%

RT_block = sum(Avet)/sum(Avet./RTvet);
UT_block = 1/(RT_block + 0.13 + 0.04);
CT_block = sum(Avet)/sum(Avet./CTvet);
      
%% BLOCK w/ REV %%

RT_block_rv = e1/k_rv1 + RT_block + e2/k_rv2 + 0.13 + 0.04;
UT_block_rv = 1/RT_block_rv;

CT_block_rv = e1*ce_rv1*p_rv1 + CT_block + e2*ce_rv2*p_rv2;

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

RT_wall = (SA + SB)/(SA/RTA + SB/RTB) + 0.13 + 0.04;
UT_wall = 1/RT_wall;

CT_wall = (SA + SB)/(SA/CTA + SB/CTB);

area_brut = B*L;
area_liq = B*L-area_vaz;
ratio_area = area_liq/area_brut;
fprintf(' ===================================================================== \n')
fprintf(' Nome: %s \n',nome)
fprintf(' --------------------------------------------------------------------- \n')
fprintf(' Áreas: Bruta [cm2] = %6.3f, Líquida [cm2] = %6.3f (Al/Ab = %6.3f) \n',area_brut*1e4,area_liq*1e4,ratio_area);
fprintf(' ===================================================================== \n')
fprintf('          Bloco: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_block,CT_block);
fprintf('Bloco Revestido: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_block_rv,CT_block_rv);
fprintf('         Prisma: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_prism,CT_prism);
fprintf('         Parede: UT [W/(m2K)] = %6.3f, CT [kJ/(m2K)] = %6.3f \n',UT_wall,CT_wall);
fprintf(' ===================================================================== \n')
end