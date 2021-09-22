function summary_stats = stats(A, B, C, D, E, F)
    % For output from the Hjorth program only All the stats for one particular run of the Hjorth program are computed and stored in a row vector, summary_stats
    % C to F
    % A=params{1};
    % B=params{2};
    % C=params{3};

    % %F to C
    % D=params{4};
    % E=params{5};
    % F=params{6};


    %  General information about the dataset Am assuming that this is for 'SCANNER' preprocessing
    A.id = 1;

    Asummary_stats(1)=A.id;
    summary_stats(2)=A.id;

    % CTOF data first

    % Numbers of whole and largest ordered submap, submap1, submap2
    summary_stats(3)=A.numpoints;
    summary_stats(4)=length(A.points_in_subgraph);
    summary_stats(5)=100*summary_stats(4)/summary_stats(3);


    summary_stats(6)=B.numpoints;
    summary_stats(7)=length(B.points_in_subgraph);
    summary_stats(8)=100*summary_stats(7)/summary_stats(6);
    summary_stats(9)=C.numpoints;
    summary_stats(10)=length(C.points_in_subgraph);
    summary_stats(11)=100*summary_stats(10)/summary_stats(9);

  
    % RC and ML measures of polarity - calculated on largest ordered submaps.
    summary_stats(12)=A.wholemap_RC;
    summary_stats(13)=A.wholemap_ML;
    summary_stats(14)=A.submap_RC;
    summary_stats(15)=A.submap_ML;

    summary_stats(16)=B.submap_RC;
    summary_stats(17)=B.submap_ML;
    summary_stats(18)=C.submap_RC;
    summary_stats(19)=C.submap_ML;


    % Mean ratios measured separately along NT/RC and DV/ML axes of length of link between two nodes in retina to the length of corresponding link on colliculus averaged over all such links. Links pointing in the wrong direction are ignored
    summary_stats(20)=A.full_map_link_ratios_RC;
    summary_stats(21)=A.subgraph_link_ratios_RC;
    summary_stats(22)=A.full_map_link_ratios_ML;
    summary_stats(23)=A.subgraph_link_ratios_ML;

    summary_stats(24)=B.subgraph_link_ratios_RC;
    summary_stats(25)=B.subgraph_link_ratios_ML;
    summary_stats(26)=C.subgraph_link_ratios_RC;
    summary_stats(27)=C.subgraph_link_ratios_ML;

    % Sizes of maps in visual field (28=AB)

    summary_stats(28)=A.fieldsub_cover;
    summary_stats(29)=B.fieldsub_cover;
    summary_stats(30)=C.fieldsub_cover;
    summary_stats(31)= 100*summary_stats(29)/summary_stats(28);
    summary_stats(32)= 100*summary_stats(30)/summary_stats(28);
    summary_stats(33)=summary_stats(31)+summary_stats(32)-100;
 

    %This is the overlap of the two partmaps in visual field. Only true if the two submaps together span the whole visual field.

    % Sizes of maps in colliculus

    summary_stats(34)=A.collsub_cover;
    summary_stats(35)=B.collsub_cover;
    summary_stats(36)=C.collsub_cover;
    summary_stats(37)= 100*summary_stats(35)/summary_stats(34);
    summary_stats(38)= 100*summary_stats(36)/summary_stats(34);
    summary_stats(39)=100-summary_stats(37)-summary_stats(38);

    %   Now FTOC data (40=AN)

    % Numbers of whole and largest ordered submap, EphA3+ map, WT map
    summary_stats(40)=D.numpoints;
    summary_stats(41)=length(D.points_in_subgraph);
    summary_stats(42)=100*summary_stats(41)/summary_stats(40);

    summary_stats(43)=B.numpoints;
    summary_stats(44)=length(B.points_in_subgraph);
    summary_stats(45)=100*summary_stats(44)/summary_stats(43);
    summary_stats(46)=C.numpoints;
    summary_stats(47)=length(C.points_in_subgraph);
    summary_stats(48)=100*summary_stats(47)/summary_stats(46);
    
    % RC and ML measures of polarity - calculated on largest ordered submaps. (49=AW)
    summary_stats(49)=D.wholemap_ML;
    summary_stats(50)=D.wholemap_RC;
    summary_stats(51)=D.submap_RC;
    summary_stats(52)=D.submap_ML;

    summary_stats(53)=E.submap_RC;
    summary_stats(54)=E.submap_ML;
    summary_stats(55)=D.submap_RC;
    summary_stats(56)=F.submap_ML;

    % Mean ratios measured separately along NT/RC and DV/ML axes of length of link between two nodes on colliculus to the length of corresponding link on retina averaged over all such links. Links pointing in the wrong direction are ignored (57=BE)
    summary_stats(57)=D.full_map_link_ratios_RC;
    summary_stats(58)=D.subgraph_link_ratios_RC;
    summary_stats(59)=D.full_map_link_ratios_ML;
    summary_stats(60)=D.subgraph_link_ratios_ML;
    summary_stats(61)=E.subgraph_link_ratios_RC;
    summary_stats(62)=E.subgraph_link_ratios_ML;
    summary_stats(63)=F.subgraph_link_ratios_RC;
    summary_stats(64)=F.subgraph_link_ratios_ML;

    % Sizes of maps in visual field (65=BM)
    summary_stats(65)=D.fieldsub_cover;
    summary_stats(66)=E.fieldsub_cover;
    summary_stats(67)=F.fieldsub_cover;
    summary_stats(68)=100*summary_stats(66)/summary_stats(65);
    summary_stats(69)=100*summary_stats(67)/summary_stats(65);
    summary_stats(70)=summary_stats(68)+summary_stats(69)-100;
    % This is a true measure of overlap of the two submaps in visual field as jointly they will span the whole field.

    % Sizes of maps on colliculus (71=BS)
    summary_stats(71)=D.collsub_cover;
    summary_stats(72)=E.collsub_cover;
    summary_stats(73)=F.collsub_cover;
    summary_stats(74)=100*summary_stats(72)/summary_stats(71);
    summary_stats(75)=100*summary_stats(73)/summary_stats(71);
    summary_stats(76)=summary_stats(74)+summary_stats(75)-100;
    % This is a true measure of overlap of the two submaps on colliculus as jointly they will span the whole colliculus.



