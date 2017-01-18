%% PRESETSTORE
% presetStore wird von Risikometer aufgerufen. presetStore ist eine
% Sammlung von Voreinstellungen für die Graphiken, welche in einer
% Risikometerstudie produziert werden können.
% To do: Voreinstellungen sollten extern abgespeichert werden z.B. in
% einer .txt-Datei oder Datenbank um dann von presetStore eingelesen zu
% werden.
% % ---
% Funktionsargumente:
% -input: Struct mit Input-Daten
% -output: Struct mit Output-Daten
% -indexOutput: indiziert effektive, berechnete Outputs
% -superOutput: Output-übergreiffende Berechnungen
% -erfassungsjahr: Erfassungsjahr
% -indexPlotTypes: Array mit zu berechnende Plottypen
%   -> 1: Barplots
%   -> 2: Lineplots
%   -> 3: Flächenplots
%   -> 4: Bar-Line-Plots (wird zur Zeit nicht verwendet)
%   -> 5: Box-Plots
%   -> 6: Box-Line-Plots
% -auswahl: Struct mit zu plottenden Graphiken
% -graphikHandling: Struct mit Information über den Umgang mit Graphiken
% (speichern / nicht speichern / schliessen nach Speichern)
% -risikoLeistungAusmitteln: boolsche Variable. Gibt Auskunft, ob im
% Risiko-Leistungsdiagramm die Pfade durch Ausmitteln geglättet werden
% sollen.
% -checkboxSzenarienVergleichState: indiziert zu plottende
% Szenarien-Vergleichende Plots
% -kundenName: Name des Kunden
% -folderStructure: Struct mit Ordnerstruktur zum Abspeichernd er Graphiken
%
% Rückgabewerte:
% - figureCollection (wird zur Zeit nicht weiterverwendet)
% - safeFigureDataCollection (wird zur Zeit nicht weiterverwendet)

function [figureCollection, safeFigureDataCollection] = presetStore(parameters)
global lineColorMapStandard;
figureCollection = [];
safeFigureDataCollection = [];

if parameters.plotsSelected
  
  presetMsgbox = msgbox('Graphiken werden produziert...');
  anzahlPfade  = parameters.anzahlPfade;
  
  totalOutput                     = parameters.output;
  output                          = totalOutput;
  superOutput                     = parameters.superOutput;
  erfassungsjahr                  = parameters.erfassungsjahr;
  indexPlotTypes                  = parameters.indexPlotTypes;
  auswahl                         = parameters.auswahl;
  graphikHandling                 = parameters.graphikHandling;
  risikoLeistungAusmitteln        = parameters.risikoLeistungAusmitteln;
  checkboxSzenarienVergleichState = parameters.checkboxSzenarienVergleichState;
  kundenName                      = parameters.kundenName;
  folderStructure                 = parameters.folderStructure;
  tOriginal                       = parameters.tOriginal;
  plotsProPlan                    = parameters.plotsProPlan;
  timeStamp                       = setTimeString('footer');
  numOfOutputs                    = length(totalOutput);
  titelEinfach                    = ~graphikHandling.achsenanschriftDetailiert;
  basicPlotSettings               = parameters.basicPlotSettings;
  
  plotStruct.tag                 = '';
  plotStruct.legendPosition      = 'northEast'; % Standard, falls abweichend, im folgenden Code anpassen... wird in plotNow für jeden Plot wieder neu gesetzt.
  
  %% Settings
  % Figure-Settings
  figureBackgroundColor  = [0.9, 0.9, 0.9];
  standardFigureSettings = {'Color', figureBackgroundColor; ...
    'Name', 'Plot';       ...
    'NumberTitle', 'off'; ...
    'menubar', 'figure';  ...
    'Position', [300 200 1000 700]};
  
  % Line-Settings
  standardLineSettings = {'LineWidth', 2.0; 'Marker', 'none'};
  lineSettingsDick     = {'LineWidth', 4.0; 'Marker', 'none'};
  lineSettingsMittel   = {'LineWidth', 3.0; 'Marker', 'none'};
  lineSettingsDuenn    = {'LineWidth', 2.0; 'Marker', 'none'};
  lineSettingsDgPfade  = {'LineWidth', 1.0; 'Marker', 'none'};
  
  % Axes-Settings
  standardAxesSettings = {'Color', [1.0, 1.0, 1.0]; ...
    'FontName', 'MISO';     ... 'Vectora LH Light'; ...
    'FontSize', 17;         ...
    'FontWeight', 'normal'; ...
    'LineWidth', 0.5;       ...
    'TickDir', 'in';        ... % 'XTickLabel', xTickLabels; ...
    'XGrid', 'on';          ...
    'YGrid', 'on';          ...
    'GridLineStyle', '-';   ...
    'Box', 'on'};
  standardAxesSettingsRisikoLeistung = {'Color', [1.0, 1.0, 1.0]; ...
    'FontName', 'MISO';     ... 'Vectora LH Light'; ...
    'FontSize', 18;         ...
    'FontWeight', 'normal'; ...
    'LineWidth', 0.5;       ...
    'TickDir', 'in';        ... % 'XTickLabel', xTickLabels; ...
    'XGrid', 'on';          ...
    'YGrid', 'on';          ...
    'GridLineStyle', '-';   ...
    'position', [.1, .13, .8, .75]; ...
    'Box', 'on'};
  % Fusszeile-Settings (Initialisierung)
  fusszeileSettings = [];
  
  %% Colormaps
  roteFlaecheRoot   = [0.9922, 0.4219, 0.4063];
  roteFlaeche       = heller(roteFlaecheRoot, 0.4);
  gelbeFlaecheRoot  = [0.9492, 0.9492, 0.2227];
  gelbeFlaeche      = heller(gelbeFlaecheRoot, 0.4);
  grueneFlaecheRoot = [0.4727, 0.9219, 0.25];
  grueneFlaeche     = heller(grueneFlaecheRoot, 0.4);
  
  greenOlive      = [172, 202, 144] / 256;
  greenOzean      = [141, 205, 167] / 256;
  
  orangeRoot      = [255, 180, 79] / 256;
  
  blueRoot        = [0.2, 0.2, 1.0];
  blueHalfLight   = heller(blueRoot, 0.8);
  blueLight       = heller(blueRoot, 0.4);
  
  yellowRoot      = [246, 199, 0] / 256;
  yellowHalfLight = heller(yellowRoot, 0.8);
  yellowLight     = heller(yellowRoot, 0.4);
  
  greenRoot       = [50, 160, 110] / 256;
  greenHalfLight  = heller(greenRoot, 0.8);
  greenLight      = heller(greenRoot, 0.4);
  
  lineColorMapBlue      = [blueRoot; blueHalfLight; blueLight];
  lineColorMapGreen     = [greenRoot; greenHalfLight; greenLight];
  lineColorMapBlueGreen = [blueRoot; blueHalfLight; blueLight; greenRoot; greenHalfLight; greenLight];
  
  lilaRoot           = [164, 89, 179] / 256;
  darkRedRoot        = [0.5195, 0.1250, 0.0820];
  darkGreenRoot      = [50, 130, 52] / 256;
  
  greyRoot           = [150, 150, 150] / 256;
  backgroundColorMap = [heller(greyRoot, 0.4); heller(greyRoot, 0.8); greyRoot];
  
  if isempty(lineColorMapStandard)
    lineColorMapStandard = [51.2, 51.2, 256; ...
      0   , 128 , 0;   ...
      128 , 0   , 0;   ...
      255 , 190 , 17;  ...
      194 , 94  , 196; ...
      0   , 255 , 0;   ...
      190 , 245 , 35;  ...
      56  , 232 , 198; ...
      113 , 52  , 253; ...
      255 , 100 , 0;   ...
      139 , 229 , 127; ...
      181 , 147 , 209; ...
      151 , 205 , 205; ...
      127 , 184 , 50;  ...
      0   , 255 , 255; ...
      51.2, 51.2, 256] ...
      / 256;
  end
  
  arrowColorMapStandard = [0 0 0; 0 0 0; .1 .1 .1; .1 .1 .1; .2 .2 .2; .2 .2 .2; .3 .3 .3; ...
    .3 .3 .3; .4 .4 .4; .4 .4 .4; .5 .5 .5; .5 .5 .5; .6 .6 .6; .6 .6 .6; .7 .7 .7; ...
    .7 .7 .7; .8 .8 .8; .8 .8 .8; .9 .9 .9; .9 .9 .9; 1 1 1; 1 1 1];
  lineColorMapRisikoPlot = [[0, 0, 0; 256, 0, 0; 7, 44, 231] / 256; ...
    darkGreenRoot ; darkRedRoot ; ...
    darkGreenRoot ; darkRedRoot ; ...
    darkGreenRoot ; darkRedRoot ; ...
    ];
  areaColorMap  = [roteFlaeche; gelbeFlaeche; grueneFlaeche];
  areaColorMap2 = [gelbeFlaeche; gelbeFlaeche; gelbeFlaeche];
  
  %% Parameter
  % Erfassungsjahr, Projektionsspanne, xAchse
  projektionsSpanne    = tOriginal;
  xAchseLang           = erfassungsjahr:erfassungsjahr + projektionsSpanne;
  xAchseKurz           = erfassungsjahr:erfassungsjahr + projektionsSpanne - 1;
  xAchseRisikoLeistung = erfassungsjahr:erfassungsjahr + projektionsSpanne - 10;
  s_m = 25;
  
  % Parameter
  xLimBestand         = [20,115];
  xLimBestandAktive   = [17,115];
  xLimAghAktive       = [17,70];
  xTicksBestand       = 25:5:110;
  xTicksBestandAktive = 15:5:110;
  xTicksAghAktive     = 15:5:70;
  xLimProjektionLang  = [erfassungsjahr - 1, erfassungsjahr + projektionsSpanne + 1];
  xLimProjektionKurz  = [erfassungsjahr - 1, erfassungsjahr + projektionsSpanne];
  xLimRisikoLeistung  = [erfassungsjahr, erfassungsjahr + projektionsSpanne - 10];
  yLimSollrendite     = [0.0, 0.05];
  yLimLeistung        = [0.0, 1.0];
  yLimFlaechenPlot    = [70, 140];
  
  %% Plot Presets
  szenario = {'(Basis)', '(Variante 1)', '(Variante 2)', '(Variante 3)', '(Variante 4)', '(Variante 5)', ...
    '(Variante 6)', '(Variante 7)', '(Variante 8)', '(Variante 9)', '(Variante 10)', ...
    '(Variante 11)', '(Variante 12)', '(Variante 13)', '(Variante 14)', '(Variante 15)'};
  numOfSzenarios = length(szenario);
  szenarioUebergreifendePlots = false;
  
  
  arguments.szenario                    = szenario;
  arguments.risikoLeistungAusmitteln    = risikoLeistungAusmitteln;
  arguments.indexRLDiagramm             = [];
  arguments.shortLength                 = [];
  arguments.titelEinfach                = titelEinfach;
  arguments.timeStamp                   = timeStamp;
  arguments.graphikHandling             = graphikHandling;
  arguments.kundenName                  = kundenName;
  arguments.auswahl                     = auswahl;
  arguments.szenarioUebergreifendePlots = szenarioUebergreifendePlots;
  arguments.folderStructure             = folderStructure;
  arguments.fusszeileSettings           = fusszeileSettings;
  arguments.figureBackgroundColor       = figureBackgroundColor;
  arguments.s_m                         = s_m;
  arguments.erfassungsjahr              = erfassungsjahr;
  
  % Anzahl maximaler Szenarien abfangen
  if numOfOutputs > numOfSzenarios
    uiwait(msgbox(['Es sind höchstens ', num2str(numOfSzenarios), ' Szenarien erlaubt!']))
    mmax = numOfSzenarios;
  else
    mmax = numOfOutputs;
  end
  
  for m = 1:mmax
    szenarioOutput     = totalOutput{m};
    arguments.output   = szenarioOutput;
    arguments.idxSzen  = m;
    arguments.numPlans = length(szenarioOutput);

    startIdx = setStartIndex(length(szenarioOutput),plotsProPlan);
    for idxPlan = startIdx:length(szenarioOutput)
      arguments.idxPlan = idxPlan;
      
      if checkboxSzenarienVergleichState(m)
        % Indizes
        plotArt = auswahl.plotArt;
        plotGattung = auswahl.plotGattung;
        if m == 1 || m > 1
          plotNumbers = setPlotNumbers(plotArt,plotGattung,auswahl);
          
          indexBestandBarplots  = plotNumbers{1}{1};
          indexBestandLineplots = plotNumbers{1}{2};
          indexFinanzBarplots   = plotNumbers{2}{1};
          indexFinanzLineplots  = plotNumbers{2}{2};
          indexRisikoFlaechen   = plotNumbers{3}{1};
          indexBoxplots         = plotNumbers{4}{1};
          indexBoxLinePlots     = plotNumbers{4}{2};
        end
        
        for j = indexPlotTypes
          plotStruct.numPlansKonsolidiert = length(szenarioOutput);
          plotStruct.idxPlan              = idxPlan;
          switch j
            case 6
              %% Box-Line-Plots
                for k = indexBoxLinePlots
                  switch k
                    case 1 % Ersatzquote Box & Line
                      tempData = 100 * ausmitteln(szenarioOutput{idxPlan}.ErsatzquoteAkt2AltT_pK_Perzentilen); % bereits skaliert
                      % Plottype: wird zum Abspeichern benötgt
                      plotStruct.plotName = 'Ersatzquote_Box_Line_Plot';
                      plotStruct.plotArt = 'boxLinePlot';
                      
                      % Zusätzliche (plotspezifische) Settings
                      additionalAxesSettings = {'XLim', [1 20]};
                      plotName = 'Ersatzquote_Box_Line_Plot';
                      
                      % Angaben zu den zu plottenden Datenreihen
                      % Datenreihen
                      plotStruct.vectors{1}.data = median(tempData);
                      plotStruct.vectors{1}.boxPlotData = tempData;
                      % Colormap
                      plotStruct.lineColorMap = lineColorMapBlue;
                      % Legenden
                      plotStruct.vectors{1}.legende = {'Ersatzquote','Median','75%-Quantil','90%-Quantil'};
                      
                      % Farbe
                      plotStruct.vectors{1}.color = lineColorMapStandard(m,:);
                      
                      % Line-Settings
                      plotStruct.lineSettings{1} = standardLineSettings;
                      
                      % Sonstige Beschriftungen
                      plotStruct.xLabel = 'Jahr';
                      plotStruct.yLabel = 'Leistung';
                      plotStruct.title  = 'Ersatzquote Box-Line';
                      
                      % x-Ticks
                      plotStruct.xAchse = 1:20;
                      
                      % Setzt Definitionsbereich der Datenreihen
                      for l = 1:1
                        plotStruct.vectors{l}.domain = plotStruct.xAchse;
                      end
                      
                      % x-Tick-Labels
                      plotStruct.yTickLabelType = 'prozent';
                      plotStruct.xTickLabelType = 'boxLinePlot';
                  end
                  [plotStruct,plotName] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,m,szenarioUebergreifendePlots,'boxLinePlot');
