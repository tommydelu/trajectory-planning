%% POINT TO POINT TRAJECTORIES USING POLYNOMIALS OF ORDER 3, 5 AND 7

clear; close all; clc;

RGB = orderedcolors("gem");         % Plots palette
H = rgb2hex(RGB);

save_fig = false;
fig_name = "1";

options = ["absolute", "relative"]; % absolute: the reference is the starting time of the system/simulation
                                    % relative: the reference is the starting time of the trajcetory

Fs = 100;                           % Sampling frequency for time-vector
ti = 100; tf = 105;                    % Define initial and final time of the trajectory
qi = 0; qf = 10;                    % Initial and final position (used by third, fifth, seventh order polynomials)
qi_d = 0; qf_d = 0;                 % Initial and final velocity (used by third, fifth, seventh order polynomials)
qi_dd = 0; qf_dd = 0;               % Initial and final acceleration (used by fifth, seventh order polynomials)
qi_ddd = 0; qf_ddd = 0;             % Initial and final jerk (used by seventh order polynomial)

dT = tf - ti;                       % This will be used in the relative mode, when evaluating the equations in t = tf

% Checking feasibility of ti & tf
if (ti < 0 | tf < 0 | tf <= ti) 
    error('ti and tf must be greater than 0. And tf must be strictly greater than ti.');
else
    fprintf("-------------------------------------------------\n" + ...
            "SUMMARY OF THE VALUES OF THE VARIABLES\n" + ...
            "-------------------------------------------------\n" + ...
            "Sampling frequency: %g\n" + ...
            "Options used in the code: absolute and relative\n" + ...  
            "Initial anf final time: %g, %g [s]\n" + ...
            "Initial and final position: %g, %g [rad]\n" + ...
            "Initial and final velocity: %g, %g [rad/s]\n" + ...
            "Initial and final acceleration: %g, %g [rad/s^2]\n" + ...
            "Initial and final jerk: %g, %g [rad/s^3]\n" + ...
            "-------------------------------------------------\n\n", Fs, ti, tf, qi, qf, qi_d, qf_d, qi_dd, qf_dd, qi_ddd, qf_ddd);
end

%-------------------------------------------------------------------------------------------------------------------------------%

time_vector = linspace(ti, tf, round((tf-ti)*Fs) + 1);

