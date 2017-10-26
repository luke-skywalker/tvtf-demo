% Goes with synchronousDemodulationDemo.m.
% tvtf stands for time varying transfer function.
% Just a quick demo! This means poorly written and poorly
% documented on purpose by Luca (manzari@kth.se) on 2017-10-26.

function tvtf (m, ref)

    % reference signal
    f = ref.frequency;
    T = ref.period;
    spc = ref.samples_per_cycle;
    dt = ref.time_resolution;
    cycles = ref.cycles;
    t = ref.time_vector;
    N = length(t);
    r = ref.signal;

    % window size for the moving average filter
    windowSize = spc / 2;

    % computing the projection
    p = m ./ hilbert (r);

    % moving average filter with a time window that is half the length of the period of the excitation
    b = (1/windowSize) * ones (1,windowSize);
    a = 1;
    h = 2 * filter (b, a, p);

    % computing average per-cycle transfer functions
    tf = zeros (1, cycles-1);
    for ii = 2:cycles
        start_idx = (ii-1) * N / cycles + 1;
        end_idx = (ii) * N / cycles;
        tf(ii-1) = mean (h(start_idx:end_idx));
    end

    hold on
    % full transfer function
    plot (t, r, 'b--')
    plot (t, m, 'b')
    plot (t, abs (h), 'k')
    plot (t, angle (h), 'r')

    % per-cycle values
    for ii = 2:cycles
        start_idx = (ii-1) * N / cycles + 1;
        x = t(start_idx + windowSize);
        y_abs = abs (tf(ii-1));
        y_angle = angle (tf(ii-1));
        plot (x, y_abs, 'kx')
        plot (x, y_angle, 'rx')
    end
    hold off

    xlabel ('Time [s]')
    legend ({'reference', 'measurement', 'abs (TF)', 'angle (TF)', 'abs (TF)', 'angle (TF)'})

end