arguments.plotStruct    = plotStruct;
arguments.indexPlotType = j;
                  plotStruct = plotNow(arguments);
                end
              
            case 5
              %% Box-Plots
                for k = indexBoxplots
                  switch k
                    case 1 % Deckungsgrad
                      tempData = szenarioOutput{idxPlan}.DgQuantil_alle_ZF{1};
                      sizeTempData = size(tempData,2);
                      plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings.boxplot1,'color',lineColorMapStandard(m,:),'szenarioUebergreifendePlots',false,'boxPlotData',tempData,'indexSzenario',m,...
                        'indexPlotType',j,'xAchse',erfassungsjahr:erfassungsjahr + sizeTempData,'legende',{'Median';'75%-Quantil'; '90%-Quantil'},'standardFigureSettings',standardFigureSettings,...
                        'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim', [0,sizeTempData];'YLim',yLimFlaechenPlot;'XGrid','off';'YGrid','on'});
                    case 2 % Ersatzquote
                      tempData = ausmitteln(szenarioOutput{idxPlan}.ErsatzquoteAkt2AltT_pK_Perzentilen);
                      sizeTempData = size(tempData,2);
                      plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings.boxplot2,'color',lineColorMapStandard(m,:),'szenarioUebergreifendePlots',false,'boxPlotData',tempData,'indexSzenario',m,...
                        'indexPlotType',j,'xAchse',erfassungsjahr:erfassungsjahr + sizeTempData,'legende',{'Median';'75%-Quantil'; '90%-Quantil'},'standardFigureSettings',standardFigureSettings,...
                        'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim', [0,sizeTempData + 1];'XGrid','off';'YGrid','off'});
                    case 3 % Verzinsung
                      tempData = szenarioOutput{idxPlan}.r_Perzentilen;
                      plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings.boxplot3,'color',lineColorMapStandard(m,:),'szenarioUebergreifendePlots',false,'boxPlotData',tempData,'indexSzenario',m,...
                        'indexPlotType',j,'xAchse',erfassungsjahr:erfassungsjahr + projektionsSpanne,'legende',{'Median';'75%-Quantil'; '90%-Quantil'},'standardFigureSettings',standardFigureSettings,...
                        'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim', [0,projektionsSpanne + 1];'XGrid','off';'YGrid','off'});
                    case 4 % Beiträge
                      tempData = szenarioOutput{idxPlan}.SanierungsBg_Perzentilen;
                      sizeTempData = size(tempData,2);
                      plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings.boxplot4,'color',lineColorMapStandard(m,:),'szenarioUebergreifendePlots',false,'boxPlotData',tempData,'indexSzenario',m,...
                        'indexPlotType',j,'xAchse',erfassungsjahr:erfassungsjahr + sizeTempData,'legende',{'Median';'75%-Quantil'; '90%-Quantil'},'standardFigureSettings',standardFigureSettings,...
                        'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim', [0,sizeTempData + 1];'XGrid','off';'YGrid','off'},'skalierungsFaktor',1);
                    case 5 % normiertes AGH
                      tempData = szenarioOutput{idxPlan}.normedAGH_Perzentilen;
                      sizeTempData = size(tempData,2);
                      plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings.boxplot5,'color',lineColorMapStandard(m,:),'szenarioUebergreifendePlots',false,'boxPlotData',tempData,'indexSzenario',m,...
                        'indexPlotType',j,'xAchse',szenarioOutput{idxPlan}.s_m:szenarioOutput{idxPlan}.s_m + sizeTempData,'legende',{'Median';'75%-Quantil'; '90%-Quantil'},'standardFigureSettings',standardFigureSettings,...
                        'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim', [0,sizeTempData + 1];'XGrid','on';'YGrid','on'},'skalierungsFaktor',1);
                    case 6 % Streuung der Rente im Schlussalter bei Stichalter 58-65
                      tempData = fliplr(szenarioOutput{idxPlan}.leistung65_Perzentilen);
                      sizeTempData = size(tempData,2);
                      plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings.boxplot6,'color',lineColorMapStandard(m,:),'szenarioUebergreifendePlots',false,'boxPlotData',tempData,'indexSzenario',m,...
                        'indexPlotType',j,'xAchse',fliplr(szenarioOutput{idxPlan}.s_m:szenarioOutput{idxPlan}.s_m + sizeTempData),'legende',{'Median';'75%-Quantil'; '90%-Quantil'},...
                        'standardFigureSettings',standardFigureSettings,'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim', [0,sizeTempData + 1];'XGrid','on';'YGrid','on'},'skalierungsFaktor',1);
                  end
                end
            case 1 % Barplots
              %% Barplots
              tempOutput = szenarioOutput{idxPlan};
              for k = indexBestandBarplots
                switch k
                  case 1 % Barplot 1: Anzahl Rentner nach Altersklassen -> Verteilung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandbar1,'additionalAxesSettings',{'XLim', xLimBestand},'xAchse',xTicksBestand,...
                      'data',tempOutput.anzahlRentnerTotal5JahreAb25(:,1)' - tempOutput.anzahlRentnerNeu5JahreAb25(:,1)','-pos',[1,1],'data',tempOutput.anzahlRentnerNeu5JahreAb25(:,1)','-pos',[2,1],...
                      'data',tempOutput.anzahlRentnerTotal5JahreAb25(:,8)' - tempOutput.anzahlRentnerNeu5JahreAb25(:,8)','-pos',[1,2],'data',tempOutput.anzahlRentnerNeu5JahreAb25(:,8)','-pos',[2,2],...
                      'data',tempOutput.anzahlRentnerTotal5JahreAb25(:,15)' - tempOutput.anzahlRentnerNeu5JahreAb25(:,15)','-pos',[1,3],'data',tempOutput.anzahlRentnerNeu5JahreAb25(:,15)','-pos',[2,3],...
                      'barColorMap',greenRoot,'-pos',[1,1],'barColorMap',yellowRoot,'-pos',[2,1],'barColorMap',greenHalfLight,'-pos',[1,2],...
                      'barColorMap',yellowHalfLight,'-pos',[2,2],'barColorMap',greenLight,'-pos',[1,3],'barColorMap',yellowLight,'-pos',[2,3],...
                      'legende',{'Rentner Jahr 1'},'-pos',[1,1],'legende',{'Neue Rentner Jahr 1'},'-pos',[2,1],'legende',{'Rentner Jahr 8'},'-pos',[1,2],...
                      'legende',{'Neue Rentner Jahr 8'},'-pos',[2,2],'legende',{'Rentner Jahr 15 '},'-pos',[1,3],'legende',{'Neue Rentner Jahr 15 '},'-pos',[2,3]);
                  case 2 % Barplot 2: Anzahl Aktive & Rentner Bestandesentwicklung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandbar2,'additionalAxesSettings',{'XLim', xLimProjektionLang},'xAchse',xAchseLang,...
                      'data',tempOutput.anzahlAktiveNeuTotal,'-pos',[1,1],'data',tempOutput.Akt - tempOutput.anzahlAktiveNeuTotal,'-pos',[2,1],...
                      'data',tempOutput.Wit,'-pos',[1,2],'data',tempOutput.Inv,'-pos',[2,2],'data',tempOutput.Alt,'-pos',[3,2],...
                      'barColorMap',yellowRoot,'-pos',[1,1],'barColorMap',blueRoot,'-pos',[2,1],'barColorMap',greenOlive,'-pos',[1,2],...
                      'barColorMap',greenOzean,'-pos',[2,2],'barColorMap',greenRoot,'-pos',[3,2],...
                      'legende',{'Anzahl neue Aktive'},'-pos',[1,1],'legende',{'Anzahl Aktive (ohne Neue)'},'-pos',[2,1],'legende',{'Anzahl Witwen-Rentner'},'-pos',[1,2],...
                      'legende',{'Anzahl Invaliden-Rentner'},'-pos',[2,2],'legende',{'Anzahl Alters-Rentner'},'-pos',[3,2]);
                  case 3 % Barplot 5: Anzahl Aktive nach Altersklassen -> Verteilung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandbar3,'additionalAxesSettings',{'XLim', xLimBestandAktive},'xAchse',xTicksBestandAktive,...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,1)' - tempOutput.anzahlAktiveNeu5JahreAb15(:,1)','-pos',[1,1],'data',tempOutput.anzahlAktiveNeu5JahreAb15(:,1)','-pos',[2,1],...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,8)' - tempOutput.anzahlAktiveNeu5JahreAb15(:,8)','-pos',[1,2],'data',tempOutput.anzahlAktiveNeu5JahreAb15(:,8)','-pos',[2,2],...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,15)' - tempOutput.anzahlAktiveNeu5JahreAb15(:,15)','-pos',[1,3],'data',tempOutput.anzahlAktiveNeu5JahreAb15(:,15)','-pos',[2,3],...
                      'barColorMap',blueRoot,'-pos',[1,1],'barColorMap',yellowRoot,'-pos',[2,1],'barColorMap',blueHalfLight,'-pos',[1,2],...
                      'barColorMap',yellowHalfLight,'-pos',[2,2],'barColorMap',blueLight,'-pos',[1,3],'barColorMap',yellowLight,'-pos',[2,3],...
                      'legende',{'Aktive Jahr 1'},'-pos',[1,1],'legende',{'Neue Aktive Jahr 1'},'-pos',[2,1],'legende',{'Aktive Jahr 8'},'-pos',[1,2],...
                      'legende',{'Neue Aktive Jahr 8'},'-pos',[2,2],'legende',{'Aktive Jahr 15 '},'-pos',[1,3],'legende',{'Neue Aktive Jahr 15 '},'-pos',[2,3]);
                  case 4 % Barplot 6: Anzahl Aktive / Rentner nach Altersklassen -> Verteilung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandbar4,'additionalAxesSettings',{'XLim', xLimBestandAktive},'xAchse',xTicksBestandAktive,...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,1)','data',tempOutput.anzahlAktiveTotal5JahreAb15(:,8)',...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,15)','data',tempOutput.anzahlRentnerTotal5JahreAb15(:,1)',...
                      'data',tempOutput.anzahlRentnerTotal5JahreAb15(:,8)','data',tempOutput.anzahlRentnerTotal5JahreAb15(:,15)',...
                      'barColorMap',blueRoot,'barColorMap',blueHalfLight,'barColorMap',blueLight,'barColorMap',greenRoot,'barColorMap',greenHalfLight,'barColorMap',greenLight,...
                      'legende',{'Aktive Jahr 1'},'legende',{'Aktive Jahr 8'},'legende',{'Aktive Jahr 15'},...
                      'legende',{'Rentner Jahr 1'},'legende',{'Rentner Jahr 8 '},'legende',{'Rentner Jahr 15 '});
                  case 5 % Barplot 10: Anzahl Aktive & Rentner nach Altersklassen (übereinander)
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandbar5,'additionalAxesSettings',{'XLim', xLimProjektionLang},'xAchse',xAchseLang,...
                      'data',tempOutput.Wit,'-pos',[1,1],'data',tempOutput.Inv,'-pos',[2,1],...
                      'data',tempOutput.Alt,'-pos',[3,1],'data',tempOutput.anzahlAktiveNeuTotal,'-pos',[4,1],...
                      'data',tempOutput.Akt - tempOutput.anzahlAktiveNeuTotal,'-pos',[5,1],...
                      'barColorMap',greenOlive,'-pos',[1,1],'barColorMap',greenOzean,'-pos',[2,1],'barColorMap',greenRoot,'-pos',[3,1],'barColorMap',yellowRoot,'-pos',[4,1],'barColorMap',blueRoot,'-pos',[5,1],...
                      'legende',{'Anzahl Witwen-Rentner'},'-pos',[1,1],'legende',{'Anzahl Invaliden-Rentner'},'-pos',[2,1],'legende',{'Anzahl Alters-Rentner'},'-pos',[3,1],...
                      'legende',{'Anzahl neue Aktive'},'-pos',[4,1],'legende',{'Anzahl Aktive (ohne Neue)'},'-pos',[5,1]);
                  otherwise
                end
                index = 1;
                plotType = 'barPlot';
                [plotStruct,plotName] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,index,szenarioUebergreifendePlots,plotType);
