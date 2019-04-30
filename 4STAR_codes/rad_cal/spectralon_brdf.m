function R = spectralon_brdf(theta_light,theta_view)
%% Details of the program:
% NAME:
%   spectralon_brdf
%
% PURPOSE:
%  Used for returning the brdf normalized reflectance for a spectralon
%  panel. Using the Levesque and Dissanska 2016 Canadian forces document. 
%  [DRDC-RDDC-2016-R221]
%
%  Also available through:
%  Martin P. Levesque, Maria Dissanska, "Correction of the calibration measurement by taking into account the Spectralon spectro-polarimetric BRDF model," Proc. SPIE 10750, Reflection, Scattering, and Diffraction from Surfaces VI, 107500H (4 September 2018);
%
% CALLING SEQUENCE:
%   R = spectralon_brdf(theta_light,theta_view)
%
% INPUT:
%  theta_light: angle with respet to normal of the incident light
%  theta_view: angle with respect to normal of the viewing sensor
%
% OUTPUT:
%  R: single value of normalized reflectance values (except when multiple theta_light and same number of
%  theta_view are used)
%
% DEPENDENCIES:
%  - version_set.m
%
% NEEDED FILES:
%  - None 
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, April 22nd, 2019
% -------------------------------------------------------------------------

%% codes
version_set('v1.0')

Incident_angle = [0.,10.,20.,30.,40.,45.,50.,60.,70.,75.];

%% set up the brdf. two row matrices, [viewing angle, reflectivity ratio] 
b.brdf00 = [[
-75.15254825669709,0.7791550608741988;-70.06830653091002,0.8241179854202172;-64.83532369080473,0.8532340244214344;-60.08912995210456,0.8776401577384784;
-55.46463348875568,0.8936325787130267;-50.36170300739957,0.9099197353860755;-47.37176467789514,0.9191250424944944;-44.97162396957812,0.9246334215846569;
-40.13077679449363,0.9355727320850992;-35.384583055793456,0.9464492635033572;-30.394994766390724,0.9557840479900274;-25.040314650934135,0.9653367566805477;
-15.547927173533807,0.9833278938375533;-14.087559869318383,0.9847531472844744;-10.241925968217728,0.9923946062174993;-8.43454420020936,0.9957769180608849;
7.817949693913135,0.9981901058871017;29.327056967044143,0.9508032846523079;34.226258445142236,0.9415654047431541;38.97245218384239,0.9327398389089593;
44.083737748596434,0.9206100206163838;49.19502331335045,0.9067704231480064;54.428006153455755,0.8905758481563792;58.93080534145332,0.8757551862595215;
63.798696355504774,0.8499619704174607;69.03167919561008,0.8202439125927248;73.89957020966153,0.7747966604792217]];

b.brdf10 = [[
-74.93619754496147,0.7340742310466772;-70.1900038062613,0.8101875997740893;-65.07871824150729,0.8401999474206645;-60.12947065780352,0.8627957778743519;
-55.22123893805311,0.882798181389923;-50.23342293906811,0.9009711869003378;-45.40432539304936,0.9131169831405154;-40.25247406984491,0.9269218457409473;
-35.40195150188727,0.9378389711470733;-30.394994766390724,0.9468681338675332;-25.40540647698799,0.9574556505369533;-20.245442002093455,0.9680451123693568;
-18.34696450661339,0.9717985615990655;-2.5019792558759235,0.9925512867439943;-0.49291083832903837,0.9935985534650307;4.410425984077122,0.9927143047381789;
9.76510609953371,0.9924310275679564;19.582019644537468,0.9785459921834994;29.114972880388223,0.9636109160304897;34.10456116979094,0.9540907224363822;
39.21584673454498,0.9476869785786419;43.96204047324514,0.9350760859828459;49.07332603799915,0.9246620422018896;54.02814367730153,0.9114660600815323;
58.973931074951565,0.8946386915542185;64.04209090620736,0.8754215217092786;68.90998192025882,0.8445210600476637;74.02126748501283,0.7880089825765135]];   

b.brdf20 = [[
-75.33378136200719,0.7420131788229942;-70.06003584229393,0.7962940973825597;-65.07871824150729,0.8305381247858249;-60.210827227455844,0.8530479701139732;
-55.099541662701824,0.8720232646370628;-50.23165064865037,0.8893635688512648;-45.12036508389636,0.9049090716737553;-40.25247406984491,0.9182230986742107;
-35.384583055793456,0.9291139032775035;-30.224618580898934,0.942145641905406;-28.082746534716293,0.9476558639029369;-11.95109659092914,0.9662317494934622;
-10.071549782725938,0.9663975883818997;-5.447053319377062,0.9669484422188064;-0.2749191169474017,0.968605680475261;4.532123259428403,0.9728805601301392;
9.400014273479854,0.9778437899465273;14.667767763685518,0.982736992653821;19.257493576934024,0.9887430795027963;29.206541218638023,0.9769363267879;
34.00720334950992,0.967591895621262;39.33754400989625,0.9622369549442574;44.2054350239477,0.9534623777859635;49.19502331335045,0.9445919273401062;
53.81951977669931,0.935244849693219;59.17419989215591,0.9200233976282549;64.16378818155863,0.9042489824186143;69.15337647096138,0.8782206971972447;
74.02126748501283,0.8180391877562926]];

