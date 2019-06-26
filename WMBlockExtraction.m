function [residuals] = WMBlockExtraction(res,nRuns)
% INPUT
%   X - residuals matrix from ar model
%   nRuns - number of WM runs concatenated 
% OUTPUT
%   residuals : matrix containing the residuals from the active blocks of
%   the task


%% Keep only specific columns (14-48, 52-86, 110-144, 148-182, 206-278, 302-374) for each run
residuals = [];
offset=10;
for i=0:nRuns-1
    residuals=[residuals res(:,[(14-offset+395*i):(48-offset+395*i) (52-offset+395*i):(86-offset+395*i) (110-offset+395*i):(144-offset+395*i) (148-offset+395*i):(182-offset+395*i) (206-offset+395*i):(278-offset+395*i) (302-offset+395*i):(374-offset+395*i)])];
end