arguments.plotStruct    = plotStruct;
arguments.indexPlotType = j;
                plotStruct = plotNow(arguments);
              end
              tempOutput = szenarioOutput{idxPlan};
              for k = indexFinanzBarplots
                switch k
                  case 1 % Barplot 3: AGH-DK-Entwicklung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar1,'additionalAxesSettings',{'XLim', xLimProjektionLang},'xAchse',xAchseLang,...
                      'data',tempOutput.aghTotal,'data',tempOutput.Dk,'barColorMap',blueRoot,'barColorMap',greenRoot,'legende',{'AGH Aktive Total'},'legende',{'DK Rentner Total '});
                  case 2 % Barplot 4: Netto-Cashflow
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar2,'additionalAxesSettings',{'XLim', xLimProjektionKurz},'xAchse',xAchseKurz,...
                      'data',tempOutput.nettoCashFlowPlus - tempOutput.nettoCashFlowMinus,'-pos',[1,1],'data',tempOutput.nettoCashFlowMinus,'-pos',[2,1],'data',tempOutput.nettoCashFlowTotal,'-pos',[1,2],...
                      'barColorMap',lilaRoot,'-pos',[1,1],'barColorMap',orangeRoot,'-pos',[2,1],'barColorMap',darkRedRoot,'-pos',[1,2],...
                      'legende',{'Netto-Cash-Flow (In-Flow)'},'-pos',[1,1],'legende',{'Netto-Cash-Flow (Out-Flow)'},'-pos',[2,1],'legende',{'Netto-Cash-Flow (Total)'},'-pos',[1,2]);
                  case 3 % Barplot 7: AGH Aktive / DK Rentner / Rückstellungen
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar3,'additionalAxesSettings',{'XLim', xLimProjektionKurz},'xAchse',xAchseLang,...
                      'data',tempOutput.Ru,'-pos',[1,1],'data',tempOutput.Dk,'-pos',[2,1],'data',tempOutput.aghTotal,'-pos',[3,1],...
                      'barColorMap',orangeRoot,'-pos',[1,1],'barColorMap',greenRoot,'-pos',[2,1],'barColorMap',blueRoot,'-pos',[3,1],...
                      'legende',{'Rückstellungen '},'-pos',[1,1],'legende',{'DK Rentner'},'-pos',[2,1],'legende',{'AGH Aktive'},'-pos',[3,1]);
                  case 4 % Barplot 8: AGH Aktive nach Altersklassen -> Verteilung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar4,'additionalAxesSettings',{'XLim', xLimAghAktive},'xAchse',xTicksAghAktive,...
                      'data',tempOutput.aghAktiveTotal5JahreAb15Bis70(:,1)','-pos',[1,1],'data',tempOutput.aghAktiveTotal5JahreAb15Bis70(:,8)','-pos',[1,2],'data',tempOutput.aghAktiveTotal5JahreAb15Bis70(:,15)','-pos',[1,3],...
                      'barColorMap',blueRoot,'-pos',[1,1],'barColorMap',blueHalfLight,'-pos',[1,2],'barColorMap',blueLight,'-pos',[1,3],...
                      'legende',{'DK Aktive Jahr 1'},'-pos',[1,1],'legende',{'DK Aktive Jahr 8'},'-pos',[1,2],'legende',{'DK Aktive Jahr 15'},'-pos',[1,3]);
                  case 5 % Barplot 9: DK Rentner nach Altersklassen -> Verteilung
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar5,'additionalAxesSettings',{'XLim', xLimBestand},'xAchse',xTicksBestand,...
                      'data',tempOutput.dkRentnerTotal5JahreAb25(:,1)','-pos',[1,1],'data',tempOutput.dkRentnerTotal5JahreAb25(:,8)','-pos',[1,2],'data',tempOutput.dkRentnerTotal5JahreAb25(:,15)','-pos',[1,3],...
                      'barColorMap',greenRoot,'-pos',[1,1],'barColorMap',greenHalfLight,'-pos',[1,2],'barColorMap',greenLight,'-pos',[1,3],...
                      'legende',{'DK Rentner Jahr 1'},'-pos',[1,1],'legende',{'DK Rentner Jahr 8'},'-pos',[1,2],'legende',{'DK Rentner Jahr 15'},'-pos',[1,3]);
                  case 6 % Barplot 11: AGH Aktive / DK Rentner nach Rentenart
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar6,'additionalAxesSettings',{'XLim', xLimProjektionLang},'xAchse',xAchseLang,...
                      'data',tempOutput.aghTotal,'-pos',[1,1],'data',tempOutput.DkWit,'-pos',[1,2],'data',tempOutput.DkInv,'-pos',[2,2],'data',tempOutput.DkAlt,'-pos',[3,2],...
                      'barColorMap',blueRoot,'-pos',[1,1],'barColorMap',greenOlive,'-pos',[1,2],'barColorMap',greenOzean,'-pos',[2,2],'barColorMap',greenRoot,'-pos',[3,2],...
                      'legende',{'AGH Aktive'},'-pos',[1,1],'legende',{'DK Witwenrentner'},'-pos',[1,2],'legende',{'DK Invalidenrentner'},'-pos',[2,2],'legende',{'DK Altersrentner'},'-pos',[3,2]);
                  case 7 % Barplot 12: AGH Aktive / DK Rentner nach Rentenart / Rückstellungen
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar7,'additionalAxesSettings',{'XLim', xLimProjektionLang},'xAchse',xAchseLang,...
                      'data',tempOutput.Ru,'-pos',[1,1],'data',tempOutput.DkWit,'-pos',[2,1],'data',tempOutput.DkInv,'-pos',[3,1],'data',tempOutput.DkAlt,'-pos',[4,1],'data',tempOutput.aghTotal,'-pos',[5,1],...
                      'barColorMap',orangeRoot,'-pos',[1,1],'barColorMap',greenOlive,'-pos',[2,1],'barColorMap',greenOzean,'-pos',[3,1],'barColorMap',greenRoot,'-pos',[4,1],'barColorMap',blueRoot,'-pos',[5,1],...
                      'legende',{'Rückstellungen'},'-pos',[1,1],'legende',{'DK Witwenrentner'},'-pos',[2,1],'legende',{'DK Invalidenrentner'},'-pos',[3,1],'legende',{'DK Altersrentner'},'-pos',[4,1],...
                      'legende',{'AGH Aktive'},'-pos',[5,1]);
                  case 8 % Barplot 13: versicherte Lohnsumme / AGH Aktive / DK Rentner / Rückstellungen
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzbar8,'additionalAxesSettings',{'XLim', xLimProjektionLang},...
                      'title',{'Entwicklung Versicherte Lohnsumme / AGH Aktive /';'/ DK Rentner / Rückstellungen '},'xAchse',xAchseLang,...
                      'data',tempOutput.Lohn,'-pos',[1,1],'data',tempOutput.Ru,'-pos',[1,2],'data',tempOutput.Dk,'-pos',[2,2],'data',tempOutput.aghTotal,'-pos',[3,2],...
                      'barColorMap',darkRedRoot,'-pos',[1,1],'barColorMap',orangeRoot,'-pos',[1,2],'barColorMap',greenRoot,'-pos',[2,2],'barColorMap',blueRoot,'-pos',[3,2],...
                      'legende',{'versicherte Lohnsumme'},'-pos',[1,1],'legende',{'Rückstellungen'},'-pos',[1,2],'legende',{'DK Rentner'},'-pos',[2,2],'legende',{'AGH Aktive'},'-pos',[3,2]);
                  otherwise
                end
                [plotStruct,plotName] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,m,szenarioUebergreifendePlots,'barPlot');
arguments.plotStruct    = plotStruct;
arguments.indexPlotType = j;
                plotStruct = plotNow(arguments);
              end
            case 2 % Lineplots
              %% Lineplots
              tempOutput = szenarioOutput{idxPlan};
              for k = indexBestandLineplots
                switch k
                  case 1 % Lineplot 1: Verteilung Rentner nach Altersklassen
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandline1,'additionalAxesSettings',{'XLim', xLimBestand},'xAchse',xTicksBestand,...
                      'data',tempOutput.anzahlRentnerTotal5JahreAb25(:,1)','data',tempOutput.anzahlRentnerTotal5JahreAb25(:,8)','data',tempOutput.anzahlRentnerTotal5JahreAb25(:,15)',...
                      'domain',xTicksBestand,'lineSettings',{lineSettingsDick,lineSettingsMittel,lineSettingsDuenn},'lineColorMap',lineColorMapGreen,'legende','Jahr 1','legende','Jahr 8','legende','Jahr 15');
                  case 2 % Lineplot 3: Verteilung Aktive / Rentner nach Altersklassen
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandline2,'additionalAxesSettings',{'XLim', xLimBestandAktive},'xAchse',xTicksBestandAktive,...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,1)','data',tempOutput.anzahlAktiveTotal5JahreAb15(:,8)','data',tempOutput.anzahlAktiveTotal5JahreAb15(:,15)',...
                      'data',tempOutput.anzahlRentnerTotal5JahreAb15(:,1)','data',tempOutput.anzahlRentnerTotal5JahreAb15(:,8)','data',tempOutput.anzahlRentnerTotal5JahreAb15(:,15)',...
                      'domain',xTicksBestandAktive,'lineSettings',{lineSettingsDick,lineSettingsMittel,lineSettingsDuenn,lineSettingsDick,lineSettingsMittel,lineSettingsDuenn},...
                      'lineColorMap',lineColorMapBlueGreen,'legende','Aktive Jahr 1','legende','Aktive Jahr 8','legende','Aktive Jahr 15','legende','Rentner Jahr 1','legende','Rentner Jahr 8','legende','Rentner Jahr 15');
                  case 3 % Lineplot 5: Verteilung Aktive nach Altersklassen
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.bestandline3,'additionalAxesSettings',{'XLim', xLimBestand},'xAchse',xTicksBestandAktive,...
                      'data',tempOutput.anzahlAktiveTotal5JahreAb15(:,1)','data',tempOutput.anzahlAktiveTotal5JahreAb15(:,8)','data',tempOutput.anzahlAktiveTotal5JahreAb15(:,15)',...
                      'domain',xTicksBestandAktive,'lineSettings',{lineSettingsDick,lineSettingsMittel,lineSettingsDuenn},'lineColorMap',lineColorMapBlue,'legende','Jahr 1','legende','Jahr 8','legende','Jahr 15');
                  otherwise
                end
                [plotStruct,plotName] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,m,szenarioUebergreifendePlots,'linePlot');
