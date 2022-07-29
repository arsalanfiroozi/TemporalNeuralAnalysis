clearvars
addpath(genpath('asset\'));
load('i140703-001_lfp-spikes.mat')

event_time = block.segments{1, 1}.events{1, 1}.times;
event_labelcode = str2num(block.segments{1, 1}.events{1, 1}.labels);
event_label = block.segments{1, 1}.events{1, 1}.an_trial_event_labels;

[r,c,v] = find(event_labelcode==65296);
sel = 1:length(r);
binsize = 1;

fs = 30000;
for i=1:length(block.segments{1,1}.spiketrains)
    d = block.segments{1,1}.spiketrains{1,i}.times();
    spk_ts = {};
    t_stop = [];
    for j=1:length(r)-1
        t = event_time(r(j))<=d & d<event_time(r(j+1));
        spk_ts{j} = (d(t) - event_time(r(j)))./fs;
        t_stop = [t_stop; (event_time(r(j+1))-event_time(r(j)))./fs];
    end
%     t = event_time(r(end))<=d & d<event_time(end);
%     spk_ts{length(r)} = (d.*t - event_time(r(end)))./fs;
%     t_stop = [t_stop; (block.segments{1,1}.spiketrains{1,i}.t_stop-event_time(r(end)))./fs];
    data = [];
    q = 1;
    for k=0:0.01:max(t_stop)-binsize
        data(q) = 0;
        for j=1:length(r)-1
            data(q) = data(q) + sum((spk_ts{j}<k+binsize) &(spk_ts{j}>k));
        end
        q = q + 1;
    end
    data = data./(length(r)-1);
    figure;
    set(gcf,'Color',[1 1 1]);
    set(gca,'FontName','arial','FontSize',10); % Check this
    plot(0:0.01:max(t_stop)-binsize,data);
    title(['Spike Number ' num2str(i)]);
    for k=r(1):r(1+1)
        hold on
        plot([event_time(k)-event_time(r(1)) event_time(k)-event_time(r(1))]./fs,[min(data),max(data)],'MarkerSize',300);
    end
    export_fig(['res/Neuro' num2str(i) '.png'],'-r600');
end
