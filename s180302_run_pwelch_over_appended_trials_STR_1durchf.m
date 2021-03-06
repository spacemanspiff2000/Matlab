%%s180302_run_pwelch_over_appended_trials_STR_1durchf for THETA, normalized by
%%1/f^2
% 
clear all
%close all
Liste=dir('*CG04*Ruhe*');
Liste={Liste.name}';
figure
for datei_i=1:length(Liste)
    
    aktuelle_datei=Liste(datei_i);
    load(aktuelle_datei{:})
    
    cfg=[];
    cfg.demean='yes';
    cfg.reref='yes';
    cfg.refchannel = 31;
    cfg.refmethod='avg';
    
    data=ft_preprocessing(cfg,data);
    
    
    %data=specialreref(data);
    
    
    
%     cfg=[];
%     cfg.resamplefs=500;
%     data=ft_resampledata(cfg,data);
     cfg=[];
        cfg.length=0.9;
        data = ft_redefinetrial(cfg, data);

         for i=1:length(data.trial) 
            welch(:,:,i)=(data.trial{1,i}([1:15],:)')/800;
            %[pxx(:,:,i), welch_freq(:,1)]=pmtm(welch(:,:,i),[],[],2000);
            %[pxx(:,:,i), welch_freq(:,1)]=pwelch(welch(:,:,i), [], [], [], data.fsample);  % mit hamming(auto) 
            [pxx(:,:,i), welch_freq(:,1)]=(pwelch(welch(:,:,i), hanning(200), [], 1024, 500, 'power'));  % mit hanning statt hamming
            
        end

        welch=pxx;
        clearvars pxx
        welch_average=mean(welch,3);
        
%         h=s171109_normalizegame(welch_average, welch_freq)
%     uiwait(h)
%       
    normfaktor= repmat(welch_freq,1,size(welch_average,2));
    normfaktor=(normfaktor.^2);
    normfaktor=1./normfaktor;
    
    welch_average_norm= bsxfun(@rdivide, welch_average, normfaktor);
        welch_average=(welch_average_norm);
      
        subplot(3,5,datei_i)
      
        mygca(datei_i) = gca;
        %figure('NumberTitle', 'off', 'Name', aktuelle_datei{:});
        if datei_i==1
            baseline=welch_average;
            %welch_average=welch_average./baseline;
            total_average=welch_average;
        else
        %welch_average=welch_average./baseline;
        total_average=cat(3,total_average,welch_average);
        end
        plot(welch_freq,welch_average(:,:))
          title(aktuelle_datei{1,1}(1:15), 'Interpreter', 'none', 'FontSize', 8)  
          xlabel('Frequency [Hz]', 'FontSize', 8)
          ylabel('Power [a.u.]', 'FontSize', 8)

%         xlim([8 90])
%         ylim([0 5])
        drawnow
    
        clearvars -except Liste datei_i total_average baseline mygca total_average2 total_average4
end

 set(mygca, 'Xlim', [2 15])
 set(mygca, 'XTick', 2:2:15)
 set(mygca, 'Ylim', [0 1.5e+5])
 set(mygca, 'XMinorGrid', 'on')
 set(mygca, 'YGrid', 'on')