arguments.plotStruct    = plotStruct;
arguments.indexPlotType = j;
                plotStruct = plotNow(arguments);
              end
              tempOutput = szenarioOutput{idxPlan};
              for k = indexFinanzLineplots
                switch k
                  case 1 % Lineplot 2: Sollrendite Projektion
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzline1,'additionalAxesSettings',{'XLim',xLimProjektionKurz;'YLim',yLimSollrendite * 100},'xAchse',xAchseKurz,...
                      'data',tempOutput.SrDgKon * 100,'domain',xAchseKurz,'lineSettings',{standardLineSettings},'lineColorMap',lineColorMapStandard(m,:),'legende','Sollrendite');
                  case 2 % Lineplot 4: Verteilung AGH Aktive
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzline2,'additionalAxesSettings',{'XLim', xLimAghAktive},'xAchse',xTicksAghAktive(1:end-1),...
                      'data',tempOutput.aghAktiveTotal5JahreAb15Bis70(1:end-1,1)','data',tempOutput.aghAktiveTotal5JahreAb15Bis70(1:end-1,8)','data',tempOutput.aghAktiveTotal5JahreAb15Bis70(1:end-1,15)',...
                      'domain',xTicksAghAktive(1:end-1),'lineSettings',{lineSettingsDick,lineSettingsMittel,lineSettingsDuenn},...
                      'lineColorMap',lineColorMapBlue,'legende','AGH Aktive Jahr 1','legende','AGH Aktive Jahr 8','legende','AGH Aktive Jahr 15');
                  case 3 % Lineplot 6: Verteilung DK Rentner
                    [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings.finanzline3,'additionalAxesSettings',{'XLim', xLimBestand},'xAchse',xTicksBestand(1:end-1),...
                      'data',tempOutput.dkRentnerTotal5JahreAb25(1:end-1,1)','data',tempOutput.dkRentnerTotal5JahreAb25(1:end-1,8)','data',tempOutput.dkRentnerTotal5JahreAb25(1:end-1,15)',...
                      'domain',xTicksBestand(1:end-1),'lineSettings',{lineSettingsDick,lineSettingsMittel,lineSettingsDuenn},...
                      'lineColorMap',lineColorMapGreen,'legende','DK Rentner Jahr 1','legende','DK Rentner Jahr 8','legende','DK Rentner Jahr 15');
                  otherwise
                end
                [plotStruct,plotName] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,m,szenarioUebergreifendePlots,'linePlot');
arguments.plotStruct    = plotStruct;
arguments.indexPlotType = j;
                plotStruct = plotNow(arguments);
              end
            case 3 % Flächenplots
              %% Flächenplots
              tempOutput = szenarioOutput{idxPlan};
              for k = indexRisikoFlaechen
                switch k
                  case 1 % Flächenplot 1
                    plotStruct = packFlaechenPlots(plotStruct,arguments,'plotStructPlotName',['Risiko_Flächen', szenario{m}],'plotArt','risikoFlächenPlot','tag','risikoFlächen','plotType','flaechenPlot',...
                      'xAchse',erfassungsjahr:erfassungsjahr + projektionsSpanne,'plotName','Risikoflächen-Plot','domain0',(erfassungsjahr:erfassungsjahr + projektionsSpanne)','lineColormap',lineColorMapRisikoPlot,...
                      'areaColorMap',areaColorMap,'xTicks',erfassungsjahr:10:erfassungsjahr + projektionsSpanne,'lineSettings',standardLineSettings,'standardFigureSettings',standardFigureSettings,...
                      'indexPlotType',j,'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim',[erfassungsjahr,erfassungsjahr + 12];'YLim',yLimFlaechenPlot;'Color',[1 1 1]},...
                      'iconDisplayStyle',{'off','off','off','off'},'legendEntries',{'','','',''},...
                      'data',tempOutput.deckungsgrad100Prozent','data',tempOutput.kritischerDeckungsgrad(:,1:end - 5)','data',tempOutput.Dg',...
                      'data',tempOutput.DgQuantil_alle_ZF{1,1}(95,:)','data',tempOutput.DgQuantil_alle_ZF{1,1}(5,:)','data',tempOutput.DgQuantil_alle_ZF{1,5}(95,5:end)',...
                      'data',tempOutput.DgQuantil_alle_ZF{1,5}(5,5:end)','data',tempOutput.DgQuantil_alle_ZF{1,9}(95,9:end)','data',tempOutput.DgQuantil_alle_ZF{1,9}(5,9:end)');
                  case 2 % Flächenplot 2 (Dg-Pfade eingezeichnet)
                    if anzahlPfade > 1
                      xAchse = erfassungsjahr:erfassungsjahr + projektionsSpanne;
                      plotStruct = packFlaechenPlots(plotStruct,arguments,'plotStructPlotName',['Risiko_Flächen_mit_DG_Pfaden', szenario{m}],'plotArt','risikoFlächenPlot','tag','risikoFlächen',...
                        'plotType','flaechenPlotMitPfad','xAchse',xAchse,'plotName','Risikoflächen-Plot','domain0',xAchse','domainCut5',xAchse(1:end - 5)','lineColormap',lineColorMapRisikoPlot,...
                        'areaColorMap',areaColorMap,'xTicks',erfassungsjahr:10:erfassungsjahr + projektionsSpanne,'lineSettings',standardLineSettings,'standardFigureSettings',standardFigureSettings,...
                        'indexPlotType',j,'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim',[erfassungsjahr,erfassungsjahr + 12];'YLim',yLimFlaechenPlot;'Color',[1 1 1]},...
                        'iconDisplayStyle',{'off','off','off','off'},'legendEntries',{'','','',''},...
                        'data',tempOutput.deckungsgrad100Prozent','data',tempOutput.kritischerDeckungsgrad','data',tempOutput.Dg',...
                        'data',tempOutput.DgQuantil_alle_ZF{1,1}(95,:)','data',tempOutput.DgQuantil_alle_ZF{1,1}(5,:)','data',tempOutput.DgQuantil_alle_ZF{1,5}(95,5:end)',...
                        'data',tempOutput.DgQuantil_alle_ZF{1,5}(5,5:end)','data',tempOutput.DgQuantil_alle_ZF{1,9}(95,9:end)','data',tempOutput.DgQuantil_alle_ZF{1,9}(5,9:end)',...
                        'dgPfade',tempOutput.Dg_100Pfade,'lineSettingsDgPfade',lineSettingsDgPfade);
                    end
                  case 3 % Flächenplot 3
                    plotStruct = packFlaechenPlots(plotStruct,arguments,'type','sanierungskapazitaet','plotStructPlotName',['Sanierungskapazität', szenario{m}],'plotArt','risikoFlächenPlot','tag','','plotType','flaechenPlot',...
                      'xAchse',erfassungsjahr:erfassungsjahr + projektionsSpanne,'plotName','Risikoflächen-Plot','domain0',(erfassungsjahr:erfassungsjahr + projektionsSpanne)','lineColormap',lineColorMapRisikoPlot,...
                      'areaColorMap',areaColorMap2,'xTicks',erfassungsjahr:10:erfassungsjahr + projektionsSpanne,'lineSettings',standardLineSettings,'standardFigureSettings',standardFigureSettings,...
                      'indexPlotType',j,'standardAxesSettings',standardAxesSettings,'additionalAxesSettings',{'XLim',[erfassungsjahr,erfassungsjahr + 12];'YLim',yLimFlaechenPlot;'Color',[1 1 1]},...
                      'iconDisplayStyle',{'off','off','on','off'},'legendEntries',{'','','Sanierungskapazität',''},...
                      'data',tempOutput.deckungsgrad100Prozent','data',tempOutput.kritischerDeckungsgrad(:,1:end - 5)');
                  otherwise
                end
              end
          end % Ende switch
        end % Ende for (plottypes)
      end % Ende if indexOutput
    end % Ende for (Pläne)
  end % Ende for (Outputs)
  %% Szenario übergreifende Plots
  if sum(checkboxSzenarienVergleichState) > 0
    szenarioUebergreifendePlots = true;
    
    arguments.indexPlotType               = false;
    arguments.szenarioUebergreifendePlots = szenarioUebergreifendePlots;
    arguments.output                      = output;
    arguments.idxPlan                     = [];
    arguments.idxSzen                     = [];
    
    if auswahl.plotart.mehrfachplots
      arguments.mehrfachplot = true;
      % Leistung im Schlussalter
      if auswahl.leistungImSchlussalter
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'boxPlotData',fliplr(output{ind}{end}.leistung65_Perzentilen),'legende',[output{ind}{end}.projectName]);
          end
        end
        sizeTempData = size(plotStruct.vectors{1,1}.boxPlotData,2);
        plotStruct = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot1,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard,...
          'xAchse',fliplr(output{counter}{end}.s_m:output{counter}{end}.s_m + sizeTempData),'additionalAxesSettings',{'XLim', [0,sizeTempData + 1];'XGrid','on';'YGrid','on'});
      end
      %% Sollrendite
      if auswahl.sollrendite
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',output{ind}{end}.SrDgKon,'legende',[output{ind}{end}.projectName],'lineSettings',standardLineSettings);
          end
        end
        plotStruct = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot2,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard,...
          'counter',counter,'domain',xAchseKurz,'xAchse',xAchseKurz,'additionalAxesSettings',{'XLim', xLimProjektionKurz;'YLim', yLimSollrendite * 100;'color',[1 1 1] * .95});
      end
      
      %% Risiko
      if auswahl.risiko
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',setRisiko(output{ind}{end}.risiko),'legende',[output{ind}{end}.projectName],'lineSettings',standardLineSettings);
          end
        end
        plotStruct = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot3,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard,...
          'counter',counter,'domain',xAchseRisikoLeistung,'xAchse',xAchseRisikoLeistung,'additionalAxesSettings',{'XLim', xLimRisikoLeistung;'YLim', [0, .4] * 100;'color',[1 1 1] * .95});
      end
      %% Leistung
      if auswahl.leistung
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',output{ind}{end}.ErsatzquoteAkt2AltT_pK,'legende',[output{ind}{end}.projectName],'lineSettings',standardLineSettings);
          end
        end
        plotStruct = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot4,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard,...
          'counter',counter,'domain',xAchseRisikoLeistung,'xAchse',xAchseRisikoLeistung,'additionalAxesSettings',{'XLim', xLimRisikoLeistung;'YLim', yLimLeistung * 100;'color',[1 1 1] * .95});
      end
      %% Umverteilung CHF
      if auswahl.umverteilung
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',(output{ind}{end}.ZinsbedarfAkt(1) - output{ind}{end}.ZinsbedarfRentner(1)),'legende',[output{ind}{end}.projectName],...
              'domain',(output{ind}{end}.Dg(2) - output{ind}{end}.Dg(1)),'lineSettings',standardLineSettings,'dataSkalierung',1);
          end
        end
        [xAxis,yAxis] = getAxes([plotStruct.vectors{:}]);

        [plotStruct,umverteilungFig(1)] = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot5,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,...
          'lineColorMap',lineColorMapStandard,'xAchse',xAchseRisikoLeistung,'xAxis',xAxis,'yAxis',yAxis,'additionalAxesSettings',{'xlim',xAxis;'ylim',yAxis;'xgrid','on';'ygrid','on'});
      end
      %% Umverteilung prozentual
      if auswahl.umverteilung
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',(output{ind}{end}.ZinsbedarfAkt(1) - output{ind}{end}.ZinsbedarfRentner(1)) / output{ind}{end}.Vermoegen(1),...
              'legende',[output{ind}{end}.projectName],'domain',(output{ind}{end}.Dg(2) - output{ind}{end}.Dg(1)),'lineSettings',standardLineSettings);
          end
        end
        [xAxis,yAxis] = getAxes([plotStruct.vectors{:}]);

        [plotStruct,umverteilungFig(2)] = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot6,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,...
          'lineColorMap',lineColorMapStandard,'xAchse',xAchseRisikoLeistung,'xAxis',xAxis,'yAxis',yAxis,'additionalAxesSettings',{'xlim',xAxis;'ylim',yAxis;'xgrid','on';'ygrid','on'});
      end
      %% Umverteilung CHF - Rentnerteil
      if auswahl.umverteilung
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',(-output{ind}{end}.ZinsbedarfRentner(1)),'legende',[output{ind}{end}.projectName],...
              'domain',(output{ind}{end}.Dg(2) - output{ind}{end}.Dg(1)),'lineSettings',standardLineSettings,'dataSkalierung',1);
          end
        end
        [xAxis,yAxis] = getAxes([plotStruct.vectors{:}]);

        [plotStruct,umverteilungFig(3)] = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot7,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,...
          'lineColorMap',lineColorMapStandard,'xAchse',xAchseRisikoLeistung,'xAxis',xAxis,'yAxis',yAxis,'additionalAxesSettings',{'xlim',xAxis;'ylim',yAxis;'xgrid','on';'ygrid','on'});
      end
      %% Umverteilung CHF - Aktiventeil
      if auswahl.umverteilung
        counter = 0;
        for ind = 1:length(checkboxSzenarienVergleichState)
          if checkboxSzenarienVergleichState(ind)
            [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,'data',(output{ind}{end}.ZinsbedarfAkt(1)),'legende',[output{ind}{end}.projectName],...
              'domain',(output{ind}{end}.Dg(2) - output{ind}{end}.Dg(1)),'lineSettings',standardLineSettings,'dataSkalierung',1);
          end
        end
        [xAxis,yAxis] = getAxes([plotStruct.vectors{:}]);

        [plotStruct,umverteilungFig(4)] = packMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplot8,'standardAxesSettings',standardAxesSettings,'standardFigureSettings',standardFigureSettings,...
          'lineColorMap',lineColorMapStandard,'xAchse',xAchseRisikoLeistung,'xAxis',xAxis,'yAxis',yAxis,'additionalAxesSettings',{'xlim',xAxis;'ylim',yAxis;'xgrid','on';'ygrid','on'});
      end
      
      %% Umverteilung Figures in einem Figure gruppieren
      if auswahl.umverteilung
        groupFigures(umverteilungFig)
      end
    end
    %% Risiko-Leistungs-Diagramm
    
    shortLength           = auswahl.risikoLeistungsDiagrammKurz.value;
    arguments.shortLength = shortLength;
    for indexRLDiagramm = 1:2
      % 1. Durchlauf: nur, falls Risiko-Leistungs-Diagramm normal ausgewählt
      % 2. Durchlauf: nur, falls Risiko-Leistungs-Diagramm kurz ausgewählt
      % wurde.
      arguments.indexRLDiagramm = indexRLDiagramm;
      if (indexRLDiagramm == 1 && auswahl.risikoLeistungsDiagrammNormal) ||...
          (indexRLDiagramm == 2 && auswahl.risikoLeistungsDiagrammKurz.checkboxValue)
        %% Ersatzquote
        if auswahl.ersatzquote
          if auswahl.orientierung.leistungRisiko
            % Mehrfach-Plots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',output{ind}{end}.ErsatzquoteAkt2AltT_pK,'data',setRisiko(output{ind}{end}.risiko),...
                    'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotLR1,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotLR1,'plotsProPlan',plotsProPlan,'backgroundColorMap',backgroundColorMap,...
                      'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',output{ind}{idxPlan}.ErsatzquoteAkt2AltT_pK,...
                      'data',setRisiko(output{ind}{idxPlan}.risiko),'lineColorMap',lineColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
          if auswahl.orientierung.risikoLeistung
            % Mehrfach-Plots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',setRisiko(output{ind}{end}.risiko),'data',output{ind}{end}.ErsatzquoteAkt2AltT_pK,...
                    'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotRL1,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotRL1,'plotsProPlan',plotsProPlan,...
                      'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',setRisiko(output{ind}{idxPlan}.risiko),...
                      'data',output{ind}{idxPlan}.ErsatzquoteAkt2AltT_pK,'lineColorMap',lineColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
        end
        
        %% Ersatzquote mit Pfeil
        if auswahl.ersatzquoteMitPfeil
          if auswahl.orientierung.leistungRisiko
            % Mehrfachplots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',output{ind}{end}.ErsatzquoteAkt2AltT_pK,'data',setRisiko(output{ind}{end}.risiko),...
                    'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotLR2,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard,'arrowColorMap',arrowColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotLR2,'plotsProPlan',plotsProPlan,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                      'figureSettings',standardFigureSettings,'domain',output{ind}{idxPlan}.ErsatzquoteAkt2AltT_pK,'data',setRisiko(output{ind}{idxPlan}.risiko),'lineColorMap',lineColorMapStandard(ind,:),...
                      'arrowColorMap',arrowColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
          if auswahl.orientierung.risikoLeistung
            if auswahl.plotart.mehrfachplots
            % Mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',setRisiko(output{ind}{end}.risiko),'data',output{ind}{end}.ErsatzquoteAkt2AltT_pK,...
                    'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotRL2,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard,'arrowColorMap',arrowColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotRL2,'plotsProPlan',plotsProPlan,...
                      'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',setRisiko(output{ind}{idxPlan}.risiko),...
                      'data',output{ind}{idxPlan}.ErsatzquoteAkt2AltT_pK,'lineColorMap',lineColorMapStandard(ind,:),'arrowColorMap',arrowColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
        end
        %% Zinseszins
        if auswahl.zinseszins
          if auswahl.orientierung.leistungRisiko
            % Mehrfachplots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',output{ind}{end}.zinseszins(1,1:length(setRisiko(output{ind}{end}.risiko))),...
                    'data',setRisiko(output{ind}{end}.risiko),'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotLR3,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotLR3,'plotsProPlan',plotsProPlan,'backgroundColorMap',backgroundColorMap,...
                      'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',output{ind}{idxPlan}.zinseszins(1,1:length(setRisiko(output{ind}{idxPlan}.risiko))),...
                      'data',setRisiko(output{ind}{idxPlan}.risiko),'lineColorMap',lineColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
          if auswahl.orientierung.risikoLeistung
            % Mehrfachplots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',setRisiko(output{ind}{end}.risiko),...
                    'data',output{ind}{end}.zinseszins(1,1:length(setRisiko(output{ind}{end}.risiko))),'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotRL3,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotRL3,'plotsProPlan',plotsProPlan,...
                      'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',setRisiko(output{ind}{idxPlan}.risiko),...
                      'data',output{ind}{idxPlan}.zinseszins(1,1:length(setRisiko(output{ind}{idxPlan}.risiko))),'lineColorMap',lineColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
        end
        
        %% normierte Ersatzquote
        if auswahl.normierteErsatzquote
          if auswahl.orientierung.leistungRisiko
            % Mehrfachplots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',superOutput.normedErsatzquoteAkt2AltT_pK{ind}{end},...
                    'data',setRisiko(output{ind}{end}.risiko),'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotLR4,'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,...
                'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotLR4,'plotsProPlan',plotsProPlan,...
                      'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',superOutput.normedErsatzquoteAkt2AltT_pK{ind}{idxPlan},...
                      'data',setRisiko(output{ind}{idxPlan}.risiko),'lineColorMap',lineColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
          if auswahl.orientierung.risikoLeistung
            % Mehrfachplots
            if auswahl.plotart.mehrfachplots
              skalierungsFaktor = 100;
              counter = 0;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,'domain',setRisiko(output{ind}{end}.risiko),...
                    'data',superOutput.normedErsatzquoteAkt2AltT_pK{ind}{end},'legende',[output{ind}{end}.projectName]);
                end
              end
              plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings.mehrfachplotRL4,'backgroundColorMap',backgroundColorMap,'axesSettings',...
                standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'lineColorMap',lineColorMapStandard);
            end
            % Einzelplots
            if auswahl.plotart.einzelplots
              arguments.mehrfachplot = false;
              for ind = 1:length(checkboxSzenarienVergleichState)
                if checkboxSzenarienVergleichState(ind)
                  startIdx = setStartIndex(length(output{ind}),plotsProPlan);
                  for idxPlan = startIdx:length(output{ind})
                    plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings.einzelplotRL4,'plotsProPlan',plotsProPlan,...
                      'backgroundColorMap',backgroundColorMap,'axesSettings',standardAxesSettingsRisikoLeistung,'figureSettings',standardFigureSettings,'domain',setRisiko(output{ind}{idxPlan}.risiko),...
                      'data',superOutput.normedErsatzquoteAkt2AltT_pK{ind}{idxPlan},'lineColorMap',lineColorMapStandard(ind,:),'legende',[output{ind}{idxPlan}.projectName]);
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  try
    delete(presetMsgbox)
  catch
  end
  
