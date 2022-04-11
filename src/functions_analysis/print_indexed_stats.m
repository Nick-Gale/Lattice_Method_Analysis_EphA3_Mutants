function print_indexed_stats(grad, rat, g)
    if rat == 0.5 && g == 0.00625 && rep == 1
        WMnnodes = stats_vec{i}(3);
        WMVFO = stats_vec{i}(33);
        WMqual = stats_vec{i}(5);

        PM1nnodes = stats_vec{i}(43);
        PM1qual = stats_vec{i}(45);
        PM2nnodes = stats_vec{i}(46);
        PM2qual = stats_vec{i}(48);

        sprintf('For a DR of %0.2f, cell ratio of %0.2f, and Gamma of %0.2f there are %d nodes selected in the whole map. The VFO is %0.2f and the map quality is %0.2f. The first part map has %d nodes and the map quality is %0.2f. The second part map has %d nodes and the map quality is %0.2f. \n', grad, rat, g,  WMnnodes, WMVFO, WMqual, PM1nnodes, PM1qual, PM2nnodes, PM2qual)
    end

    if rat == 0.4 && g == 0.00625 && rep == 1
            WMnnodes = stats_vec{i}(3);
            WMVFO = stats_vec{i}(33);
            WMqual = stats_vec{i}(5);

            PM1nnodes = stats_vec{i}(43);
            PM1qual = stats_vec{i}(45);
            PM2nnodes = stats_vec{i}(46);
            PM2qual = stats_vec{i}(48);

            sprintf('For a DR of %0.2f, cell ratio of %0.2f, and Gamma of %0.2f there are %d nodes selected in the whole map. The VFO is %0.2f and the map quality is %0.2f. The first part map has %d nodes and the map quality is %0.2f. The second part map has %d nodes and the map quality is %0.2f. \n', grad, rat, g,  WMnnodes, WMVFO, WMqual, PM1nnodes, PM1qual, PM2nnodes, PM2qual)
    end

    if rat == 0.6 && g == 0.00625 && rep == 1
            WMnnodes = stats_vec{i}(3);
            WMVFO = stats_vec{i}(33);
            WMqual = stats_vec{i}(5);

            PM1nnodes = stats_vec{i}(43);
            PM1qual = stats_vec{i}(45);
            PM2nnodes = stats_vec{i}(46);
            PM2qual = stats_vec{i}(48);

            sprintf('For a DR of %0.2f, cell ratio of %0.2f, and Gamma of %0.2f there are %d nodes selected in the whole map. The VFO is %0.2f and the map quality is %0.2f. The first part map has %d nodes and the map quality is %0.2f. The second part map has %d nodes and the map quality is %0.2f. \n', grad, rat, g,  WMnnodes, WMVFO, WMqual, PM1nnodes, PM1qual, PM2nnodes, PM2qual)
    end

    if rat == 0.5 && grad == 2.0 && rep == 1
            WMnnodes = stats_vec{i}(3);
            WMVFO = stats_vec{i}(33);
            WMqual = stats_vec{i}(5);

            PM1nnodes = stats_vec{i}(43);
            PM1qual = stats_vec{i}(45);
            PM2nnodes = stats_vec{i}(46);
            PM2qual = stats_vec{i}(48);

            sprintf('For a DR of %0.2f, cell ratio of %0.2f, and Gamma of %0.2f there are %d nodes selected in the whole map. The VFO is %0.2f and the map quality is %0.2f. The first part map has %d nodes and the map quality is %0.2f. The second part map has %d nodes and the map quality is %0.2f. \n', grad, rat, g,  WMnnodes, WMVFO, WMqual, PM1nnodes, PM1qual, PM2nnodes, PM2qual)
    end
end