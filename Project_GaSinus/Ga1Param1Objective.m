%% Init
nrVar=1;

% Set nondefault solver options
options = optimoptions("ga","OutputFcn",[@outputFcnTest],"MaxGenerations",30,...
    "PopulationSize",30,"Display","iter","PlotFcn",["gaplotscores",...
    "gaplotbestf","gaplotbestindiv","gaplotrange"]);

% Solve
[solution,objectiveValue] = ga(@objectiveFcn,nrVar,[],[],[],[],repmat(-1,...
    nrVar,1),repmat(3,nrVar,1),[],[],options);

% Clear variables
clearvars options

%% Objective Function

function f = objectiveFcn(optimInput)
% Example:
% Edit the lines below with your calculation
x = optimInput(1);
f = sin(x.^2);
end

%% Output function
% Output function after each generation

function [state,options,optchanged] = outputFcnTest(options,state,flag)
optchanged = false;
switch flag

    case 'init'

        fontSize = 14;

        % Plot init
        state.fig=figure;
        state.fig.WindowState = 'maximized';%set(gcf, 'Position', get(0, 'Screensize'));
        set(gcf,'Visible','on'); % to make it visible outside the editor
        x=-1:0.01:3;
        for ii=1:numel(x)
            y(ii)=objectiveFcn(x(ii));
        end
        state.ax=subplot(1,1,1);
        plot(x,y,'LineWidth',2); grid on; xlabel('x','FontSize', fontSize);ylabel('y','FontSize', fontSize);
        set(gca,'FontSize',fontSize)
        title('Find the global minimun of the function sin(x^2), x=[-1 3]','FontSize', fontSize);

    case 'iter'

        % Get top n values
        [~,indTop]      = sort(state.Score);
        topScore        = state.Score(indTop);
        topPopulation   = state.Population(indTop);

        n               = 1;
        topScore        = topScore(1:n);
        topPopulation   = topPopulation(1:n);

        % Plot iter
        %plot(state.ax,topPopulation,topScore,'o');
        hold(state.ax,'on');
        try
            delete(state.p);
        end
        state.p=plot(state.ax,state.Population,state.Score,'o','MarkerSize',10,'LineWidth',2);
        %xlim([-10,10]);ylim([0,100]);
        title(state.ax,['Generation:' num2str(state.Generation) '  ==>  Best solution found: y:' num2str(topScore(1))  ' at x:' num2str(topPopulation(1))]);
        pause(1);
    case 'done'

end
end