else
  msgboxHandle = msgbox('keine Plots ausgewählt!');
  pause(2)
  try
    delete(msgboxHandle)
  catch
  end
end
end

%% Local functions

function groupFigures(figures)
fig      = figure;
pos      = figures(1).Position;
fig.Position = pos;
tabgroup = uitabgroup(fig);

for idx = 1:length(figures)
  tab = uitab(tabgroup);
  ax  = findobj(figures(idx),'type','axes');
  ax.Parent = tab;
  tab.Title = ax.Title.String;
  delete(figures(idx))
  
  tempMenu = uicontextmenu;
  uimenu(tempMenu,'label','Löschen','callback',{@tabCallback,'delete',tab})
  uimenu(tempMenu,'label','Undock','callback',{@tabCallback,'undock',tab})
  
  tab.UIContextMenu = tempMenu;
end
end

function tabCallback(~,~,type,tab)
switch type
  case 'delete'
    oldFig = tab.Parent.Parent;
  case 'undock'
    fig = figure;
    ax = findobj(tab,'type','axes');
    oldFig = ax.Parent.Parent.Parent;
    ax.Parent = fig;
    fig.Position = oldFig.Position;
end
delete(tab)
if isempty(findobj(oldFig,'type','uitab'))
  delete(oldFig)
end
end

function [xAxis,yAxis] = getAxes(vectors)
dataVector = [vectors(:).data];
plotHight  = max(abs(dataVector)) * 1.05; % inkl. Rand
yAxis      = plotHight * [-1,1];

domainVector = [vectors(:).domain];
plotWidth    = max(abs(domainVector)) * 1.05; % inkl. Rand
xAxis        = plotWidth * [-1,1];
end

function plotStruct = packBoxplots(plotStruct,arguments,basicPlotSettings,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  
  % Einlesen Parameter
  
  plotStruct.plotName         = getField(basicPlotSettings,'plotStructPlotName','string');
  plotStruct.plotArt          = getField(basicPlotSettings,'plotArt','string');
  plotName                    = getField(basicPlotSettings,'plotName','string');
  plotType                    = getField(basicPlotSettings,'plotType','string');
  szenarioUebergreifendePlots = getField(basicPlotSettings,'szenarioUebergreifendePlots','boolean');
  plotStruct.xLabel           = getField(basicPlotSettings,'xLabel','string');
  plotStruct.yLabel           = getField(basicPlotSettings,'yLabel','string');
  plotStruct.title            = getField(basicPlotSettings,'title','string');
  plotStruct.xTickLabelType   = getField(basicPlotSettings,'xTickLabelType','string');
  plotStruct.yTickLabelType   = getField(basicPlotSettings,'yTickLabelType','string');
  plotStruct.legendPosition   = getField(basicPlotSettings,'legendPosition','string');
  plotStruct.serialType       = getField(basicPlotSettings,'serialType','string');

  skalierungsFaktor = 100;
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'plotstructplotname'
        plotStruct.plotName = varargin{index};
      case 'plotart'
        plotStruct.plotArt = varargin{index};
      case 'plottype'
        plotType = varargin{index};
      case 'plotname'
        plotName = varargin{index};
      case 'additionalaxessettings'
        additionalAxesSettings = varargin{index};
      case 'standardaxessettings'
        standardAxesSettings = varargin{index};
      case 'standardfiguresettings'
        standardFigureSettings = varargin{index};
      case 'szenariouebergreifendeplots'
        szenarioUebergreifendePlots = varargin{index};
      case 'legende'
        plotStruct.vectors{1,1}.legende = varargin{index};
      case 'legendposition'
        plotStruct.legendPosition = varargin{index};
      case 'boxplotdata'
        plotStruct.vectors{1,1}.boxPlotData = varargin{index};
      case 'color'
        plotStruct.vectors{1}.color = varargin{index};
      case 'xlabel'
        plotStruct.xLabel = varargin{index};
      case 'ylabel'
        plotStruct.yLabel = varargin{index};
      case 'xticklabeltype'
        plotStruct.xTickLabelType = varargin{index};
      case 'yticklabeltype'
        plotStruct.yTickLabelType = varargin{index};
      case 'title'
        plotStruct.title = varargin{index};
      case 'xachse'
        plotStruct.xAchse = varargin{index};
      case 'indexplottype'
        idxPlotType = varargin{index};
      case 'indexszenario'
        idxSzenario = varargin{index};
      case 'skalierungsfaktor'
        skalierungsFaktor = varargin{index};
    end
  end
  
  % Skalierung
  plotStruct.vectors{1,1}.boxPlotData = plotStruct.vectors{1,1}.boxPlotData * skalierungsFaktor;
  
  [plotStruct,~] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,idxSzenario,szenarioUebergreifendePlots,plotType);
  arguments.plotStruct    = plotStruct;
  arguments.indexPlotType = idxPlotType;
  plotStruct = plotNow(arguments);
end

end

