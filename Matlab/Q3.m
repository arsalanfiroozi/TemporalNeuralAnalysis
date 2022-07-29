clearvars
clc
addpath(genpath('asset\'));
load('i140703-001_lfp-spikes.mat')

event_time = block.segments{1, 1}.events{1, 1}.times;
event_labelcode = str2num(block.segments{1, 1}.events{1, 1}.labels);
event_label = block.segments{1, 1}.events{1, 1}.an_trial_event_labels;

[r,c,v] = find(event_labelcode==65296);
sel = 1:length(r);
binsize = 1;

fs = 30000;
ISI_d = [];
for i=1:length(block.segments{1,1}.spiketrains)
    d = block.segments{1,1}.spiketrains{1,i}.times();
    spk_ts = {};
    t_stop = [];
    for j=1:length(r)-1
        t = event_time(r(j))<=d & d<event_time(r(j+1));
        p = (d(t) - event_time(r(j)))./fs;
        ISI_d = [ISI_d diff(p)];
    end
    i
end
figure;
set(gcf,'Color',[1 1 1]);
set(gca,'FontName','arial','FontSize',10); % Check this
histogram(ISI_d,10000)
xlim([0 0.5]);
% ylim([0 1]);
export_fig('ISI_Dis.png','-r600');