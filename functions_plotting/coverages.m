function [] = coverages(A, B, C, D, E, F, field_x_label, field_y_label, coll_x_label, coll_y_label)

  % Don't calculate coverages for CTOF in WT
  fbw_x=A.field_points(:,1);
  fbw_y=A.field_points(:,2);
  [fkw faw]=boundary(fbw_x,fbw_y);

  fbs_x=A.field_points(A.CTOF.points_in_subgraph,1);
  fbs_y=A.CTOF.field_points(A.CTOF.points_in_subgraph,2);
  [fks fas]=boundary(fbs_x,fbs_y);

  fb1_x=B.CTOF.field_points(B.CTOF.points_in_subgraph,1);
  fb1_y=B.CTOF.field_points(B.CTOF.points_in_subgraph,2);
  [fk1 fa1]=boundary(fb1_x,fb1_y);

  fb2_x=C.CTOF.field_points(C.CTOF.points_in_subgraph,1);
  fb2_y=C.CTOF.field_points(C.CTOF.points_in_subgraph,2);
  [fk2 fa2]=boundary(fb2_x,fb2_y);
 
  cbw_x=A.CTOF.coll_points(:,1);
  cbw_y=A.CTOF.coll_points(:,2);
  [ckw caw]=boundary(cbw_x,cbw_y);

  cbs_x=A.CTOF.coll_points(A.CTOF.points_in_subgraph, 1);
  cbs_y=A.CTOF.coll_points(A.CTOF.points_in_subgraph, 2);
  [cks cas]=boundary(cbs_x,cbs_y);

  cb1_x=B.CTOF.coll_points(B.CTOF.points_in_subgraph,1);
  cb1_y=B.CTOF.coll_points(B.CTOF.points_in_subgraph,2);
  [ck1 ca1]=boundary(cb1_x,cb1_y);

  cb2_x=C.CTOF.coll_points(C.CTOF.points_in_subgraph,1);
  cb2_y=C.CTOF.coll_points(C.CTOF.points_in_subgraph,2);
  [ck2 ca2]=boundary(cb2_x,cb2_y);

  field1=round(100*fa1/fas);
  field2=round(100*fa2/fas);

  coll1=round(100*ca1/cas);
  coll2=round(100*ca2/cas);

  figure(515);
  clf
  subplot(2,2,1)
  hold on

  plot(fbs_x(fks),fbs_y(fks),'r','DisplayName','Submap');

  plot(fb1_x(fk1),fb1_y(fk1),'b--','DisplayName','Partmap1');

  plot(fb2_x(fk2),fb2_y(fk2),'c--','DisplayName','Partmap2');
  hold off
  legend
  
  xlabel(field_x_label);
  ylabel(field_y_label);

  set(gca, 'XDir','reverse');
  set(gca, 'YDir','reverse');
  title({['Fig ',num2str(515),',',num2str(date)];['ID: ',num2str(A.id),',','CTOF',',',A.input_type];['Coverage - % of submap: ',num2str(field1),',',num2str(field2)]});
  axis square

  subplot(2,2,3);

  hold on

  plot(cbs_x(cks),cbs_y(cks),'r');

  plot(cb1_x(ck1),cb1_y(ck1),'b--');

  % Define extent of submap2 in colliculus

   plot(cb2_x(ck2),cb2_y(ck2),'c--');

   xlabel(coll_x_label);
   ylabel(coll_y_label);
   title({['Coverage: % of submap '];[num2str(coll1),',',num2str(coll2)]});
   axis square


  % Now FTOC

  fbw_x=D.FTOC.field_points(:,1);
  fbw_y=D.FTOC.field_points(:,2);
  [fkw faw]=boundary(fbw_x,fbw_y);

  fbs_x=D.FTOC.field_points(D.FTOC.points_in_subgraph,1);
  fbs_y=D.FTOC.field_points(D.FTOC.points_in_subgraph,2);
  [fks fas]=boundary(fbs_x,fbs_y);

  fb1_x=E.FTOC.field_points(E.FTOC.points_in_subgraph,1);
  fb1_y=E.FTOC.field_points(E.FTOC.points_in_subgraph,2);
  [fk1 fa1]=boundary(fb1_x,fb1_y);

  fb2_x=F.FTOC.field_points(F.FTOC.points_in_subgraph,1);
  fb2_y=F.FTOC.field_points(F.FTOC.points_in_subgraph,2);
  [fk2 fa2]=boundary(fb2_x,fb2_y);
 
  cbw_x=D.FTOC.coll_points(:,1);
  cbw_y=D.FTOC.coll_points(:,2);
  [ckw caw]=boundary(cbw_x,cbw_y);

  cbs_x=D.FTOC.coll_points(D.FTOC.points_in_subgraph,1);
  cbs_y=D.FTOC.coll_points(D.FTOC.points_in_subgraph,2);
  [cks cas]=boundary(cbs_x,cbs_y);

  cb1_x=E.FTOC.coll_points(E.FTOC.points_in_subgraph,1);
  cb1_y=E.FTOC.coll_points(E.FTOC.points_in_subgraph,2);
  [ck1 ca1]=boundary(cb1_x,cb1_y);

  cb2_x=F.FTOC.coll_points(F.FTOC.points_in_subgraph,1);
  cb2_y=F.FTOC.coll_points(F.FTOC.points_in_subgraph,2);
  [ck2 ca2]=boundary(cb2_x,cb2_y);

  field1=round(100*fa1/fas);
  field2=round(100*fa2/fas);

  coll1=round(100*ca1/cas);
  coll2=round(100*ca2/cas);

  figure(515);
  
  subplot(2,2,2)
  hold on

  plot(fbs_x(fks),fbs_y(fks),'r','DisplayName','Submap');

  plot(fb1_x(fk1),fb1_y(fk1),'b--','DisplayName','EphA3+ map');

  plot(fb2_x(fk2),fb2_y(fk2),'c--','DisplayName','WT map');

  hold off

  legend
  title({['Fig ',num2str(515),',',num2str(date)];['ID: ',num2str(A.id),',','FTOC',',',A.input_type];['Coverage - % of submap: ',num2str(field1),',',num2str(field2)]});

  xlabel(field_x_label);
  ylabel(field_y_label);

  set(gca, 'XDir','reverse');
  set(gca, 'YDir','reverse');
  axis square


  subplot(2,2,4);

  hold on

  plot(cbs_x(cks),cbs_y(cks),'r');

  plot(cb1_x(ck1),cb1_y(ck1),'b--');

  plot(cb2_x(ck2),cb2_y(ck2),'c--');

  hold off

  xlabel(coll_x_label);
  ylabel(coll_y_label);
  title({['Coverage - % of submap: '];[num2str(coll1),',',num2str(coll2)]});
   axis square


  orient tall
  if PRINT==1
     filename=[dir, 'Fig',num2str(515),',ID:',num2str(A.id),A.input,',',num2str(date),'.png'];
     print(filename,'-dpng');
  end

 
