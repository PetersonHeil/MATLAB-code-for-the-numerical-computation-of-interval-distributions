
% Check if MATLAB's current folder is correct
if ~exist([pwd, '\configure_method.m'], 'file')
    error('Please set MATLAB''s current folder to the one containing ''configure_method.m''.')
end

% Set default graphics renderer ('painters' was used to generate the files in the paper)
set(0, 'DefaultFigureRenderer', 'painters');

% Initialize the structure that holds all options, numerical computations, and simulations
vars = [];

% Settings related to saving
vars.settings.doSave = true;                                                        % Specifies whether to save results
vars.settings.saveRoot = 'RESULTS\';                                                % Directory into which results are saved (exact subfolder name will be auto-generated)

% Settings related to plotting
vars.settings.doPlotSteps = true;                                                   % Specifies whether to plot numerical steps
vars.settings.doPlotSim = true;                                                     % Specifies whether to plot simulations
vars.settings.doClose = true;                                                     	% Specifies whether to close figures after saving
vars.settings.iPlotRecurrence = [1 10 20];                                          % Specifies bins in observation window for which recurrence distributions are plotted

% Miscellaneous settings
vars.settings.doDisplay = true;                                                    	% Specified whether to display text outputs to console 
vars.settings.doCompare = true;                                                 	% Specifies whether to check results against the (much slower) algorithms implemented as in the paper
vars.settings.TolCompare = 1e-10;                                                   % Specifies tolerance when comparing equality of numerical implementations
vars.settings.doUseMEX = false;                                                     % Specifies whether Step 4 should use the MEX implementation (it's MUCH faster if the observation window has many points)

% Settings related to observation window
vars.window.dt = 0.1;                                                             	% Time step (in milliseconds)
vars.window.tmin = 0;                                                               % Left edge of first bin in observation window (in milliseconds)
vars.window.tmax = 5;                                                            	% Right edge of last bin in observation window (in milliseconds)

% Number of repetitions of the observation window to simulate
vars.sim.nreps = 1000000;                                                           % Set to 0 to disable simulations

% Specify the simulation method for inhomogeneous process (choose one)
vars.sim.process.type = 'default';                                                  % Simulate event process by drawing a random number for each time point
% vars.sim.process.type = 'thinning';                                              	% Simulate event process by thinning a homogeneous Poisson process

% Specify the rate function (choose one)
vars = define_R(vars, @R_sinexp, 'event', 'A',600,'B',1,'f',400);                   % Sinusoid passed through an exponential transfer (as in Figures 2-7 in the paper)
% vars = define_R(vars, @R_randwalk_used_in_paper, 'event', 'R1',600,'Rrange',150); % Random walk (realization used in Figure 8 in the paper)
% vars = define_R(vars, @R_constant, 'event', 'R', 1000);                       	% Homogeneous event process (as in Figures 9-10 in the paper)
% vars = define_R(vars, @R_randwalk, 'event', 'R1',600,'Rrange',150);               % Random walk (random realization)

% Specify the dead-time distribution (choose one)
vars = define_G(vars, @G_geometric, 'dfixed', 0.5, 'murand', 0.5);                  % Geometric distribution shifted by a fixed dead time (as in all Figures in the paper)
% vars = define_G(vars, @G_exponential, 'dfixed', 0.5, 'murand', 0.5);           	% Exponential distribution shifted by a fixed dead time

% Run the model using the parameter set specified
vars = execute_method(vars);


