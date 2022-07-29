clc;
clearvars;
load('i140703-001_lfp-spikes.mat')

event_time = block.segments{1, 1}.events{1, 1}.times;
event_labelcode = str2num(block.segments{1, 1}.events{1, 1}.labels);
event_label = block.segments{1, 1}.events{1, 1}.an_trial_event_labels;

[r1,c1] = find(event_labelcode==65296);
r = r1;
HF_reject = [];
LF_reject = [];
Single_Nreuron = [];

for i=1:length(r1)-1
        if(block.segments{1, 1}.events{1, 1}.an_trial_reject_HFC(r1(i)) == 1)
            HF_reject = [HF_reject; r1(i)];
            r(i) = 0;
        end
        if(block.segments{1, 1}.events{1, 1}.an_trial_reject_LFC(r1(i)) == 1)
            LF_reject = [LF_reject; r1(i)];
            r(i) = 0;
        end
        if(isempty(find(event_labelcode(r1(i):r1(i+1))==65385 | event_labelcode(r1(i):r1(i+1))==65382, 1)))
            r(i) = 0;
        end
end

for i=1:length(block.segments{1,1}.spiketrains)
    if(block.segments{1, 1}.spiketrains{1, i}.an_sua==1)
        Single_Nreuron = [Single_Nreuron; i];
    end
end

% [r,c,v] = find(event_labelcode==65382 | event_labelcode==65385);
% [r,c,v] = find(event_labelcode==65365 | event_labelcode==65370);
sel = 1:length(r);
binsize = 1;

fs = 30000;

data = [];
normal = [];
t1 = [];
label = [];
for i=1:length(Single_Nreuron)
    d = block.segments{1,1}.spiketrains{1,Single_Nreuron(i)}.times();
    spk_ts = {};
    t_stop = [];
    d1 = [];
    n1 = [];
    for j=1:length(r)-1 
        if(r(j)~=0)
            q = r(j) + 5;
            label = [label; event_label(q,:)];
            t = event_time(q)<=d & d<event_time(q+1);
            p = d(t);
            d1 = [d1; length(p)/(event_time(q+1)-event_time(q))*30000];
            t = event_time(q-1)<=d & d<event_time(q);
            p = d(t);
            n1 = [n1; length(p)/(event_time(q)-event_time(q-1))*30000];
            t1 = [t1; event_time(q)-event_time(q-1) event_time(q+1)-event_time(q)];
        end
    end
    i
    data = [data; mean(d1)];
    normal = [normal; mean(n1)];
end
t1 = t1 ./ 30000;

figure;
set(gcf,'Color',[1 1 1]);
set(gca,'FontName','arial','FontSize',10); % Check this
histogram(data,25)
hold on
histogram(normal,25)
% xlim([0 2])
legend
[h,p] = ttest(data, normal)