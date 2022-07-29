clearvars
addpath(genpath('asset\'));
load('i140703-001_lfp-spikes.mat')

event_time = block.segments{1, 1}.events{1, 1}.times;
event_labelcode = str2num(block.segments{1, 1}.events{1, 1}.labels);
event_label = block.segments{1, 1}.events{1, 1}.an_trial_event_labels;

[r,c,v] = find(event_labelcode==65296);
sel = [5,60,70,160];

fs = 30000;

for j=1:length(sel)
    spk_ts = {};
    t_stop = [];
    for i=1:length(block.segments{1,1}.spiketrains)
        d = block.segments{1,1}.spiketrains{1,i}.times();
        t = event_time(r(sel(j)))<=d & d<event_time(r(sel(j)+1));
        spk_ts{i} = (d.*t - event_time(r(sel(j))))./fs;
        t_stop = [t_stop; (event_time(r(sel(j)+1))-event_time(r(sel(j))))./fs];
    end
    LineFormat.Color = 'b';
    figure;
    set(gcf,'Color',[1 1 1]);
    set(gca,'FontName','arial','FontSize',10); % Check this
    plotSpikeRaster(spk_ts,'SpikeDuration',0.03,'LineFormat',LineFormat);
    xlim([0 max(t_stop)]);
    title(['Spike number ' num2str(sel(j))]);
    hold on
    for i=r(sel(j)):r(sel(j)+1)
        plot([event_time(i)-event_time(r(sel(j))) event_time(i)-event_time(r(sel(j)))]./fs,[1,270],'MarkerSize',300);
        i
    end
    export_fig(['Spike' num2str(sel(j)) '.png'],'-r600');
end