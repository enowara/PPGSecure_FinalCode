function     [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGL, PPGR, PPGF, PPGA, PPGB)           

                L = length((1:LL));
                % make the PPG the same length
                YL = fft(mean(PPGL,2));
                P2L = abs(YL/L); % take the magnitude
                PL = P2L(1:floor(L/2+1));
                PL(2:end-1) = 2*PL(2:end-1);

                YR = fft(mean(PPGR,2));
                P2R = abs(YR/L); % take the magnitude
                PR = P2R(1:floor(L/2+1));
                PR(2:end-1) = 2*PR(2:end-1);

                YF = fft(mean(PPGF,2));
                P2F = abs(YF/L); % take the magnitude
                PF = P2F(1:floor(L/2+1));
                PF(2:end-1) = 2*PF(2:end-1);
                
                YA = fft(mean(PPGA,2));
                P2A = abs(YA/L); % take the magnitude
                PA = P2A(1:floor(L/2+1));
                PA(2:end-1) = 2*PA(2:end-1);
                
                YB = fft(mean(PPGB,2));
                P2B = abs(YB/L); % take the magnitude
                PB = P2B(1:floor(L/2+1));
                PB(2:end-1) = 2*PB(2:end-1);
                 
                
end