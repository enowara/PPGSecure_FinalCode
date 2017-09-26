function     [PL, PR, PF] = fftFunction(LL, PPGL, PPGR, PPGF)           

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
                
              
                 
                
end