b.brdf30 = [[
-74.86648745519715,0.7366859438104243;-70.19472991404206,0.7897168934239673;-64.98655913978496,0.8231765507839127;-60.26990357471378,0.8436049134500417;
-55.20115297998535,0.8608536987447959;-50.50044802867385,0.880118154964781;-45.38916246391986,0.895439251829655;-40.290479853247476,0.9108245690837181;
-38.28405017921148,0.9191136911698955;-22.529569892473134,0.9416716142225741;-20.659212738287835,0.9408445177934606;-15.399054778443826,0.9438712933627893;
-10.533999429060813,0.9466491609781935;-5.203658768674487,0.9505086788011677;-0.6618691914866162,0.955281930254478;4.775517810130978,0.9574970731420329;
9.156619722777279,0.9648569347155483;14.535639293304143,0.9715983968816159;19.62258540298791,0.9791664404509834;24.223451327433565,0.9873865248620279;
29.139784946236574,0.9924797150207796;33.94800884955774,0.9941368008451611;39.083515716687856,0.9909221576104823;44.2054350239477,0.9842186620576394;
49.19502331335045,0.9808781293899219;54.0629143274019,0.974081682704791;58.93080534145332,0.965006590579062;63.879827872405656,0.953216737283797;
69.15337647096138,0.9353554881351738;74.02126748501283,0.8888718424425766]];

b.brdf40 = [[
-75.20026881720429,0.7358752776128594;-71.65037111047675,0.7794840959185633;-64.34853458939958,0.8210777362708487;-60.45422177815841,0.8426148184861575;
-50.24831017857707,0.8752486551761425;-48.06473023123037,0.8858883640685042;-32.56605052811874,0.9115475455756967;-30.321267485012854,0.9136151017503548;
-25.28370920163671,0.9183362313805574;-20.4319000821166,0.9200022800666986;-15.377550988042017,0.925456020006352;-10.367100308579055,0.9278775053265279;
-5.429667994326877,0.9345079472754786;-0.17350472082131319,0.939421228174835;4.714669172455345,0.9474327163207333;9.552135867668966,0.9534156103286155;
14.79526014738687,0.960880810032253;19.66039426523298,0.971828983148991;24.231131252577,0.9805311161536939;29.006272401433677,0.99043765713071;
34.07974910394262,1.0083221555218387;39.45924128524754,1.0223488381400354;44.083737748596434,1.032109631647276;49.19502331335045,1.038471330490733;
53.91687759698033,1.0383164735769284;59.05250261680462,1.0379910217045571;64.04209090620736,1.0343582821455775;68.96406959819271,1.0271769916621527;
74.02126748501283,0.9901049235659883]];

b.brdf45 = [[
-74.81450026961019,0.7283863060733544;-69.65949820788532,0.7872873467173883;-65.2535842293907,0.8125484677236112;-60.18010752688173,0.8369769333949029;
-55.099541662701824,0.8541156692192874;-53.28589780188412,0.8685382633368497;-37.33658372188917,0.889039691301052;-35.13350857994732,0.8937541963414616;
-30.29778135495853,0.8988556179763093;-25.45963856377074,0.9034853587047763;-20.41581818758526,0.9078460679952126;-15.617468473734547,0.9105456001658905;
-10.436641608779794,0.9146480606132192;-5.460575238860528,0.9213528066135656;-0.5791623053256103,0.9261749026364455;4.410425984077122,0.9319473430862616;
9.52171154883115,0.9376756885048637;14.48696038316362,0.9490075770416021;19.598245947917633,0.9593586851870984;24.125384590985476,0.9733263876199727;
28.506486503631777,0.991273867051859;33.94623655913978,1.0115970710469027;38.88620071684585,1.0360284686031767;44.2054350239477,1.0612796196437069;
49.07332603799915,1.0778096977025502;54.184611602753165,1.0873362949263532;59.17419989215591,1.0933805503957994;63.92039363085607,1.1016848187319945;
68.9572429980652,1.1001908408278758;73.89957020966153,1.0808136115744071]];

