%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Load all necessary functions
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
        addpath('functions_activity/')
        addpath('functions_lattice_method/')
        addpath('functions_plotting/')
        addpath('functions_retinal_simulations/')
        addpath("functions_analysis/")
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Load experimental data
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Progammatically select Hjorth files to analyse
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
%% set the parameters that need to be passed to all workers in the parallel pool as global
global n_neurones n_iterations
n_neurones = 10000;
n_iterations = n_neurones ^ 2 * 5;

global gradients ratios beta2 repeats sz L
tel = 1.0;
knock_in = (-tel:(tel - (-tel))/10:tel) + tel;
gradients =  4.0; [0 knock_in]; [0.15, 0.3, 0.45, 4.0];    
ratios = 0.5; [0.4, 0.5, 0.6];    
gamma =  0.00625;  [0.001, 0.00625, 0.01];
repeats = 1:1;


% create the iteration objects and set up a parallel pool
sz = [length(gradients), length(ratios), length(gamma), length(repeats)];
L = prod(sz);

global stats_vec 
for i = 1:L
        stats_vec{i} = [0];
end

if isempty(gcp('nocreate'))
        parpool('local', 28);
end


%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Set the appropriate global parameters for analysis in a dictionary
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
        % Spacing: the spacing are parameters to the lattice method and are as follows but can be modified by N the number of points. N can be reduced by filtering, or in a part-map.
                analysis_parameter_dictionary.spacing_points_fraction = 1/20;
                analysis_parameter_dictionary.spacing_radius_multiplier = 4;
                analysis_parameter_dictionary.spacing_lower_bound = 2 * 0.84;
                analysis_parameter_dictionary.spacing_upper_bound = 2 * 1.16;
        
        % Activity Model: these parameters define the firing rates, sampling time, and total scanning length in the Poisson based activity model.
                analysis_parameter_dictionary.dt = 0.01; %sampling rate
                analysis_parameter_dictionary.bar_width = 0.02; 
                analysis_parameter_dictionary.bar_freq = 10;
                analysis_parameter_dictionary.time = floor(1/(analysis_parameter_dictionary.bar_freq) * 20);
                analysis_parameter_dictionary.average_radius = 0.025;

        %biological parameters
                analysis_parameter_dictionary.retinal_firing_rate = 0.9 / analysis_parameter_dictionary.dt;
                analysis_parameter_dictionary.baseline_collicular_firing_rate = 0.05;
                analysis_parameter_dictionary.collicular_inhibitory_scale = 0.02;
                analysis_parameter_dictionary.collicular_excitatory_scale = 0.01;
                analysis_parameter_dictionary.collicular_inhibtory_amplitude = 0.01;
                analysis_parameter_dictionary.collicular_excitatory_amplitude = 0.02;

        % Filtering: these determine the threshold for standard deviation and the search radius
                analysis_parameter_dictionary.filter_threshold = 0.1;
                analysis_parameter_dictionary.filter_collicular_radius = 0.05;

        % Lattice method
                analysis_parameter_dictionary.unique_noise_parameter = 10^-6;
                analysis_parameter_dictionary.max_trial_scale_factor = 10;
                analysis_parameter_dictionary.min_spacing_fraction = 0.75;
                analysis_parameter_dictionary.min_spacing_reduction_factor = 0.95;
                analysis_parameter_dictionary.CTOF_area_scaling = 1;
                analysis_parameter_dictionary.FTOC_area_scaling = 1; 
                analysis_parameter_dictionary.min_points = 10;
                analysis_parameter_dictionary.random_seed = 1;
                analysis_parameter_dictionary.triangle_tolerance = 1;
                analysis_parameter_dictionary.create_new_map_CTOF = 0;
                analysis_parameter_dictionary.create_new_map_FTOC = 1;
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Set the appropriate global parameters for plotting in a dictionary. Each plotting group is specified. 
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%      
        vfnttext = append('Visual Field (', char(8678), 'Nasal-Temporal', char(8680),')');
        vfdvtext = append('Visual Field (', char(8678), 'Dorsal-Ventral', char(8680),')');
        
        plotting_dictionary.Phase.directory = 'results_plots/';

        plotting_dictionary.FTOCdictionary.directory_FTOC = 'results_plots/';
        plotting_dictionary.FTOCdictionary.XLim = [0, 1];
        plotting_dictionary.FTOCdictionary.YLim = [0, 1];
        plotting_dictionary.FTOCdictionary.XTick = [0, 1];
        plotting_dictionary.FTOCdictionary.YTick = [0, 1];
        plotting_dictionary.FTOCdictionary.XTickLabel = '';
        plotting_dictionary.FTOCdictionary.YTickLabel = '';
        plotting_dictionary.FTOCdictionary.FlipY = 0;

        plotting_dictionary.FTOCdictionary.part_subplot1_xlabel = vfnttext;
        plotting_dictionary.FTOCdictionary.part_subplot1_ylabel = vfdvtext;
        plotting_dictionary.FTOCdictionary.part_subplot2_xlabel = vfnttext;
        plotting_dictionary.FTOCdictionary.part_subplot2_ylabel = vfdvtext;
        plotting_dictionary.FTOCdictionary.part_subplot3_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.FTOCdictionary.part_subplot3_ylabel = append('Colliculus (', char(8678), 'Medial-Lateral', char(8680),')');
        plotting_dictionary.FTOCdictionary.part_subplot4_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.FTOCdictionary.part_subplot4_ylabel = append('Colliculus (', char(8678), 'Medial-Lateral', char(8680),')');

        plotting_dictionary.CTOFdictionary.directory_CTOF = 'results_plots/';
        plotting_dictionary.CTOFdictionary.XLim = [0, 1];
        plotting_dictionary.CTOFdictionary.YLim = [0, 1];
        plotting_dictionary.CTOFdictionary.XTick = [0, 1];
        plotting_dictionary.CTOFdictionary.YTick = [0, 1];
        plotting_dictionary.CTOFdictionary.XTickLabel = '';
        plotting_dictionary.CTOFdictionary.YTickLabel = '';
        plotting_dictionary.CTOFdictionary.FlipY = 0;

        plotting_dictionary.CTOFdictionary.part_subplot1_xlabel = vfnttext;
        plotting_dictionary.CTOFdictionary.part_subplot1_ylabel = vfdvtext;
        plotting_dictionary.CTOFdictionary.part_subplot2_xlabel = vfnttext;
        plotting_dictionary.CTOFdictionary.part_subplot2_ylabel = vfdvtext;
        plotting_dictionary.CTOFdictionary.part_subplot3_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.CTOFdictionary.part_subplot3_ylabel = append('Colliculus (', char(8678), 'Medial-Lateral', char(8680),')');
        plotting_dictionary.CTOFdictionary.part_subplot4_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.CTOFdictionary.part_subplot4_ylabel = append('Colliculus (', char(8678), 'Medial-Lateral', char(8680),')');

        plotting_dictionary.CTOFdictionary.shrink = 0.2;
        plotting_dictionary.FTOCdictionary.shrink = 0.2;

        plotting_dictionary.anatomy.directory = 'results_plots/';
        plotting_dictionary.anatomy.DV = 0.5;
        plotting_dictionary.anatomy.ML = 0.4;
        plotting_dictionary.anatomy.threshold = 0.05;
        plotting_dictionary.anatomy.injection_location = [0.67, 0.5];
        plotting_dictionary.anatomy.injection_radius = 0.05;
        plotting_dictionary.anatomy.sc_colour = [0.4940 0.1840 0.5560];
        plotting_dictionary.anatomy.epha3_colour = [0.9290 0.6940 0.1250]; % [1,1,0];  %  [0.8500, 0.3250, 0.0980]; %
        plotting_dictionary.anatomy.wt_colour = [0.6350 0.0780 0.1840]; 
        plotting_dictionary.anatomy.inj_colour = [0 0.4470 0.7410];
        plotting_dictionary.anatomy.transparency = 0.1;
        plotting_dictionary.anatomy.fontsize = 8;
        plotting_dictionary.anatomy.markersize = 8;
        plotting_dictionary.anatomy.subplot1_xlabel = vfnttext;
        plotting_dictionary.anatomy.subplot1_ylabel = vfdvtext;
        plotting_dictionary.anatomy.subplot2_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.anatomy.subplot2_ylabel = 'EphA / EphrinA';
        plotting_dictionary.anatomy.subplot3_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.anatomy.subplot3_ylabel = vfnttext;
        plotting_dictionary.anatomy.subplot4_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.anatomy.subplot4_ylabel = vfnttext;
        plotting_dictionary.anatomy.subplot5_xlabel = append('Colliculus (', char(8678), 'Rostral-Caudal', char(8680),')');
        plotting_dictionary.anatomy.subplot5_ylabel = append('Colliculus (', char(8678), 'Medial-Lateral', char(8680),')');
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Run analysis, and plot
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