% Cycle on options to produce a combined plot
for o = 1:length(options) 

    mod_opt = options(o);
    fprintf("STARTING COMPUTATION FOR OPTION - %s -\n", upper(mod_opt))

    % Polynomial coefficients
    if mod_opt == "relative"
        coeffs_3 = poly_coeffs(3, 0, dT, [qi qi_d], [qf qf_d]);
        coeffs_5 = poly_coeffs(5, 0, dT, [qi qi_d qi_dd], [qf qf_d qf_dd]);
        coeffs_7 = poly_coeffs(7, 0, dT, [qi qi_d qi_dd qi_ddd], [qf qf_d qf_dd qf_ddd]);
        relative_coeffs{1} = coeffs_3; relative_coeffs{2} = coeffs_5; relative_coeffs{3} = coeffs_7;
    else
        coeffs_3 = poly_coeffs(3, ti, tf, [qi qi_d], [qf qf_d]);
        coeffs_5 = poly_coeffs(5, ti, tf, [qi qi_d qi_dd], [qf qf_d qf_dd]);
        coeffs_7 = poly_coeffs(7, ti, tf, [qi qi_d qi_dd qi_ddd], [qf qf_d qf_dd qf_ddd]);
        abs_coeffs{1} = coeffs_3; abs_coeffs{2} = coeffs_5; abs_coeffs{3} = coeffs_7;
    end

    fprintf("coeffs_3 - %s: [%.2f %.2f %.2f %.2f]\n",mod_opt,coeffs_3(1),coeffs_3(2),coeffs_3(3),coeffs_3(4))
    fprintf("coeffs_5 - %s: [%.2f %.2f %.2f %.2f %.2f %.2f]\n",mod_opt,coeffs_5(1),coeffs_5(2),coeffs_5(3),coeffs_5(4),coeffs_5(5),coeffs_5(6))
    fprintf("coeffs_7 - %s: [%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f]\n\n",mod_opt,coeffs_7(1),coeffs_7(2),coeffs_7(3),coeffs_7(4),coeffs_7(5),coeffs_7(6),coeffs_7(7),coeffs_7(8))
    
    % polyder(coeffs) returns the derivative of the polynomial represented by the coefficients in coeffs
    coeffs_3_d   = polyder(coeffs_3);    
    coeffs_3_dd  = polyder(coeffs_3_d);
    coeffs_3_ddd = polyder(coeffs_3_dd);

    coeffs_5_d   = polyder(coeffs_5); 
    coeffs_5_dd  = polyder(coeffs_5_d); 
    coeffs_5_ddd = polyder(coeffs_5_dd);

    coeffs_7_d   = polyder(coeffs_7); 
    coeffs_7_dd  = polyder(coeffs_7_d); 
    coeffs_7_ddd = polyder(coeffs_7_dd);

    if mod_opt == "relative"
        eval_time = time_vector - ti; % Remember to evaluate in t-ti
    else
        eval_time = time_vector;
    end

    % Evaluate the polynomials: polyval(p,eval_time) returns the value of the polynomial defined by the coefficients p evaluated at eval_time.
    q3 = polyval(coeffs_3, eval_time); q3_d = polyval(coeffs_3_d, eval_time); q3_dd = polyval(coeffs_3_dd, eval_time); q3_ddd = polyval(coeffs_3_ddd, eval_time);
    q5 = polyval(coeffs_5, eval_time); q5_d = polyval(coeffs_5_d, eval_time); q5_dd = polyval(coeffs_5_dd, eval_time); q5_ddd = polyval(coeffs_5_ddd, eval_time);
    q7 = polyval(coeffs_7, eval_time); q7_d = polyval(coeffs_7_d, eval_time); q7_dd = polyval(coeffs_7_dd, eval_time); q7_ddd = polyval(coeffs_7_ddd, eval_time);
    q7_all{o} = q7;

    % Plotting the results
    fig_title = sprintf('Polynomial Comparisons - %s Mode', upper(mod_opt));
    figure("Name", fig_title);
    sgtitle(sprintf('\\textbf{%s}', fig_title), 'Interpreter', 'latex', 'FontSize', 14); % title of the subplot
    
    subplot(2,2,1)
    grid on; hold on; 
    plot(time_vector, q3, 'Color', H(1), 'LineWidth', 2, 'DisplayName', '3rd Order')
    plot(time_vector, q5, 'Color', H(2), 'LineWidth', 2, 'DisplayName', '5th Order')
    plot(time_vector, q7, 'Color', H(3), 'LineWidth', 2, 'DisplayName', '7th Order')
    plot([ti tf], [qi qf], 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'HandleVisibility', 'off')
    ylabel('$q(t)$ [rad]', 'Interpreter', 'latex', 'FontSize', 12)
    xlim([ti,tf])
    legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 8)

    subplot(2,2,2)
    grid on; hold on; 
    plot(time_vector, q3_d, 'Color', H(1), 'LineWidth', 2, 'DisplayName', '3rd Order')
    plot(time_vector, q5_d, 'Color', H(2), 'LineWidth', 2, 'DisplayName', '5th Order')
    plot(time_vector, q7_d, 'Color', H(3), 'LineWidth', 2, 'DisplayName', '7th Order')
    plot([ti tf], [qi_d qf_d], 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'HandleVisibility', 'off')
    ylabel('$q^{\prime}(t)$ [rad/s$^3$]', 'Interpreter', 'latex', 'FontSize', 12)    
    xlim([ti,tf])
    legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 8)

    subplot(2,2,3)
    grid on; hold on; 
    plot(time_vector, q3_dd, 'Color', H(1), 'LineWidth', 2, 'DisplayName', '3rd Order')
    plot(time_vector, q5_dd, 'Color', H(2), 'LineWidth', 2, 'DisplayName', '5th Order')
    plot(time_vector, q7_dd, 'Color', H(3), 'LineWidth', 2, 'DisplayName', '7th Order')
    plot([ti tf], [qi_dd qf_dd], 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'HandleVisibility', 'off')
    xlabel('Time $t$ [s]', 'Interpreter', 'latex', 'FontSize', 12)
    ylabel('$q^{\prime\prime}(t)$ [rad/s$^3$]', 'Interpreter', 'latex', 'FontSize', 12)    
    xlim([ti,tf])
    legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 8)

    subplot(2,2,4)
    grid on; hold on; 
    plot(time_vector, q3_ddd, 'Color', H(1), 'LineWidth', 2, 'DisplayName', '3rd Order')
    plot(time_vector, q5_ddd, 'Color', H(2), 'LineWidth', 2, 'DisplayName', '5th Order')
    plot(time_vector, q7_ddd, 'Color', H(3), 'LineWidth', 2, 'DisplayName', '7th Order')
    plot([ti tf], [qi_ddd qf_ddd], 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'HandleVisibility', 'off')
    xlabel('Time $t$ [s]', 'Interpreter', 'latex', 'FontSize', 12)  
    ylabel('$q^{\prime\prime\prime}(t)$ [rad/s$^3$]', 'Interpreter', 'latex', 'FontSize', 12)    
    xlim([ti,tf])
    legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 8)

    if (mod_opt == "relative" & save_fig == true)
        exportgraphics(gcf, "images_hw1/" + fig_name + ".png", 'Resolution', 300);
    end

