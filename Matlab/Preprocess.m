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
