function [iwvl,save_wvls,iwvl_archive] = get_wvl_subset(t,instrumentname)
%% Script to get wavelength indices for creating the polyfit wavelengths
% 
% Created by SL, 2018-04-12
% Updated: KP 2018-11-02.  Adding a case for NAAMES-3 4STARB that uses
%       polyfits excluding the longest wavelengths (where we have no good
%       signal/calibration) and the shortest (where it deviates from the linear
%       fit.  Hopefully this makes more plausible polyfit values than what
%       the first version was.  
%       also fixed the index for 1039.6 from 1095 to 1096.
% Updated: SL, 2019-03-21, v1.1
%       Added extra time differentiator for wvl_subset for handling
%       SEAC4RS, and not ORACLES
%       
% Updated: SL, 2024-10-17, v1.2
%       Added an output for 4STARB iwvl_archive - when archiving netcdf
%         files for full spectra (only AOD)

%%
version_set('1.2');
% control the input
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin<=1;
    instrumentname = '4STAR'; % by default use 4STAR
end;

switch instrumentname;
    case {'4STAR'}
        if t>datenum(2016,01,01,0,0,0); % for measurements for ORACLES and after
            save_wvls  = [354.9,380.0,451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,619.7,660.1,675.2,780.6,864.6,1019.9,1039.6,1064.2,1235.8,1249.9,1558.7,1626.6,1650.1];
            iwvl = [227    258    347    370     408     432     445     447     470     539  557     608     627     761     869    1084   1095   1109    1213    1222  1439   1492   1511];
            iwvl_archive = iwvl;
        elseif t>datenum(2012,01,01,0,0,0) ; %from the start of 4STAR with SEAC4RS
            save_wvls  = [353.3,354.9,380.0,451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,619.7,660.1,675.2,780.6,864.6,1019.9,1039.6,1064.2,1235.8,1249.9,1558.7,1626.6,1650.1];
            iwvl = [225  227    258    347    370     408     432     445     447     470     539  557     608     627     761     869    1084   1095   1109    1213    1222  1439   1492   1511];
            iwvl_archive = iwvl;
        end;

    case{'4STARB'}
        if t>datenum(2018,04,01,0,0,0); %this is any time after NAAMES-4
            save_wvls  = [355.1,380.1,452.0,469.7,500.3,520.3,530.0,532.4,550.0,605.1,620.3,660.0,675.0,779.8,865.4,1019.9,1039.6,1064.2,1235.0,1250.5,1560.2,1626.4,1650.1];
            iwvl = [ 227    258    347    369     407     432     444     447     469     538  557     607     626     759     869    1085   1096   1110    1214    1224  1443   1495   1514];
            iwvl_archive  = [ 255 256 257 258 259 260 261 ...
                              262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 ...
                              293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 ...
                              333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 ...
                              373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 ...
                              413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 ...
                              453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 479 480 481 482 483 484 485 486 487 488 489 490 491 492 ...
                              493 494 495 496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512 513 514 543 544 545 546 547 548 549 550 551 552 553 554 555 556 557 558 559 560 561 562 563 564 565 570 571 572 573 574 575 576 577 578 579 ...
                              580 581 582 583 584 585 586 587 592 593 594 595 596 597 598 599 600 601 602 603 604 605 606 607 608 609 610 611 612 613 614 615 616 617 618 619 ...
                              620 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 647 653 654 655 656 662 663 664 665 666 667 668 669 670 671 672 673 674 ...
                              716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 747 748 749 750 751 752 753 754 ...
                              755 756 757 758 759 760 761 762 763 764 765 766 767 768 769 770 771 772 773 774 775 776 777 778 779 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 ...
                              795 796 797 842 843 844 845 846 847 848 849 850 851 852 853 854 855 856 857 858 859 860 861 862 863 864 865 866 867 868 869 ...
                              870 871 872 873 874 875 876 877 878 879 880 881 882 883 884 885 ...
                              1036 1037 1038 1039 1040 1041 1072 1073 1074 1075 1076 1077 1078 1079 1080 1081 1082 1083 1084 1085 ...
                              1086 1087 1088 1089 1090 1091 1092 1093 1094 1095 1096 1097 1098 1099 1100 1101 ...
                              1215 1216 1217 1218 1219 1220 1221 1222 1223 1224 1225 1226 1227 1228 1243 1244 1245 ...
                              1246 1247 1248 1249 1432 1433 1434 1435 1436 ...
                              1437 1438 1439 1440 1441 1442 1443 1444 1445 1446 1447 1448 1449 1450 1451  ]; % based on AirSHARP difference between 10,000ft and 100ft
                              % s = load('\\192.168.10.201\data\sunsat\AirSHARP_2024\data_processed\allstarmats\4STARB_20241008starsun.mat');
                              % ibot = 9760; itop = 6962;
                              % delta_tau = s.tau_aero(ibot,408)-s.tau_aero(itop,408)
                              % tau_diff = (s.tau_aero(itop,:)+delta_tau)-s.tau_aero(ibot,:);
                              % iw_archive = tau_diff<0.04 & tau_diff>-0.015;
                              % 
        elseif t>datenum(2017,01,01,0,0,0); %FOR NAAMES-3/-4: we have no good calibration for >1300nm and the shorter wavelengths are also no good.  This is messing with the polyfits and making really implausible values.  For this case I am changing it 
            save_wvls  = [452.0,469.7,500.3,520.3,530.0,532.4,550.0,605.1,620.3,660.0,675.0,779.8,865.4,1019.9,1039.6,1064.2,1235.0,1250.5];
            iwvl = [347    369     407     432     444     447     469     538  557     607     626     759     869    1085   1096   1110    1214    1224];
            iwvl_archive = iwvl;
        end;
end;
return