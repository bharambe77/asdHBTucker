function nPaths = newTreePaths(asdTens,oSamples,samples,paths,tree,ind,L,r,options)
    
    nPaths=ones(sum(ind),sum(L));
    
    dims=size(asdTens);
    
    for j=1:2
        
       col=(j-1)*L(1); %starting column
        
       %get counts
       ctsA=accumarray(oSamples(:,[1+j 3+j]),1,[dims(1+j),...
           max(max(r{j}),max(oSamples(:,3+j)))]);
       
       cts=accumarray(samples(:,[1+j 3+j 1]),1,[dims(1+j),...
           max(max(r{j}),max(samples(:,3+j))),sum(ind)]);
       
      switch options.pType
           case 0
               prior=1/dims(1+j);
           case 1
               prior=1;
           otherwise
               error('Error. \nNo prior type selected');
       end
       
       gcts = gammaln(ctsA+prior);
       glp = gammaln(prior);
       
       for i=1:sum(ind)
           curRes=1; %set current restaurant as root

           for k=2:L(j)

               %add new restaurant to list
               rList=tree{j}{curRes};
               rList=sort(rList);

               %compute CRP part of pdf
               pdf=histc(paths(:,col+k)',rList);

               %get counts
               cts1=ctsA(:,rList);
               cts2=ctsA(:,rList)+cts(:,rList,i);
               gcts1=gcts(:,rList);

               %compute contribution to pdf
               pdf=log(pdf); %take log to prevent overflow
               pdf=pdf+gammaln(sum(cts1,1)+1);
               pdf=pdf-sum(gcts1,1);
               pdf=pdf+sum(gammaln(cts2+prior),1);
               pdf=pdf-gammaln(sum(cts2,1)+1);
               pdf=exp(pdf);
               pdf=pdf/sum(pdf); %normalize

               %pick new table
               next=multi(pdf);
               nextRes=rList(next);

               nPaths(i,col+k)=nextRes; %sit at table
           end
       end
    end
end