b.brdf50 = [[
-75.40053763440861,0.7391516590804144;-70.06003584229393,0.7897501301023961;-65.21991071145366,0.8128951955551068;-60.18010752688173,0.8353409415748619;
-58.17741935483872,0.8496118917254877;-42.407579217813336,0.873342179582755;-40.282012243473844,0.8772153682924293;-35.262885780442176,0.8822746912877544;
-30.45584340406637,0.8849216625630006;-25.46625511466364,0.8898138726548731;-20.424173270983175,0.895064419045091;-15.513156523433437,0.8999982977646295;
-10.533999429060813,0.9055811333979775;-5.374034954166291,0.9108958406995321;-0.7008595806768909,0.9172551459284128;4.410425984077122,0.9201626119410874;
9.481145790380708,0.9302412217017694;14.389602562882587,0.9387748729413803;19.398686046880357,0.9512472932766491;24.066308243727605,0.9668242554844572;
29.439498947991666,0.987276808363846;33.67921146953404,1.011602934816867;39.01971326164872,1.0450234917284194;44.09555301804801,1.0787575138471561;
49.25764424144373,1.1195596360648574;53.85429042679968,1.1513777714247424;59.0698879418548,1.1743592999655723;64.38979740721103,1.1900422418463918;
68.81262409997777,1.2022007652349531;73.74744861547242,1.1974659075938607]];

b.brdf60 = [[
-75.0984605787632,0.7435692011017743;-70.06003584229393,0.7872961423723348;-65.18682795698925,0.8141829936011608;-52.304639673930325,0.8291003517418731;
-50.15721445110538,0.8369522848043446;-45.335234198351515,0.8398329600230162;-40.21190831139448,0.8426106714689038;-35.23246146160436,0.8477410831615553;
-30.449935769340584,0.8510277878480245;-25.40540647698799,0.8562602263272504;-20.41581818758526,0.8619011026083666;-15.622363371078805,0.8683479081097948;
-10.406040060900196,0.8731591910410414;-5.447053319377062,0.8819181896414557;-0.35939829352618347,0.887709187885373;4.488997525930131,0.8947529442579257;
9.431324737526566,0.9057561269747492;14.389602562882587,0.9195440407348165;19.17636206003317,0.9362209978791617;24.24708186633677,0.953330592150604;
29.48006470644208,0.9754456215443729;34.07974910394262,1.0115941391619208;39.082334189742085,1.0476824130295563;43.9307300091985,1.1079954384539934;
49.04556015478778,1.1824908607242417;54.11017540520828,1.2942303292733859;59.295897167507206,1.4271091555697735;75.48163478922825,0.9962071656955445]];

b.brdf70 = [[
-62.58333333333334,0.7814059854431912;-60.108625146699644,0.784392583809911;-55.27361996595512,0.7866424703993674;-50.27221640710081,0.7892613053084916;
-45.381144959649106,0.7937340558483875;-40.617565895898764,0.7959515857573438;-35.262885780442176,0.801845907000997;-30.51669204174202,0.8054069796894966;
-25.40540647698799,0.8108505949683277;-20.41581818758526,0.814800440794637;-15.457540362229238,0.820378980234249;-10.321738113363182,0.8281705206359624;
-5.530744811325775,0.8346566339984195;-0.5791623053256103,0.8436091945210333;4.472062306382838,0.8558369797571719;9.38819900402828,0.8703516050091904;
14.389602562882587,0.883245015487422;19.37919085228532,0.9061439336283511;24.41190487518631,0.9297893937504016;29.27979588923776,0.9432376299913151;
34.213261648745515,0.9800983647411511;39.01971326164872,1.0270275817079695;44.17825990420923,1.084202971283808;49.19502331335045,1.1820262996569366;
54.184611602753165,1.4034033995465822]];


b.brdf75 = [[
-67.14914729173941,0.7614798269988949;-65.20455086116667,0.7502638793781006;-60.19133203286076,0.7489267971238726;-55.302370454953966,0.7493008243504897;
-50.27221640710081,0.751675720375059;-45.30291099692329,0.7541864755389011;-40.37417134519619,0.7556834687676088;-35.34401729734303,0.7612169389698087;
-30.43812049988901,0.7663127712844959;-25.496502204459688,0.769749145456068;-20.487694410082398,0.7762118355223768;-15.533551929034388,0.7808976104250911;
-10.620959812224498,0.7875725828019131;-5.5734767025089695,0.7965139887562208;-0.7049949249849021,0.8055136172760154;4.331145526057,0.8147252833501428;
9.423644812383003,0.8316516572966345;14.322846290481152,0.8484444955578374;19.233863038030847,0.8678828929895063;24.33333333333337,0.896061745497724;
29.291611158689335,0.932022501828049;34.20262790623903,0.9757552571389615;39.420250896057325,1.047468683803534;44.083737748596434,1.1186839365070465;
49.06706394518983,1.2443330509772417;54.117855330351716,1.4373661735586392]];



%% Now interpolate the brdf at every incident angle for the proper viewing angle
brdf_view = zeros(size(Incident_angle));
for i=1:length(Incident_angle);
    brdf_view(i) = interp1(b.(['brdf' num2str(Incident_angle(i),'%02.0f')])(:,1),b.(['brdf' num2str(Incident_angle(i),'%02.0f')])(:,2),theta_view);
end

R = interp1(Incident_angle,brdf_view,theta_light);
return