%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Load all necessary functions
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
        addpath('src/functions_activity/')
        addpath('src/functions_lattice_method/')
        addpath('src/functions_plotting/')
        addpath('src/functions_retinal_simulations/')
        addpath("src/functions_analysis/")
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Define experiment set to parallel push through the Hjorth et al (2015) pipeline
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%

%% set the parameters that need to be passed to all workers in the parallel pool as global

global n_neurones n_iterations
n_neurones = 10000;
n_iterations = n_neurones ^ 2 * 5;

global gradients ratios gamma repeats sz L
tel = 1.0;
knock_in = (-tel:(tel - (-tel))/10:tel) + tel;
gradients = [0 knock_in 4.0 0.15 0.3 0.45]; % 
ratios = [0.4, 0.5, 0.6];
gamma = [0.01, 0.000625, 0.001];
repeats = 1:1;

% create the iteration object
sz = [length(gradients), length(ratios), length(gamma), length(repeats)];
L = prod(sz);
  
% create the gradient files
for ind = 1:L
        % set the indexes and the subsequent parameters
        [u, s, t, rep] = ind2sub(sz, ind);
        grad = gradients(u);
        rat = ratios(s);
        g = gamma(t);

        %call out to gradient .csv and modify
        T = readtable('src/functions_retinal_simulations/gradients/Eph-ephrins-both-axis-JH.csv');
        T{5, 8} = grad;
        T{5, 15} = rat;
        gradient_file = sprintf('results_experiments/gradient_files/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_gamma=%d.csv', n_neurones, grad, rat, g);
        writetable(T, gradient_file);
end

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Send through a parallel cluster
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%

%% create the pool, be nice about system resources
if isempty(gcp('nocreate'))
        parpool('local', 28);
end

%change into the directory of the Hjorth pipeline
cd('src/functions_retinal_simulations')
tic
parfor ind = 1:1
        [u, s, t, rep] = ind2sub(sz, ind);
        grad = gradients(u);
        rat = ratios(s);
        g = gamma(t);

        chemical_scale = 1;
        alpha = 90;
        beta = 135;
            
        %copy the base experimental file
        file_name = sprintf('../../results_experiments/experiment_configs/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_gamma=%d.txt', n_neurones, grad, rat, g);
        copyfile('../../results_experiments/experiment_configs/WillshawGale_owens_base.txt', file_name)

        %modify the gradient file
        gradient_file = sprintf('../../results_experiments/gradient_files/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_gamma=%d.csv', n_neurones, grad, rat, g);
        
        %modify the key experimental parameters
        fileID = fopen(file_name, 'a+');
        fprintf(fileID, [sprintf('obj.gradientInfoFile = %s', ''''), gradient_file, sprintf('%s\n', '''')]);
        fprintf(fileID, 'obj.nSC = %d;, \n', n_neurones);
        fprintf(fileID, 'obj.nRGC = %d;, \n', n_neurones); 
        fprintf(fileID, 'obj.nSteps = %d;, \n', n_iterations); 
        fprintf(fileID, 'obj.alphaForwardChem = %f;, \n', alpha); 
        fprintf(fileID, 'obj.betaForwardChem = %f;, \n', beta);
        fprintf(fileID, 'obj.alphaReverseChem = 0;, \n'); 
        fprintf(fileID, 'obj.betaReverseChem = 0;, \n');
        fprintf(fileID, 'obj.gammaAct = %f;, \n', gamma);

        
        %set the save targets
        fprintf(fileID, 'obj.reportStep = %f, \n', n_iterations + 1);
        fprintf(fileID, [sprintf('obj.simName = %s', ''''), sprintf('WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_gamma=%d_repeat=%d', n_neurones, n_iterations, grad, rat, g, rep), sprintf('%s \n', '''')]);
        fprintf(fileID, [sprintf('obj.dataPath = %s', ''''), '../../results_experiments/experiment_objects/', sprintf('%s \n', '''')]);
        fclose(fileID);
        
        %run the computation
        if ~isfile(sprintf('../../results_experiments/WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_gamma=%d_repeat=%d.mat', n_neurones, n_iterations, grad, rat, g, rep))
                tic
                obj = RetinalMap(file_name);
                initializeRandomGenerator(obj)
                obj.run()
                disp([u, s, t, rep])
                toc
        else
                disp("This experiment was already completed.")
                disp(ind2sub(sz, ind))
        end
end
toc

%change back into the route directory
cd('../../')