function varargout = packMehrfachPlots(plotStruct,arguments,basicPlotSettings,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  error('Fehler in ''packMehrfachPlots''. Unvollständige Property-Value-Pairs.')
else
  
  % Einlesen Parameter
  plotStruct.plotName         = getField(basicPlotSettings,'plotStructPlotName','string');
  plotStruct.plotArt          = getField(basicPlotSettings,'plotArt','string');
  plotName                    = getField(basicPlotSettings,'plotName','string');
  plotType                    = getField(basicPlotSettings,'plotType','string');
  szenarioUebergreifendePlots = getField(basicPlotSettings,'szenarioUebergreifendePlots','boolean');
  plotStruct.xLabel           = getField(basicPlotSettings,'xLabel','string');
  plotStruct.yLabel           = getField(basicPlotSettings,'yLabel','string');
  plotStruct.title            = getField(basicPlotSettings,'title','string');
  plotStruct.xTickLabelType   = getField(basicPlotSettings,'xTickLabelType','string');
  plotStruct.yTickLabelType   = getField(basicPlotSettings,'yTickLabelType','string');
  plotStruct.legendPosition   = getField(basicPlotSettings,'legendPosition','string');
  plotStruct.serialType       = getField(basicPlotSettings,'serialType','string');
  
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'plotstructplotname'
        plotStruct.plotName = varargin{index};
      case 'plotart'
        plotStruct.plotArt  = varargin{index};
      case 'plotname'
        plotName  = varargin{index};
      case 'standardaxessettings'
        standardAxesSettings  = varargin{index};
      case 'standardfiguresettings'
        standardFigureSettings  = varargin{index};
      case 'additionalaxessettings'
        additionalAxesSettings  = varargin{index};
      case 'plottype'
        plotType  = varargin{index};
      case 'szenariouebergreifendeplots'
        szenarioUebergreifendePlots  = varargin{index};
      case 'linecolormap'
        plotStruct.lineColorMap  = varargin{index};
      case 'xlabel'
        plotStruct.xLabel  = varargin{index};
      case 'ylabel'
        plotStruct.yLabel  = varargin{index};
      case 'title'
        plotStruct.title  = varargin{index};
      case 'xticklabeltype'
        plotStruct.xTickLabelType  = varargin{index};
      case 'yticklabeltype'
        plotStruct.yTickLabelType  = varargin{index};
      case 'legendposition'
        plotStruct.legendPosition  = varargin{index};
      case 'serialtype'
        plotStruct.serialType  = varargin{index};
      case 'xachse'
        plotStruct.xAchse  = varargin{index};
      case 'xaxis'
        plotStruct.xAxis  = varargin{index};
      case 'yaxis'
        plotStruct.yAxis  = varargin{index};
      case 'counter'
        counter = varargin{index};
      case 'domain'
        domain = varargin{index};
    end
  end
  
  if exist('domain','var')
    for l = 1:counter
      plotStruct.vectors{l}.domain = domain;
    end
  end
  
  [plotStruct,~] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,[],szenarioUebergreifendePlots,plotType);
  arguments.plotStruct = plotStruct;
  [plotStruct,newFig] = plotNow(arguments);
  
  varargout{1} = plotStruct;
  if nargout == 2
    varargout{2} = newFig;
  end
end
end