plot_figs = (n_neurones == 10000);
print_stats = false;
record_stats = (n_neurones == 2000);

parfor ind = 1:L
        %choose the experiment
        [u, s, t, rep] = ind2sub(sz, ind); 
        grad = gradients(u);
        rat = ratios(s); 
        g = gamma(t);
        
        %load the data
        filename = sprintf('results_experiments/experiment_configs/WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_gamma=%d_repeat=%d.mat', n_neurones, n_iterations, grad, rat, g, rep);
        experiment_obj = load(filename).old;
         
        % perform a scanning experiment, plot, and analyse
        analysis_obj_scanner = experiment_analysis(experiment_obj, 'SCANNER', analysis_parameter_dictionary, [grad, rat, g, rep], 'SIMULATION');
        disp("finished analysis of scanning")
        if rep <= 1 && plot_figs
               experiment_plot(analysis_obj_scanner, plotting_dictionary);
        end
        disp("finished plot of scanning")

        %perform an anatomical experiment, plot, and analyse
        analysis_obj_anatomy = experiment_analysis(experiment_obj, 'ANATOMY', analysis_parameter_dictionary, [grad, rat, g, rep], 'SIMULATION');
        disp("finished analysis of anatomy")
        if (rep == 1) && plot_figs
               experiment_plot(analysis_obj_anatomy, plotting_dictionary);
        end

        %append the statistics to an array
        if record_stats
                stats_vec{ind} = analysis_obj_anatomy.Lattice.statistics;
        end 

        %  construct a series of pure injection plots with axes labels only for the leftmost plot
        if (rep == 1) && plots_figs
                if u==1
                      anatomy(analysis_obj_anatomy, plotting_dictionary.anatomy, 1);
                else
                      anatomy(analysis_obj_anatomy, plotting_dictionary.anatomy, 1);
                end
        end
        disp("finished plot of anatomy")

        if print_stats == true
                print_indexed_stats(grad, rat, g)
        end
end

% generate statistics
if record_stats
        plot_statistics(stats_vec, gradients, ratios, gamma, repeats);
end

