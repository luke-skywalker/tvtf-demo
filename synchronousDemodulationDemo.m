% A simple demo to show how the Hilbert transform can be used
% instead of the Fourier transform to obtain time-dependant
% transfer functions.
%
% References:
% * Feldman, Hilbert Transform Applications in Mechanical Vibration
%   ISBN: 978-0-470-97827-6
% * Peerlings, Assessing precision and accuracy in acoustic
%              scarttering matrix measurements
%   ISBN: 978-91-7729-410-8
%
% Super-quickly written by Luca (manzari@kth.se) on 2017-10-26.
% Runs on both GNU Octave and Matlab, needs tvft.m.

% if on GNU Octave, load the signal package
v = version;
if str2num (v(1)) < 5
    pkg load signal
end

% generating a reference signal
ref.frequency = 8;
ref.period = 1 / ref.frequency;
ref.samples_per_cycle = 64;
ref.time_resolution = ref.period / ref.samples_per_cycle;
ref.cycles = 100;
ref.time_vector = 0:ref.time_resolution: ...
    (ref.samples_per_cycle*ref.cycles-1)*ref.time_resolution;
ref.N = length(ref.time_vector);
ref.signal = cos (2 * pi * ref.frequency * ref.time_vector);

%------------%
%-- CASE 1 --%
%------------%

% test 1: the measured signal is exactly the same as the reference
m1 = ref.signal;
figure(1)
tvtf (m1, ref);

%------------%
%-- CASE 2 --%
%------------%

% test 2: the amplitude of the measured signal increases with time
m2 = ref.signal .* linspace (1, 2, ref.N);
figure(2)
tvtf (m2, ref);


%------------%
%-- CASE 3 --%
%------------%

% test 3: twice the amplitude and shifted phase
m3 = 2 * cos (2 * pi * ref.frequency * ref.time_vector + 0.5 * pi);
figure(3)
tvtf (m3, ref);

%------------%
%-- CASE 4 --%
%------------%

% measured signal 3: twice the amplitude and changing frequency
m4 = 2 * chirp (ref.time_vector, ...
                ref.frequency, ...
                ref.time_vector(end), ...
                ref.frequency * 1.1);
figure(4)
tvtf (m4, ref);