end

% Computes coefficients of a polynomial of order N
function c = poly_coeffs(N, ti, tf, bi, bf)
     assert(2*numel(bi) == N+1, 'Number of boundary conditions does not match polynomial order N');
     m = numel(bi);             % Number of conditions for both initial and final time
     p = N:-1:0;                % Powers of the polynomials
     A = zeros(2*m, N+1);       

     % Cycle on the derivatives
     for d = 0:m-1
        coef = ones(1,N+1);
        for j = 0:d-1
            coef = coef.*(p-j);  % If d != 0 then coeffs are multiplied by the powers
        end
        e = max(p-d, 0); % Negative exponent are set to 0
        A(d+1,   :) = coef .* ti.^e .* (p>=d); % So that derived constants are set to 0
        A(m+d+1, :) = coef .* tf.^e .* (p>=d); 
     end
     c = A \ [bi(:); bf(:)];
end

fprintf("Peak values produced by RELATIVE mode (results are equal)\n")
fprintf("-------------------------------------------------------------------------\n")
peaks = [max(abs(q3_d))  max(abs(q5_d))  max(abs(q7_d));
         max(abs(q3_dd)) max(abs(q5_dd)) max(abs(q7_dd));
         max(abs(q3_ddd)) max(abs(q5_ddd)) max(abs(q7_ddd))];

disp(array2table(peaks, 'VariableNames', {'Order 3','Order 5','Order 7'}, 'RowNames', {'VEL','ACC','JERK'}))

%% The difference between relative and absolute mode is pretty clear when high values of ti are used. Because the
%  computer works with a maximum number of digits, with high values of ti, in the absolute mode there are huge numbers especially 
%  for the 7th order polynomial, so the computations loose precision that lead to slightly different values of coefficients.

err = q7_all{1} - q7_all{2};

figure("Name", "Absolute vs Relative");
sgtitle(sprintf('\\textbf{Absolute vs Relative - 7th Order ($t_i = %g$ s)}', ti),'Interpreter', 'latex', 'FontSize', 14);

% Top: the two trajectories overlapped
subplot(2,1,1)
hold on; grid on;
plot(time_vector, q7_all{1},       'Color', H(1), 'LineWidth', 2, 'DisplayName', 'Absolute')
plot(time_vector, q7_all{2}, '--', 'Color', H(2), 'LineWidth', 2, 'DisplayName', 'Relative')
plot([ti tf], [qi qf], 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'HandleVisibility', 'off')
ylabel('$q(t)$ [rad]', 'Interpreter', 'latex', 'FontSize', 12)
legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 8)

% Bottom: difference between the two
subplot(2,1,2)
hold on; grid on;
plot(time_vector, err, 'Color', H(3), 'LineWidth', 2)
xlabel('Time $t$ [s]', 'Interpreter', 'latex', 'FontSize', 12)
ylabel('$q_{abs}(t) - q_{rel}(t)$ [rad]', 'Interpreter', 'latex', 'FontSize', 12)
yline(0, 'k:', 'HandleVisibility', 'off')
fprintf("-------------------------------------------------------------------------\n")
fprintf("Max |q_abs - q_rel| (7th order): %.2e rad\n", max(abs(err)));
fprintf("-------------------------------------------------------------------------\n")