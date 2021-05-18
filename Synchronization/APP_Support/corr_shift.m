function [shift_amount,signals_shifted] = corr_shift(ref_signal,signals_to_sync, int_start, int_end, method)
%CORR_SHIFT Performs cross-correlation time shift of signals with respect
%to reference signal in either time or frequency domain. NO MISSING VALUES
%ALLOWED!
%
%   [shift_amount,signals_shifted] = corr_shift(ref_signal,signals_to_sync, int_start, int_end, method)
%
% Created by Ryan Alcantara | ryan.alcantara@colorado.edu 
%
% Last Modified: 09/2019 by Ryan Alcantara
%
%   INPUTS:
%   ref_signal:         Column vector (1 x n) to match `signals_to_sync` to.
%   signals_to_sync:    Column vector (m x n) to match to `ref_signal`.
%   int_start:          Integer. Start of interval to calculate time shift.
%   int_end:            Integer. End of interval to calculate time shift.
%   method:             String. 'f' to calculate cross-correlation in
%                       frequency domain, 't' to calculate cross-correlation 
%                       in time domain. 'f' is default.
%
%   OUTPUTS:
%   shift_amount:       Number of frames shifted relative to [ref_signal].
%   signals_shifted:    time-shifted signals. same size as `signals_to_sync`.
%
%   MORE INFO ON CROSS CORRELATION & FREQUENCY DOMAIN:
%   https://dsp.stackexchange.com/questions/736/how-do-i-implement-cross-correlation-to-prove-two-audio-files-are-similar
%   https://anomaly.io/understand-auto-cross-correlation-normalized-shift/index.html
%   https://www.mathworks.com/matlabcentral/fileexchange/29359-icoshift-interval-correlation-optimized-shifting-for-matlab-v-2014b-and-above
%

if nargin <5
    method = 'f'; %frequency domain default
end
interval = (int_start:int_end)';
%slice where cross correlation is to be calculated
sync_slice = signals_to_sync(interval,:);
ref_slice = ref_signal(interval,:);

n = length(interval) - 1; %max shift range?

% can't have NaNs in signal interval!
%remove nans somehow if present in interval. I think it could just trim
%leading/trailing nans but can't handle them in the middle.

if method == 'f'
    %normalize signals
    signals_norm = sqrt(sum(sync_slice.^2, 1, 'omitnan'));
    reference_norm = sqrt(sum(ref_slice.^2, 1, 'omitnan'));
    %remove any zeros
    signals_norm(signals_norm == 0) = 1;
    reference_norm(reference_norm == 0) = 1;
    %normalize
    sync_slice_norm = sync_slice./signals_norm; % not technically fft yet...
    ref_slice_norm = ref_slice./reference_norm;
%try another way of normalizing signal
%     sync_slice_norm = (sync_slice - mean(sync_slice))./std(sync_slice);
%     ref_slice_norm = (ref_slice - mean(ref_slice))./std(ref_slice);
    
    % pad signal with zeros. see links in function description.
    pad = max(abs(-n:n));
    
    %calculate cross-correlation of FFT
    len_fft = max(length(ref_slice_norm), length(sync_slice_norm)) + pad;
    shift = [-n:n]'; %range of possible shift (frames)
    
    if -n < 0 && n > 0
        indx = [len_fft+(-n)+1:len_fft, 1:n+1]';
    else %other possibilities
    end
    
    % correlation requires one input to be reversed.
    signals_fft = fft(sync_slice_norm, len_fft, 1); %freq domain
    reference_fft = fft(ref_slice_norm, len_fft, 1); %freq domain
    reference_fft = conj(reference_fft); %complex conjugation in freq domain
    cc = ifft(signals_fft.*reference_fft, len_fft, 1);
    cc = cc(indx,:); %reshapes it so that ends are connected. cuz it's kind of a loop
    cc = max(cc,-Inf); %see if we get some infinity values
    [~,pos] = max(cc, [], 1); %where does max cross correlation occur
    %     values = cat(2,shift, cc);
    shift_amount = shift(pos);
    
elseif method == 't'
    %% try cross correlation in time domain
    shift = [-n:n]'; %range of possible shift (frames)
    
    for i = 1:size(sync_slice,2)
        cc(:,i) = xcorr(ref_slice, sync_slice(:,i));
    end
    
    [~,pos] = max(cc, [], 1);
    shift_amount = shift(pos)*-1;
end
%% now let's apply the shift to the signals and align them
%initialize
signals_shifted = NaN([size(signals_to_sync,2), size(ref_signal,1)])';
[ind_orig, ind_shift] = deal(repmat({':'}, ndims(signals_to_sync),1));

for i = 1:size(signals_to_sync,2)
    ind_orig{2} = i;
    ind_shift{2} = i;
    if shift_amount(i) >= 0
        
        ind_orig{1} = shift_amount(i) + 1:length(signals_to_sync);
        ind_shift{1} = 1:(length(signals_to_sync) - shift_amount(i));
    elseif shift_amount(i) < 0
        ind_orig{1} = 1:(length(signals_to_sync) + shift_amount(i));
        ind_shift{1} = -shift_amount(i) + 1:length(signals_to_sync);
    end
    
    signals_shifted(ind_shift{:}) = signals_to_sync(ind_orig{:}); % nan padded on both ends
end

%% plot it
% close all
% figure
% subplot(3,1,1)
% plot(sync_slice')
% grid on
% title('before')
%
% subplot(3,1,2)
% plot(signals_shifted')
% grid on
% title('time domain xcorr')
%
% subplot(3,1,3)
% plot(signals_shifted')
% grid on
% title('freq domain xcorr')
%
% linkaxes
end