function [plotStruct,counter] = packMehrfachPlotsData(plotStruct,ind,counter,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  domainSkalierung = 100;
  dataSkalierung   = 100;
  boxPlotDataExists = false;
  dataExists        = false;
  domainExists      = false;
  
  numPairs = numVarIn / 2;
  counter  = counter + 1;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'boxplotdata'
        boxPlotDataExists = true;
        plotStruct.vectors{1,counter}.boxPlotData = varargin{index};
      case 'data'
        dataExists = true;
        plotStruct.vectors{1,counter}.data = varargin{index};
      case 'domain'
        domainExists = true;
        plotStruct.vectors{1,counter}.domain = varargin{index};
      case 'legende'
        plotStruct.vectors{counter}.legende = varargin{index};
      case 'linesettings'
        plotStruct.lineSettings{counter} = varargin{index};
      case 'domainskalierung'
        domainSkalierung = varargin{index};
      case 'dataskalierung'
        dataSkalierung = varargin{index};
    end
  end
  
  if boxPlotDataExists
    plotStruct.vectors{1,counter}.boxPlotData = plotStruct.vectors{1,counter}.boxPlotData * dataSkalierung;
  end
  if dataExists
    plotStruct.vectors{1,counter}.data        = plotStruct.vectors{1,counter}.data        * dataSkalierung;
  end
  if domainExists
    plotStruct.vectors{1,counter}.domain      = plotStruct.vectors{1,counter}.domain      * domainSkalierung;
  end
  
  plotStruct.vectors{counter}.index = ind;

end
end

function plotStruct = packFlaechenPlots(plotStruct,arguments,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  % Dimension von vectors präallozieren
  dimensions = getVectorDim(varargin);
  
  % Einlesen Parameter
  vectors = cell(dimensions)';

  numPairs = numVarIn / 2;
  type     = 'flaechenplot';
  skalierungsFaktor = 100;
  counter = 0;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'type'
        type = varargin{index};
      case 'plotstructplotname'
        plotStruct.plotName = varargin{index};
      case 'plotart'
        plotStruct.plotArt = varargin{index};
      case 'tag'
        plotStruct.tag = varargin{index};
      case 'plottype'
        plotStruct.plotType = varargin{index};
      case 'xachse'
        plotStruct.xAchse = varargin{index};
      case 'plotname'
        plotName = varargin{index};
      case 'data'
        vectors{counter + 1}.data = varargin{index} * skalierungsFaktor;
        counter = counter + 1;
      case 'domain0'
        domain0 = varargin{index};
      case 'domaincut5'
        domainCut5 = varargin{index};
      case 'linecolormap'
        plotStruct.lineColorMap = varargin{index};
      case 'areacolormap'
        areaColorMap = varargin{index};
      case 'xticks'
        xTicks = varargin{index};
      case 'linesettings'
        lineSettings = varargin{index};
      case 'standardfiguresettings'
        standardFigureSettings = varargin{index};
      case 'indexplottype'
        indexPlotType = varargin{index};
      case 'standardaxessettings'
        standardAxesSettings = varargin{index};
      case 'additionalaxessettings'
        additionalAxesSettings = varargin{index};
      case 'dgpfade'
        dgPfade = varargin{index};
      case 'linesettingsdgpfade'
        lineSettingsDgPfade = varargin{index};
      case 'icondisplaystyle'
        iconDisplayStyle = varargin{index};
      case 'legendentries'
        legendEntries = varargin{index};
    end
  end
  plotStruct.flaechenPlotAktiviert = true;
  axesSettings = [standardAxesSettings;additionalAxesSettings];
  
  plotStruct.vectors = vectors;

  % Curve-Fitting:
  % true: lineare Regression / false: Spline-Interpolation
  if strcmp(type,'flaechenplot')
    plotStruct.vectors{1}.regdata = false;
    plotStruct.vectors{2}.regdata = false;
    plotStruct.vectors{3}.regdata = false;
    plotStruct.vectors{4}.regdata = true;
    plotStruct.vectors{5}.regdata = true;
    plotStruct.vectors{6}.regdata = true;
    plotStruct.vectors{7}.regdata = true;
    plotStruct.vectors{8}.regdata = true;
    plotStruct.vectors{9}.regdata = true;
  else
    plotStruct.vectors{1}.regdata = false;
    plotStruct.vectors{2}.regdata = false;
  end
  
  % Definitionisbereiche
  domain1Bis4   = domain0(1:5);
  domain5Bis9   = domain0(5:9);
  domain10Bis13 = domain0(9:13);
  
  if strcmp(type,'flaechenplot')
    plotStruct.vectors{1}.domain = domain0;
    if exist('domainCut5','var')
      plotStruct.vectors{2}.domain = domainCut5;
    else
      plotStruct.vectors{2}.domain = domain0;
    end
    plotStruct.vectors{3}.domain = domain0;
    plotStruct.vectors{4}.domain = domain1Bis4;
    plotStruct.vectors{5}.domain = domain1Bis4;
    plotStruct.vectors{6}.domain = domain5Bis9;
    plotStruct.vectors{7}.domain = domain5Bis9;
    plotStruct.vectors{8}.domain = domain10Bis13;
    plotStruct.vectors{9}.domain = domain10Bis13;
  else
    plotStruct.vectors{1}.domain = domain0;
    plotStruct.vectors{2}.domain = domain0;
  end
  
  % Legenden
  if strcmp(type,'flaechenplot')
    plotStruct.vectors{1}.legende = '';
    plotStruct.vectors{2}.legende = 'kritischer Deckungsgrad';
    plotStruct.vectors{3}.legende = 'erwarteter Deckungsgrad  ';
    plotStruct.vectors{4}.legende = '95%-Quantil';
    plotStruct.vectors{5}.legende = '5%-Quantil';
    plotStruct.vectors{6}.legende = '';
    plotStruct.vectors{7}.legende = '';
    plotStruct.vectors{8}.legende = '';
    plotStruct.vectors{9}.legende = '';
    plotStruct.legendPosition     = 'northWest';
  else
    plotStruct.vectors{1}.legende = '';
    plotStruct.vectors{2}.legende = 'kritischer Deckungsgrad';
  end
  
  % Angaben zum Flächenplot
  
  if strcmp(type,'flaechenplot')
    % Flächenplot 1
    plotStruct.flaechenPlot{1}.chosenVectors = [4,2,1,5];
    plotStruct.flaechenPlot{1}.obererRand    = plotStruct.vectors{4}.data';
    plotStruct.flaechenPlot{1}.trennlinie1   = plotStruct.vectors{2}.data';
    plotStruct.flaechenPlot{1}.trennlinie2   = plotStruct.vectors{1}.data';
    plotStruct.flaechenPlot{1}.untererRand   = plotStruct.vectors{5}.data';
    plotStruct.flaechenPlotZeitspanne        = 4;
    
    % Flächenplot 2
    plotStruct.flaechenPlot{2}.chosenVectors = [6,2,1,7];
    plotStruct.flaechenPlot{2}.obererRand    = plotStruct.vectors{6}.data';
    plotStruct.flaechenPlot{2}.trennlinie1   = plotStruct.vectors{2}.data';
    plotStruct.flaechenPlot{2}.trennlinie2   = plotStruct.vectors{1}.data';
    plotStruct.flaechenPlot{2}.untererRand   = plotStruct.vectors{7}.data';
    plotStruct.flaechenPlot{2}.zeitspanne    = 4;
    
    % Flächenplot 3
    plotStruct.flaechenPlot{3}.chosenVectors = [8,2,1,9];
    plotStruct.flaechenPlot{3}.obererRand    = plotStruct.vectors{8}.data';
    plotStruct.flaechenPlot{3}.trennlinie1   = plotStruct.vectors{2}.data';
    plotStruct.flaechenPlot{3}.trennlinie2   = plotStruct.vectors{1}.data';
    plotStruct.flaechenPlot{3}.untererRand   = plotStruct.vectors{9}.data';
    plotStruct.flaechenPlot{3}.zeitspanne    = 4;
  else
    % Flächenplot 1
    plotStruct.flaechenPlot{1}.chosenVectors = [1,1,2,2];
    plotStruct.flaechenPlot{1}.obererRand    = plotStruct.vectors{1}.data';
    plotStruct.flaechenPlot{1}.trennlinie1   = plotStruct.vectors{1}.data';
    plotStruct.flaechenPlot{1}.trennlinie2   = plotStruct.vectors{2}.data';
    plotStruct.flaechenPlot{1}.untererRand   = plotStruct.vectors{2}.data';
    plotStruct.flaechenPlotZeitspanne        = 12;
  end
  
  
  % Flächen-Colormaps
  numFlaechenPlots = length(plotStruct.flaechenPlot);
  for ind = 1:numFlaechenPlots
    plotStruct.flaechenPlot{ind}.areaColorMap     = areaColorMap;
    plotStruct.flaechenPlot{ind}.iconDisplayStyle = iconDisplayStyle;
    plotStruct.flaechenPlot{ind}.legendEntries    = legendEntries;
  end
  
  if exist('dgPfade','var')
    % Angaben zu den DG-Pfaden
    counter      = 0;
    indexOfYears = 1:5;
    for ind1 = [1,5,9]
      dgMatrix = dgPfade{ind1}(1,:,:) * skalierungsFaktor;
      dgMatrix = reshape(dgMatrix,size(dgMatrix,2),size(dgMatrix,3));
      dgMatrix = dgMatrix(ind1:end,:);
      sizeDgMatrix      = size(dgMatrix,2);
      pathsPerPercentil = sizeDgMatrix / 100;
      
      index = 0;
      for ind2 = 1:sizeDgMatrix
        if ind2 >= index + pathsPerPercentil
          index = ind2;
          counter = counter + 1;
          plotStruct.dgPfade{counter}.data = dgMatrix(indexOfYears,ind2)';
          plotStruct.dgPfade{counter}.domain = domain1Bis4 + ind1 - 1;
          plotStruct.dgPfade{counter}.legende = '';
          plotStruct.lineColorMapDgPfade(counter,:) = [1 1 1] * 0.5;
          plotStruct.lineSettingsDgPfade{counter} = lineSettingsDgPfade;
        end
      end
    end
  end
  
  % Sonstige Beschriftungen
  plotStruct.xLabel = 'Jahr';
  plotStruct.yLabel = 'Deckungsgrad';
  plotStruct.title  = 'Deckungsgrad- und Risikoprojektion ';
  
  % x- / y-Tick-Labels
  plotStruct.yTickLabelType = 'prozent';
  plotStruct.xTickLabelType = 'normal';
  
  xTickLabels = cell(length(xTicks));
  for l = 1:length(xTicks)
    xTickLabels{l} = xTicks(l);
  end
  setXTickLabels = {'XTickLabel', xTickLabels};
  
  % Settings
  for ind = 1:length(plotStruct.vectors)
    plotStruct.lineSettings{ind} = lineSettings;
  end
  plotStruct.settings.figure = [standardFigureSettings;{'Name', plotName}];
  plotStruct.settings.axes   = [axesSettings;setXTickLabels];
  arguments.plotStruct       = plotStruct;
  
  arguments.indexPlotType    = indexPlotType;
  plotStruct                 = plotNow(arguments);
end
end

function field = getField(struct,fieldName,type)
field = [];
if isfield(struct,fieldName)
  value = struct.(fieldName);
  switch type
    case 'string'
      field = value;
    case 'numeric'
      field = str2double(value);
    case 'boolean'
      if strcmp(value,'true')
        field = true;
      elseif strcmp(value,'false')
        field = false;
      end
  end
end
end

function dimensions = getVectorDim(inputVector)
A = strcmp(inputVector,'-pos');
if sum(A) > 0
  A = circshift(A',1)';
  B = inputVector(A);
  B = [B{:}];
  len = length(B) / 2;
  C = zeros(2,len);
  C(1,:) = B((1:len) * 2);
  C(2,:) = B((1:len) * 2 - 1);
  dimensions = max(C,[],2)';
else
  A = strcmp(inputVector,'data');
  dimensions = [sum(A),1];
end
end

function [plotStruct,additionalAxesSettings,plotName] = packPlots(plotStruct,basicPlotSettings,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  
  % Einlesen Parameter
  plotStruct.plotName        = getField(basicPlotSettings,'plotStructPlotName','string');
  plotStruct.plotArt         = getField(basicPlotSettings,'plotArt','string');
  plotName                   = getField(basicPlotSettings,'plotName','string');
  plotStruct.legendPosition  = getField(basicPlotSettings,'legendPosition','string');
  plotStruct.xLabel          = getField(basicPlotSettings,'xLabel','string');
  plotStruct.yLabel          = getField(basicPlotSettings,'yLabel','string');
  plotStruct.title           = getField(basicPlotSettings,'title','string');
  plotStruct.xTickLabelType  = getField(basicPlotSettings,'xTickLabelType','string');
  plotStruct.yTickLabelType  = getField(basicPlotSettings,'yTickLabelType','string');
  plotStruct.dataWidthFactor = getField(basicPlotSettings,'dataWidthFactor','numeric');
  
  % Dimension von vectors präallozieren
  dimensions = getVectorDim(varargin);
  
  % Einlesen Parameter
  vectors = cell(dimensions)';
  dataCounter = 0;
  legendCounter = 0;
  barColorMapCounter = 0;
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'plotstructplotname'
        plotStruct.plotName = varargin{index};
      case 'plotart'
        plotStruct.plotArt = varargin{index};
      case 'additionalaxessettings'
        additionalAxesSettings = varargin{index};
      case 'plotname'
        plotName = varargin{index};
      case 'xlabel'
        plotStruct.xLabel = varargin{index};
      case 'ylabel'
        plotStruct.yLabel = varargin{index};
      case 'title'
        plotStruct.title = varargin{index};
      case 'xachse'
        plotStruct.xAchse = varargin{index};
      case 'datawidthfactor'
        plotStruct.dataWidthFactor = varargin{index};
      case 'xticklabeltype'
        plotStruct.xTickLabelType = varargin{index};
      case 'yticklabeltype'
        plotStruct.yTickLabelType = varargin{index};
      case 'legendposition'
        plotStruct.legendPosition = varargin{index};
      case 'linecolormap'
        plotStruct.lineColorMap = varargin{index};
      case 'linesettings'
        plotStruct.lineSettings = varargin{index};
      case 'domain'
        domain = varargin{index};
      case 'data'
        if index < length(varargin)
          if strcmp(varargin{index + 1},'-pos')
            position = varargin{index + 2};
            vectors{position(1),position(2)}.data = varargin{index};
          else
            vectors{dataCounter + 1}.data = varargin{index};
            dataCounter = dataCounter + 1;
          end
        else
          vectors{dataCounter + 1}.data = varargin{index};
          dataCounter = dataCounter + 1;
        end
      case 'barcolormap'
        if index < length(varargin)
          if strcmp(varargin{index + 1},'-pos')
            position = varargin{index + 2};
            vectors{position(1),position(2)}.barColorMap = varargin{index};
          else
            vectors{barColorMapCounter + 1}.barColorMap = varargin{index};
            barColorMapCounter = barColorMapCounter + 1;
          end
        else
          vectors{barColorMapCounter + 1}.barColorMap = varargin{index};
          barColorMapCounter = barColorMapCounter + 1;
        end
      case 'legende'
        if index < length(varargin)
          if strcmp(varargin{index + 1},'-pos')
            position = varargin{index + 2};
            vectors{position(1),position(2)}.legende = varargin{index};
          else
            vectors{legendCounter + 1}.legende = varargin{index};
            legendCounter = legendCounter + 1;
          end
        else
          vectors{legendCounter + 1}.legende = varargin{index};
          legendCounter = legendCounter + 1;
        end
    end
  end
  
  plotStruct.vectors = vectors;
  
  if exist('domain','var')
    for idx = 1:length(vectors)
      plotStruct.vectors{idx}.domain = domain;
    end
  end
end
end

function [plotStruct,counter] = packRLMehrfachPlotsData(plotStruct,ind,counter,skalierungsFaktor,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  
  % Einlesen Parameter
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'domain'
        domain = varargin{index};
      case 'data'
        data = varargin{index};
      case 'legende'
        legende = varargin{index};
    end
  end
  
  % Datenreihen
  counter = counter + 1;
  plotStruct.vectors{counter}.domain  = domain * skalierungsFaktor;
  plotStruct.vectors{counter}.data    = data   * skalierungsFaktor;
  plotStruct.vectors{counter}.index   = ind;
  % Legende
  plotStruct.vectors{counter}.legende = legende;
  
  plotStruct = setMarker(plotStruct);
end
end

function plotStruct = packRLMehrfachPlots(plotStruct,arguments,basicPlotSettings,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  
  % Einlesen Parameter
  plotStruct.plotName             = getField(basicPlotSettings,'plotStructPlotName','string');
  plotStruct.tag                  = getField(basicPlotSettings,'tag','string');
  plotStruct.diagrammOrientierung = getField(basicPlotSettings,'diagrammOrientierung','string');
  plotName                        = getField(basicPlotSettings,'plotName','string');
  risikoLeistungsTyp              = getField(basicPlotSettings,'risikoLeistungsTyp','string');
  plotStruct.xLabel               = getField(basicPlotSettings,'xLabel','string');
  plotStruct.yLabel               = getField(basicPlotSettings,'yLabel','string');
  plotStruct.title                = getField(basicPlotSettings,'title','string');
  withArrow                       = getField(basicPlotSettings,'withArrow','boolean');

  % Einlesen Parameter
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'tag'
        plotStruct.tag = varargin{index};
      case 'diagrammorientierung'
        plotStruct.diagrammOrientierung = varargin{index};
      case 'plotname'
        plotName = varargin{index};
      case 'plotstructplotname'
        plotStruct.plotName = varargin{index};
      case 'risikoleistungstyp'
        risikoLeistungsTyp = varargin{index};
      case 'witharrow'
        withArrow = varargin{index};
      case 'backgroundcolormap'
        backgroundColorMap = varargin{index};
      case 'axessettings'
        axesSettings = varargin{index};
      case 'figuresettings'
        figureSettings = varargin{index};
      case 'linecolormap'
        plotStruct.lineColorMap = varargin{index};
      case 'arrowcolormap'
        plotStruct.arrowColorMap = varargin{index};
      case 'xlabel'
        plotStruct.xLabel = varargin{index};
      case 'ylabel'
        plotStruct.yLabel = varargin{index};
      case 'title'
        plotStruct.title = varargin{index};
    end
  end
      
  plotStruct = settingsRisikoLeistungsPlot(plotStruct,risikoLeistungsTyp,withArrow,backgroundColorMap,axesSettings,plotName,figureSettings);
    
  arguments.mehrfachplot = true;
  arguments.plotStruct   = plotStruct;
  
  plotStruct = plotNow(arguments);
end
end

function plotStruct = packEinzelPlots(plotStruct,arguments,output,ind,idxPlan,basicPlotSettings,varargin)

numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  
% Einlesen Parameter
  plotStruct.plotName             = getField(basicPlotSettings,'plotStructPlotName','string');
  plotStruct.tag                  = getField(basicPlotSettings,'tag','string');
  plotStruct.diagrammOrientierung = getField(basicPlotSettings,'diagrammOrientierung','string');
  plotName                        = getField(basicPlotSettings,'plotName','string');
  risikoLeistungsTyp              = getField(basicPlotSettings,'risikoLeistungsTyp','string');
  plotStruct.xLabel               = getField(basicPlotSettings,'xLabel','string');
  plotStruct.yLabel               = getField(basicPlotSettings,'yLabel','string');
  plotStruct.title                = getField(basicPlotSettings,'title','string');
  withArrow                       = getField(basicPlotSettings,'withArrow','boolean');

  % Einlesen Parameter
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'tag'
        plotStruct.tag = varargin{index};
      case 'diagrammorientierung'
        plotStruct.diagrammOrientierung = varargin{index};
      case 'plotstructplotname'
        plotStruct.plotName = varargin{index};
      case 'plotname'
        plotName = varargin{index};
      case 'risikoleistungstyp'
        risikoLeistungsTyp = varargin{index};
      case 'witharrow'
        withArrow = varargin{index};
      case 'backgroundcolormap'
        backgroundColorMap = varargin{index};
      case 'axessettings'
        axesSettings = varargin{index};
      case 'figuresettings'
        figureSettings = varargin{index};
      case 'domain'
        domain = varargin{index};
      case 'data'
        data = varargin{index};
      case 'linecolormap'
        plotStruct.lineColorMap = varargin{index};
      case 'arrowcolormap'
        plotStruct.arrowColorMap = varargin{index};
      case 'legende'
        legende = varargin{index};
      case 'xlabel'
        plotStruct.xLabel = varargin{index};
      case 'ylabel'
        plotStruct.yLabel = varargin{index};
      case 'title'
        plotStruct.title = varargin{index};
    end
  end
      
  plotStruct = settingsRisikoLeistungsPlot(plotStruct,risikoLeistungsTyp,withArrow,backgroundColorMap,axesSettings,plotName,figureSettings);
  
  % Datenreihen
  plotStruct.vectors{1}.domain = domain;
  plotStruct.vectors{1}.data   = data;
  
  % Marker (Markierung des Startpunktes im R-L-Pfad)
  plotStruct = setMarker(plotStruct);
  
  % Skalierung
  plotStruct = skalierungRisikoLeistungsPlot(plotStruct);
  
  % Legende
  plotStruct.vectors{1}.legende = legende;
  
  arguments.plotStruct = plotStruct;
  arguments.idxPlan    = idxPlan;
  arguments.idxSzen    = ind;
  arguments.numPlans   = length(output{ind});
  if idxPlan == length(output{ind})
    plotStruct = plotNow(arguments);
  else
    plotStruct = plotNow(arguments,'keepPlotStruct',true);
  end
end
end

function plotStruct = setMarker(plotStruct)
% Pro Pfad im Risiko-Leistungsdiagramm entstehen zwei Line-Plots: der
% eigentliche Pfad plus ein Hilfspfad, welcher die Markierung
% des ersten Punktes umsetzt.

if isfield(plotStruct,'lineSettings')
  plotStruct.lineSettings{end + 1} = {'LineWidth', 2.5; 'Marker', 'o'};
  plotStruct.lineSettings{end + 1} = {'LineWidth', 2.5; 'Marker', 'o'};
else
  plotStruct.lineSettings{1} = {'LineWidth', 2.5; 'Marker', 'o'};
  plotStruct.lineSettings{2} = {'LineWidth', 2.5; 'Marker', 'o'};
end
% plotStruct.lineSettings{2 * 1 - 1} = {'LineWidth', 2.5; 'Marker', 'o'};
% plotStruct.lineSettings{2 * 1}     = {'LineWidth', 2.5; 'Marker', 'o'};
end

function startIdx = setStartIndex(lengthOutput,plotsProPlan)
if plotsProPlan
  startIdx = 1;
else
  startIdx = lengthOutput;
end
end

function varargout = plotNow(arguments,varargin)
numVarIn = length(varargin);
if fix(numVarIn / 2) ~= numVarIn / 2
  [currentDbstack,~] = dbstack;
  error(['Fehler in ''',currentDbstack(1).name,'''. Unvollständige Property-Value-Pairs.'])
else
  
  keepPlotStruct = false;
  % Einlesen Parameter
  numPairs = numVarIn / 2;
  for idx = 1:numPairs
    index = 2 * idx;
    switch lower(varargin{index - 1})
      case 'keepplotstruct'
        keepPlotStruct = varargin{index};
    end
  end
  
  % Input auspacken
  plotStruct                  = arguments.plotStruct;
  indexPlotType               = arguments.indexPlotType;
  szenario                    = arguments.szenario;
  risikoLeistungAusmitteln    = arguments.risikoLeistungAusmitteln;
  indexRLDiagramm             = arguments.indexRLDiagramm;
  shortLength                 = arguments.shortLength;
  titelEinfach                = arguments.titelEinfach;
  timeStamp                   = arguments.timeStamp;
  graphikHandling             = arguments.graphikHandling;
  kundenName                  = arguments.kundenName;
  auswahl                     = arguments.auswahl;
  szenarioUebergreifendePlots = arguments.szenarioUebergreifendePlots;
  folderStructure             = arguments.folderStructure;
  output                      = arguments.output;
  fusszeileSettings           = arguments.fusszeileSettings;
  figureBackgroundColor       = arguments.figureBackgroundColor;
  s_m                         = arguments.s_m;
  erfassungsjahr              = arguments.erfassungsjahr;
  idxPlan                     = arguments.idxPlan;
  idxSzen                     = arguments.idxSzen;
  numPlans                    = arguments.numPlans;
  
  if isfield(arguments,'mehrfachplot')
    mehrfachplot = arguments.mehrfachplot;
  else
    mehrfachplot = false;
  end
  
  % Plott-Funktion
  
  % Allgemeine Settings
  plotStruct.timeStamp       = timeStamp;
  plotStruct.graphikHandling = graphikHandling;
  plotStruct.kundenName      = kundenName;
  plotStruct.leistungsprimat = auswahl.leistungsprimat;
  
  if ~mehrfachplot
    if numPlans > 1
      if idxPlan == numPlans
        planString = '_konsolidiert';
      else
        planString = ['_Plan_',num2str(idxPlan)];
      end
    else
      planString = '';
    end
  else
    planString = '';
  end
  
  if ~mehrfachplot
    plotStruct.plotName      = [plotStruct.plotName '_Szenario' num2str(idxSzen - 1) planString];
  else
    plotStruct.plotName      = ['Mehrfachplot_' plotStruct.plotName];
  end
  
  plotStruct.settings.xLabel = {'FontSize', 18; 'FontWeight', 'bold'; 'fontName', 'MISO'};
  plotStruct.settings.yLabel = {'FontSize', 18; 'FontWeight', 'bold'; 'fontName', 'MISO'};
  plotStruct.settings.title  = {'FontSize', 20; 'FontWeight', 'bold'; 'fontName', 'MISO'};
  
  booleanRisikoLeistungsPlot = strcmp(plotStruct.plotType, 'risikoLeistungsPlot');
  
  % Für Bar-, Linien- und Flächenplots
  if indexPlotType ~= 4 && ~booleanRisikoLeistungsPlot && ~mehrfachplot
    plotStruct.title = titelNummer(plotStruct,szenario{idxSzen});
  end
  
  % Für Risikoleistungsplots
  if booleanRisikoLeistungsPlot
    plotStruct.risikoLeistungAusmitteln = risikoLeistungAusmitteln;
    if length(plotStruct.vectors) == 1 && ~mehrfachplot
      if numPlans > 1
        if idxPlan == numPlans
          planString = ' (konsolidiert)';
        else
          planString = [' (Plan ',num2str(idxPlan),')'];
        end
      else
        planString = '';
      end
      plotStruct.title = [plotStruct.title, ' ', szenario{idxSzen},planString];
    end
    if indexRLDiagramm == 2
      plotStruct.vectors = cutVectors(plotStruct.vectors,shortLength);
    end
    plotStruct = setXYLabelEinfach(plotStruct,titelEinfach);
  end
  
  % Für Szenarioübergreifende Plots
  if szenarioUebergreifendePlots
    plotStruct = folderSetupSzenarioUebergreifendePlots(plotStruct,folderStructure);
  else
    plotStruct = folderSetupRestlichePlots(plotStruct,output{idxPlan}.projectName,folderStructure.folderPathSzenarioNr{idxSzen});
  end
  
  plotStruct.fusszeileSettings = setFusszeile(plotStruct.projectName,plotStruct.timeStamp,fusszeileSettings,figureBackgroundColor);
  
  % Graphik-Handling
  if graphikHandling.speichern
    if szenarioUebergreifendePlots
      plotStruct = folderSetupSzenarioUebergreifendePlots(plotStruct,folderStructure);
    else
      plotStruct = folderSetupRestlichePlots(plotStruct,output{idxPlan}.projectName,folderStructure.folderPathSzenarioNr{idxSzen});
    end
  end
  
  % Plotten
  if ~isTest
    newFig = plotter(plotStruct,s_m, erfassungsjahr);
  else
    setappdata(0,'testPlot',plotter(plotStruct,s_m, erfassungsjahr));
  end
  idxPlan              = [];
  numPlansKonsolidiert = [];
  if isfield(plotStruct,'idxPlan')
    idxPlan = plotStruct.idxPlan;
  end
  if isfield(plotStruct,'numPlansKonsolidiert')
    numPlansKonsolidiert = plotStruct.numPlansKonsolidiert;
  end
  if ~keepPlotStruct
    clear plotStruct
  end
  
  plotStruct.numPlansKonsolidiert = numPlansKonsolidiert;
  plotStruct.idxPlan              = idxPlan;
  plotStruct.tag                  = '';
  plotStruct.legendPosition       = 'northEast'; % Standard, falls abweichend, im folgenden Code anpassen...
%   plotStruct.plotName = 'TEST';
%   plotStruct.title = 'TEST';
  
  varargout{1} = plotStruct;
  if nargout == 2
    varargout{2} = newFig;
  end
end
end

function plotStruct = setXYLabelEinfach(plotStruct,titelEinfach)
if titelEinfach
  test = strcmp(plotStruct.diagrammOrientierung,'RisikoLeistung');
  if test
    plotStruct.xLabel = 'Risiko';
    plotStruct.yLabel = 'Leistung';
  else
    plotStruct.xLabel = 'Leistung';
    plotStruct.yLabel = 'Risiko';
  end
end
end

function fusszeileSettings = setFusszeile(projectName,timeStamp,fusszeileSettings,figureBackgroundColor)
% Fusszeile-Settings
fzHoehe  = 13;
fzBreite = 400;
fzBackgroundColor = figureBackgroundColor;
fusszeileSettings{1} = {'string',projectName;...
  'position',[0,fzHoehe,fzBreite,fzHoehe];...
  'tag','Fusszeile1';          ...
  'horizontalAlignment','left';...
  'fontSize',11;               ...
  'fontName','MISO';           ...
  'backgroundColor',fzBackgroundColor};
fusszeileSettings{2} = {'string',['Datum: ' timeStamp];...
  'position',[0,0,fzBreite,fzHoehe];...
  'tag','Fusszeile2';               ...
  'horizontalAlignment','left';     ...
  'fontSize',11;                    ...
  'fontName','MISO';                ...
  'backgroundColor',fzBackgroundColor};
end

function plotStruct = folderSetupRestlichePlots(plotStruct,projectName,szenarioNummer)
plotStruct.projectName           = projectName;
plotStruct.folderPathSzenarioTyp = szenarioNummer;
end

function plotStruct = folderSetupSzenarioUebergreifendePlots(plotStruct,folderStructure)
plotStruct.projectName           = 'Szenario-uebergreifend';
plotStruct.folderPathSzenarioTyp = folderStructure.folderPathSzenarioUebergreifend;
end

function [plotStruct,plotName] = plotSettings(plotStruct,standardAxesSettings,additionalAxesSettings,plotName,standardFigureSettings,index,szenarioUebergreifendePlots,plotType)
% Programmfluss-Steuerparameter
plotStruct.flaechenPlotAktiviert = false; % true, falls Flächenplot
plotStruct.plotType              = plotType;

localAxesSettings             = [standardAxesSettings;additionalAxesSettings];
plotName                      = extendPlotname(plotStruct,plotName,index,szenarioUebergreifendePlots);
localAdditionalFigureSettings = {'Name', plotName};
standardFigureSettings        = [standardFigureSettings;localAdditionalFigureSettings];

% Übergebe Settings an plotStruct
plotStruct.settings.figure = standardFigureSettings;
plotStruct.settings.axes   = localAxesSettings;
end

function plotNumbers = setPlotNumbers(plotArt,plotGattung,auswahl)
indexCollection = cell(1,length(plotArt)); % Preallocation cell
indexCollection = cellfun(@(x) {zeros(1,8),zeros(1,8)},indexCollection,'uniformOutput',0); % Preallocation content
plotNumbers     = cell(1,length(plotArt)); % Preallocation cell
plotNumbers     = cellfun(@(x) {0,0},plotNumbers,'uniformOutput',0); % Preallocation content

for index1 = 1:length(plotArt)
  for index2 = 1:length(plotGattung{index1})
    indexCollection{index1}{index2} = [];
    lengthAuswahlArray              = length(auswahl.(plotArt{index1}).(plotGattung{index1}{index2}));
    plotNumbers{index1}{index2}     = 1:lengthAuswahlArray;
    
    for ind3 = 1:lengthAuswahlArray
      value                           = auswahl.(plotArt{index1}).(plotGattung{index1}{index2})(ind3);
      indexCollection{index1}{index2} = [indexCollection{index1}{index2},value];
    end
    localIndexCollection        = logical(indexCollection{index1}{index2});
    plotNumbers{index1}{index2} = plotNumbers{index1}{index2}(localIndexCollection);
  end
end
end

function plotStruct = settingsRisikoLeistungsPlot(plotStruct,plotType,withArrow,backgroundColorMap,standardAxesSettingsRisikoLeistung,plotName,standardFigureSettings)
% Programmfluss-Steuerparameter
plotStruct.plotType           = 'risikoLeistungsPlot';
plotStruct.risikoLeistungsTyp = plotType;
plotStruct.plotArt            = 'risikoLeistungsPlot';
plotStruct.withArrow          = withArrow;

% Colormaps
plotStruct.backgroundColorMap = backgroundColorMap;

% x- / y-Tick-Labels
plotStruct.xTickLabelType = 'prozent';
plotStruct.yTickLabelType = 'prozent';

% Settings
plotStruct.settings.axes      = standardAxesSettingsRisikoLeistung;
localAdditionalFigureSettings = {'Name', plotName};
standardFigureSettings        = [standardFigureSettings;localAdditionalFigureSettings];
plotStruct.settings.figure    = standardFigureSettings;
end

function plotStruct = skalierungRisikoLeistungsPlot(plotStruct)
% Skalierung
for local_ind = 1:length(plotStruct.vectors)
  plotStruct.vectors{local_ind}.data   = plotStruct.vectors{local_ind}.data * 100;
  plotStruct.vectors{local_ind}.domain = plotStruct.vectors{local_ind}.domain * 100;
end
end

function vectors = cutVectors(vectors,shortLength)
for local_ind = 1:length(vectors)
  % Die ersten <shortLength> Einträge herausschneiden
  vectors{local_ind}.domain = vectors{local_ind}.domain(1:shortLength);
  vectors{local_ind}.data   = vectors{local_ind}.data(1:shortLength);
end
end

function plotName = extendPlotname(plotStruct,plotName,index,szenarioUebergreifendePlots)
% Für alle Plots ausser Bestandesplots und szenarioübergreifende Plots
if ~(strcmp(plotStruct.plotArt, 'bestandesPlot') || szenarioUebergreifendePlots)
  plotName = [plotName, ' - ', num2str(index)];
end
end

function farbe = dunkler(farbe, gradient) %#ok
farbe = gradient * farbe;
end

function titel = titelNummer(plotStruct,szenario)
idxPlan              = plotStruct.idxPlan;
numPlansKonsolidiert = plotStruct.numPlansKonsolidiert;
titel                = plotStruct.title;

if numPlansKonsolidiert > 1
  if idxPlan == numPlansKonsolidiert
    planString = ' (konsolidiert)';
  else
    planString = [' (Plan ',num2str(idxPlan),')'];
  end
else
  planString = '';
end

if nargin == 2
  if ~iscell(titel)
    titel = [titel,' ', szenario,planString];
  else
    numRows = size(titel,1);
    titel{numRows} = [titel{numRows}, ' ', szenario];
  end
end
end