%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Load all necessary functions
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
addpath('src/functions_activity/')
addpath('src/functions_lattice_method/')
addpath('src/functions_plotting/')
addpath('src/functions_retinal_simulations/')
addpath('src/functions_analysis/')
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Define experiment set to parallel push through the Hjorth et al (2015) pipeline
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%

%% set the parameters that need to be passed to all workers in the parallel pool as global

global n_neurones n_iterations
n_neurones = [100, 500, 1000, 2000, 3000, 4000, 5000];
n_iterations = n_neurones .^ 2 .* 5;

global gradients ratios beta2 repeats sz L
grad = 0;
rat = 0.5;
gamma = 0.00625;
% create the iteration object
sz = [length(gradients), length(ratios), length(gamma), length(n_neurones)];
L = prod(sz);

% create the gradient files
for ind = 1:L
        % set the indexes and the subsequent parameters
        [u, s, t, n] = ind2sub(sz, ind);
        grad = gradients(u);
        rat = ratios(s);
        g = gamma(t);

        %call out to gradient .csv and modify
        T = readtable('src/functions_retinal_simulations/gradients/Eph-ephrins-both-axis-JH.csv');
        T{5, 8} = grad;
        T{5, 15} = rat;
        gradient_file = sprintf('results_experiments/gradient_files/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_gamma=%d.csv', n_neurones(n), grad, rat, g);
        writetable(T, gradient_file);
end

%change into the directory of the Hjorth pipeline
cd('src/functions_retinal_simulations')
neuronestiming = zeros(length(n_neurones), 2);
for ind = 1:L
        [u, s, t, n] = ind2sub(sz, ind);
        grad = gradients(u);
        rat = ratios(s);
        g = gamma(t);
        nneur = n_neurones(n);
        niter = n_iterations(n);

        bact = 1 / (0.05 * 4320);
        alpha = 90;
        beta = 135;
            
        %copy the base experimental file
        file_name = sprintf('../../results_experiments/timing/timing_experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_gamma=%d.txt', nneur, grad, rat, g);
        copyfile('../../results_experiments/experiment_configs/WillshawGale_owens_base.txt', file_name)

        %modify the gradient file
        gradient_file = sprintf('../../results_experiments/gradient_files/experiment_id_n_neurones=%d_EphA3-ki=%f_Ilset2ratio=%f_gamma=%d.csv', nneur, grad, rat, g);
        
        %modify the key experimental parameters
        fileID = fopen(file_name, 'a+');
        fprintf(fileID, [sprintf('obj.gradientInfoFile = %s', ''''), gradient_file, sprintf('%s\n', '''')]);
        fprintf(fileID, 'obj.nSC = %d;, \n', nneur);
        fprintf(fileID, 'obj.nRGC = %d;, \n', nneur); 
        fprintf(fileID, 'obj.nSteps = %d;, \n', niter); 
        fprintf(fileID, 'obj.alphaForwardChem = %f;, \n', alpha); 
        fprintf(fileID, 'obj.betaForwardChem = %f;, \n', beta);
        fprintf(fileID, 'obj.alphaReverseChem = 0;, \n'); 
        fprintf(fileID, 'obj.betaReverseChem = 0;, \n');
        fprintf(fileID, 'obj.gammaAct = %f;, \n', g);
        
        %set the save targets
        fprintf(fileID, 'obj.reportStep = %f, \n', niter + 1);
        fprintf(fileID, [sprintf('obj.simName = %s', ''''), sprintf('TimingTest_WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_gamma=%d_repeat=%d', nneur, niter, grad, rat, g, n), sprintf('%s \n', '''')]);
        fprintf(fileID, [sprintf('obj.dataPath = %s', ''''), '../../results_experiments/timing/', sprintf('%s \n', '''')]);
        fclose(fileID);
        %run
        
        %run the computation
        tic
        obj = RetinalMap(file_name);
        initializeRandomGenerator(obj)
        obj.run()
        neuronestiming(n, 1) = nneur
        neuronestiming(n, 2) = toc

        data_file = sprintf('../../results_experiments/timing/TimingTest_WillshawGale_n=%d_iterations=%d_ephA3KI=%f_ilset2proportion=%f_gamma=%d_repeat=%d', nneur, niter, grad, rat, g, n)
        delete data_file
        delete file_name
end
%change back into the route directory
cd('../../')

writematrix(neuronestiming, '/results_experiments/timing/timing_results.txt',a)
