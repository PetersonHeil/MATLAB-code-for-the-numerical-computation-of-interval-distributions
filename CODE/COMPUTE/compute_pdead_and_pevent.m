function [pdead, pevent] = compute_pdead_and_pevent(t, pdetection, Sdead)

    % Use conv() to compute pdead
    pdead = conv(pdetection,Sdead,'full');
    pdead(pdead>1) = 1;
    pdead = [0 pdead(1:numel(t)-1)];

%     % Equivalent (FFT-based convolution, similar to conv() in speed)
%     x = pdetection;
%     y = Sdead;
%     X = fft([x zeros(1,length(y)-1)]);
%     Y = fft([y zeros(1,length(x)-1)]);
%     pdead = ifft(X.*Y);
%     pdead = [0 min(pdead(1:numel(x)-1), 1)];
    
%     % Equivalent (slower than conv() when number of points is large)
%     pdead = zeros(size(t));
%     for i=2:numel(t)
%         h = 1:i-1;
%         pdead(i) = sum(pdetection(h).*Sdead(i-h));
%     end
%     pdead = min(pdead, 1);

    % Compute pevent
    pevent = pdetection./(1-pdead);
    
    % Replace NaNs by zero (they arise when pdead is 1, which can happen when pdetection is 1 and the dead time has a positive minimum duration)
    pevent(isnan(pevent)) = 0;
    
    % Check that resulting pevent is valid (not less than pdetection or greater than 1)
    if any(pevent < pdetection)
        error('Dead-time parameters are not viable and would result in some points having pevent < pdetection, which is not reasonable.')
    end
    if any(pevent > 1)
        error('The parameters provided would result in some points having pevent > 1. Decrease the time step, the mean rate, or the mean duration of the dead time.')
    end

end
