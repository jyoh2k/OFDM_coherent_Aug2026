
function FilterCoef = ChBandwidthInit(NBandwidth,FilterTapNum, FilterType)

%  Usage      : FilterCoef = ChBandwidthInit(NBandwidth,FilterTapNum, FiltType)
%
%  Function   :
%     Obtain filter coefficients to model the bandwidth effect of channel.
%
%  Port       :
%     1. NBandwidth  : Normalized bandwidth  
%     2. FilterTapNum: The number of filter taps
%     3. FiltType   : Filter type 
%     4. FilterCoef : Filter coefficients
%
%  Author     : Rha, Hae Young.
%  Contact    : hyrha@miroandi.com   
%  Known bugs :


if ( MatLic ) 
    if ( FilterType == 0 )
        if ( NBandwidth <= 0.02)
            FilterCoef.b = [ 2.7689e-08  1.3844e-07  2.7689e-07  2.7689e-07  1.3844e-07  2.7689e-08];
            FilterCoef.a = [ 1     -4.7967      9.2072     -8.8404      4.2458    -0.81598];
            return;
        end
        if ( NBandwidth <= 0.03)
            FilterCoef.b = [ 2.0024e-07  1.0012e-06  2.0024e-06  2.0024e-06  1.0012e-06  2.0024e-07];
            FilterCoef.a = [ 1      -4.695      8.8261      -8.304      3.9099    -0.73703];
            return;
        end
        if ( NBandwidth <= 0.04)
            FilterCoef.b = [ 8.0424e-07  4.0212e-06  8.0424e-06  8.0424e-06  4.0212e-06  8.0424e-07];
            FilterCoef.a = [ 1     -4.5934      8.4551     -7.7949      3.5989    -0.66565];
            return;
        end
        if ( NBandwidth <= 0.05)
            FilterCoef.b = [ 2.341e-06  1.1705e-05   2.341e-05   2.341e-05  1.1705e-05   2.341e-06];
            FilterCoef.a = [ 1     -4.4918      8.0941     -7.3121       3.311    -0.60112];
            return;
        end
        if ( NBandwidth <= 0.06)
            FilterCoef.b = [ 5.5603e-06  2.7802e-05  5.5603e-05  5.5603e-05  2.7802e-05  5.5603e-06];
            FilterCoef.a = [ 1     -4.3903      7.7429     -6.8543      3.0447    -0.54275];
            return;
        end
        if ( NBandwidth <= 0.07)
            FilterCoef.b = [ 1.148e-05  5.7401e-05   0.0001148   0.0001148  5.7401e-05   1.148e-05];
            FilterCoef.a = [ 1     -4.2888      7.4015     -6.4207      2.7983    -0.48996];
            return;
        end
        if ( NBandwidth <= 0.08)
            FilterCoef.b = [ 2.1396e-05  0.00010698  0.00021396  0.00021396  0.00010698  2.1396e-05];
            FilterCoef.a = [ 1     -4.1873      7.0697       -6.01      2.5704    -0.44221];
            return;
        end
        if ( NBandwidth <= 0.09)
            FilterCoef.b = [ 3.6884e-05  0.00018442  0.00036884  0.00036884  0.00018442  3.6884e-05];
            FilterCoef.a = [ 1     -4.0859      6.7476     -5.6213      2.3598    -0.39901];
            return;
        end
        if ( NBandwidth <= 0.1)
            FilterCoef.b = [ 5.9796e-05  0.00029898  0.00059796  0.00059796  0.00029898  5.9796e-05];
            FilterCoef.a = [ 1     -3.9845      6.4349     -5.2536      2.1651    -0.35993];
            return;
        end
        if ( NBandwidth <= 0.11)
            FilterCoef.b = [ 9.2253e-05  0.00046126  0.00092253  0.00092253  0.00046126  9.2253e-05];
            FilterCoef.a = [ 1     -3.8833      6.1315     -4.9061      1.9853    -0.32457];
            return;
        end
        if ( NBandwidth <= 0.12)
            FilterCoef.b = [ 0.00013664  0.00068318   0.0013664   0.0013664  0.00068318  0.00013664];
            FilterCoef.a = [ 1     -3.7821      5.8375     -4.5777      1.8193    -0.29258];
            return;
        end
        if ( NBandwidth <= 0.13)
            FilterCoef.b = [ 0.00019557  0.00097786   0.0019557   0.0019557  0.00097786  0.00019557];
            FilterCoef.a = [ 1     -3.6809      5.5526     -4.2678       1.666    -0.26365];
            return;
        end
        if ( NBandwidth <= 0.14)
            FilterCoef.b = [ 0.00027193   0.0013596   0.0027193   0.0027193   0.0013596  0.00027193];
            FilterCoef.a = [ 1     -3.5799      5.2767     -3.9753      1.5246    -0.23747];
            return;
        end
        if ( NBandwidth <= 0.15)
            FilterCoef.b = [ 0.00036878   0.0018439   0.0036878   0.0036878   0.0018439  0.00036878];
            FilterCoef.a = [ 1     -3.4789      5.0098     -3.6995      1.3942     -0.2138];
            return;
        end
        if ( NBandwidth <= 0.16)
            FilterCoef.b = [ 0.00048944   0.0024472   0.0048944   0.0048944   0.0024472  0.00048944];
            FilterCoef.a = [ 1      -3.378      4.7518     -3.4397       1.274    -0.19239];
            return;
        end
        if ( NBandwidth <= 0.17)
            FilterCoef.b = [ 0.00063738   0.0031869   0.0063738   0.0063738   0.0031869  0.00063738];
            FilterCoef.a = [ 1     -3.2772      4.5025     -3.1951      1.1633    -0.17303];
            return;
        end
        if ( NBandwidth <= 0.18)
            FilterCoef.b = [ 0.00081629   0.0040814   0.0081629   0.0081629   0.0040814  0.00081629];
            FilterCoef.a = [ 1     -3.1765      4.2618     -2.9649      1.0613    -0.15553];
            return;
        end
        if ( NBandwidth <= 0.19)
            FilterCoef.b = [ 0.00103   0.0051501      0.0103      0.0103   0.0051501     0.00103];
            FilterCoef.a = [ 1     -3.0759      4.0297     -2.7485     0.96744    -0.13972];
            return;
        end
        if ( NBandwidth <= 0.2)
            FilterCoef.b = [ 0.0012826   0.0064129    0.012826    0.012826   0.0064129   0.0012826];
            FilterCoef.a = [ 1     -2.9754       3.806     -2.5453     0.88113    -0.12543];
            return;
        end
        if ( NBandwidth <= 0.21)
            FilterCoef.b = [ 0.0015782   0.0078908    0.015782    0.015782   0.0078908   0.0015782];
            FilterCoef.a = [ 1      -2.875      3.5907     -2.3544     0.80179    -0.11253];
            return;
        end
        if ( NBandwidth <= 0.22)
            FilterCoef.b = [ 0.0019211   0.0096054    0.019211    0.019211   0.0096054   0.0019211];
            FilterCoef.a = [ 1     -2.7747      3.3836     -2.1755     0.72892    -0.10087];
            return;
        end
        if ( NBandwidth <= 0.23)
            FilterCoef.b = [ 0.0023158    0.011579    0.023158    0.023158    0.011579   0.0023158];
            FilterCoef.a = [ 1     -2.6745      3.1847     -2.0078     0.66202   -0.090358];
            return;
        end
        if ( NBandwidth <= 0.24)
            FilterCoef.b = [ 0.0027669    0.013835    0.027669    0.027669    0.013835   0.0027669];
            FilterCoef.a = [ 1     -2.5744      2.9939     -1.8507     0.60067   -0.080871];
            return;
        end
        if ( NBandwidth <= 0.25)
            FilterCoef.b = [ 0.0032792    0.016396    0.032792    0.032792    0.016396   0.0032792];
            FilterCoef.a = [ 1     -2.4744       2.811     -1.7038     0.54443   -0.072316];
            return;
        end
        if ( NBandwidth <= 0.26)
            FilterCoef.b = [ 0.0038575    0.019288    0.038575    0.038575    0.019288   0.0038575];
            FilterCoef.a = [ 1     -2.3745       2.636     -1.5664     0.49294   -0.064605];
            return;
        end
        if ( NBandwidth <= 0.27)
            FilterCoef.b = [ 0.0045069    0.022534    0.045069    0.045069    0.022534   0.0045069];
            FilterCoef.a = [ 1     -2.2747      2.4689     -1.4381     0.44583   -0.057658];
            return;
        end
        if ( NBandwidth <= 0.28)
            FilterCoef.b = [ 0.0052324    0.026162    0.052324    0.052324    0.026162   0.0052324];
            FilterCoef.a = [ 1      -2.175      2.3095     -1.3184     0.40277   -0.051402];
            return;
        end
        if ( NBandwidth <= 0.29)
            FilterCoef.b = [ 0.0060394    0.030197    0.060394    0.060394    0.030197   0.0060394];
            FilterCoef.a = [ 1     -2.0754      2.1577     -1.2067     0.36346   -0.045773];
            return;
        end
        if ( NBandwidth <= 0.3)
            FilterCoef.b = [ 0.0069332    0.034666    0.069332    0.069332    0.034666   0.0069332];
            FilterCoef.a = [ 1     -1.9759      2.0135     -1.1026     0.32762   -0.040709];
            return;
        end
        if ( NBandwidth <= 0.31)
            FilterCoef.b = [ 0.0079194    0.039597    0.079194    0.079194    0.039597   0.0079194];
            FilterCoef.a = [ 1     -1.8765      1.8768     -1.0057     0.29498   -0.036157];
            return;
        end
        if ( NBandwidth <= 0.32)
            FilterCoef.b = [ 0.0090036    0.045018    0.090036    0.090036    0.045018   0.0090036];
            FilterCoef.a = [ 1     -1.7772      1.7475    -0.91547      0.2653   -0.032066];
            return;
        end
        if ( NBandwidth <= 0.33)
            FilterCoef.b = [ 0.010192    0.050959     0.10192     0.10192    0.050959    0.010192];
            FilterCoef.a = [ 1     -1.6779      1.6256    -0.83154     0.23836   -0.028392];
            return;
        end
        if ( NBandwidth <= 0.34)
            FilterCoef.b = [ 0.01149    0.057449      0.1149      0.1149    0.057449     0.01149];
            FilterCoef.a = [ 1     -1.5788       1.511    -0.75347     0.21395   -0.025092];
            return;
        end
        if ( NBandwidth <= 0.35)
            FilterCoef.b = [ 0.012904    0.064518     0.12904     0.12904    0.064518    0.012904];
            FilterCoef.a = [ 1     -1.4797      1.4037    -0.68086     0.19188    -0.02213];
            return;
        end
        if ( NBandwidth <= 0.36)
            FilterCoef.b = [ 0.01444      0.0722      0.1444      0.1444      0.0722     0.01444];
            FilterCoef.a = [ 1     -1.3807      1.3035    -0.61332     0.17199    -0.01947];
            return;
        end
        if ( NBandwidth <= 0.37)
            FilterCoef.b = [ 0.016105    0.080524     0.16105     0.16105    0.080524    0.016105];
            FilterCoef.a = [ 1     -1.2817      1.2105    -0.55047     0.15411   -0.017082];
            return;
        end
        if ( NBandwidth <= 0.38)
            FilterCoef.b = [ 0.017905    0.089526     0.17905     0.17905    0.089526    0.017905];
            FilterCoef.a = [ 1     -1.1829      1.1246    -0.49193      0.1381   -0.014935];
            return;
        end
        if ( NBandwidth <= 0.39)
            FilterCoef.b = [ 0.019848    0.099239     0.19848     0.19848    0.099239    0.019848];
            FilterCoef.a = [ 1     -1.0841      1.0457    -0.43735     0.12382   -0.013004];
            return;
        end
        if ( NBandwidth <= 0.4)
            FilterCoef.b = [ 0.02194      0.1097      0.2194      0.2194      0.1097     0.02194];
            FilterCoef.a = [ 1    -0.98533     0.97385    -0.38636     0.11116   -0.011264];
            return;
        end
        if ( NBandwidth <= 0.41)
            FilterCoef.b = [ 0.024188     0.12094     0.24188     0.24188     0.12094    0.024188];
            FilterCoef.a = [ 1    -0.88664     0.90893    -0.33861     0.10002  -0.0096912];
            return;
        end
        if ( NBandwidth <= 0.42)
            FilterCoef.b = [ 0.0266       0.133       0.266       0.266       0.133      0.0266];
            FilterCoef.a = [ 1      -0.788     0.85095    -0.29377    0.090295  -0.0082657];
            return;
        end
        if ( NBandwidth <= 0.43)
            FilterCoef.b = [ 0.029184     0.14592     0.29184     0.29184     0.14592    0.029184];
            FilterCoef.a = [ 1     -0.6894     0.79985    -0.25149    0.081905  -0.0069673];
            return;
        end
        if ( NBandwidth <= 0.44)
            FilterCoef.b = [ 0.031948     0.15974     0.31948     0.31948     0.15974    0.031948];
            FilterCoef.a = [ 1    -0.59084     0.75563    -0.21145    0.074777  -0.0057777];
            return;
        end
        if ( NBandwidth <= 0.45)
            FilterCoef.b = [ 0.0349      0.1745       0.349       0.349      0.1745      0.0349];
            FilterCoef.a = [ 1    -0.49232     0.71825    -0.17331    0.068849  -0.0046793];
            return;
        end
        if ( NBandwidth <= 0.46)
            FilterCoef.b = [ 0.038048     0.19024     0.38048     0.38048     0.19024    0.038048];
            FilterCoef.a = [ 1    -0.39382      0.6877    -0.13676     0.06407  -0.0036557];
            return;
        end
        if ( NBandwidth <= 0.47)
            FilterCoef.b = [ 0.041401     0.20701     0.41401     0.41401     0.20701    0.041401];
            FilterCoef.a = [ 1    -0.29534     0.66395    -0.10147    0.060396  -0.0026909];
            return;
        end
        if ( NBandwidth <= 0.48)
            FilterCoef.b = [ 0.044969     0.22485     0.44969     0.44969     0.22485    0.044969];
            FilterCoef.a = [ 1    -0.19689     0.64699   -0.067122    0.057795  -0.0017699];
            return;
        end
        if ( NBandwidth <= 0.49)
            FilterCoef.b = [ 0.048761      0.2438     0.48761     0.48761      0.2438    0.048761];
            FilterCoef.a = [ 1   -0.098441     0.63683   -0.033404    0.056244 -0.00087777];
            return;
        end
        if ( NBandwidth <= 0.5)
            FilterCoef.b = [ 0.052786     0.26393     0.52786     0.52786     0.26393    0.052786];
            FilterCoef.a = [ 1 -4.6491e-16     0.63344 -2.0438e-16    0.055728 -3.0935e-18];
            return;
        end
        if ( NBandwidth <= 0.51)
            FilterCoef.b = [ 0.057056     0.28528     0.57056     0.57056     0.28528    0.057056];
            FilterCoef.a = [ 1    0.098441     0.63683    0.033404    0.056244  0.00087777];
            return;
        end
        if ( NBandwidth <= 0.52)
            FilterCoef.b = [ 0.06158      0.3079      0.6158      0.6158      0.3079     0.06158];
            FilterCoef.a = [ 1     0.19689     0.64699    0.067122    0.057795   0.0017699];
            return;
        end
        if ( NBandwidth <= 0.53)
            FilterCoef.b = [ 0.06637     0.33185      0.6637      0.6637     0.33185     0.06637];
            FilterCoef.a = [ 1     0.29534     0.66395     0.10147    0.060396   0.0026909];
            return;
        end
        if ( NBandwidth <= 0.54)
            FilterCoef.b = [ 0.071437     0.35719     0.71437     0.71437     0.35719    0.071437];
            FilterCoef.a = [ 1     0.39382      0.6877     0.13676     0.06407   0.0036557];
            return;
        end
        if ( NBandwidth <= 0.55)
            FilterCoef.b = [ 0.076794     0.38397     0.76794     0.76794     0.38397    0.076794];
            FilterCoef.a = [ 1     0.49232     0.71825     0.17331    0.068849   0.0046793];
            return;
        end
        if ( NBandwidth <= 0.56)
            FilterCoef.b = [ 0.082452     0.41226     0.82452     0.82452     0.41226    0.082452];
            FilterCoef.a = [ 1     0.59084     0.75563     0.21145    0.074777   0.0057777];
            return;
        end
        if ( NBandwidth <= 0.57)
            FilterCoef.b = [ 0.088426     0.44213     0.88426     0.88426     0.44213    0.088426];
            FilterCoef.a = [ 1      0.6894     0.79985     0.25149    0.081905   0.0069673];
            return;
        end
        if ( NBandwidth <= 0.58)
            FilterCoef.b = [ 0.094727     0.47364     0.94727     0.94727     0.47364    0.094727];
            FilterCoef.a = [ 1       0.788     0.85095     0.29377    0.090295   0.0082657];
            return;
        end
        if ( NBandwidth <= 0.59)
            FilterCoef.b = [ 0.10137     0.50686      1.0137      1.0137     0.50686     0.10137];
            FilterCoef.a = [ 1     0.88664     0.90893     0.33861     0.10002   0.0096912];
            return;
        end
        if ( NBandwidth <= 0.6)
            FilterCoef.b = [ 0.10837     0.54187      1.0837      1.0837     0.54187     0.10837];
            FilterCoef.a = [ 1     0.98533     0.97385     0.38636     0.11116    0.011264];
            return;
        end
        if ( NBandwidth <= 0.61)
            FilterCoef.b = [ 0.11575     0.57874      1.1575      1.1575     0.57874     0.11575];
            FilterCoef.a = [ 1      1.0841      1.0457     0.43735     0.12382    0.013004];
            return;
        end
        if ( NBandwidth <= 0.62)
            FilterCoef.b = [ 0.12351     0.61757      1.2351      1.2351     0.61757     0.12351];
            FilterCoef.a = [ 1      1.1829      1.1246     0.49193      0.1381    0.014935];
            return;
        end
        if ( NBandwidth <= 0.63)
            FilterCoef.b = [ 0.13169     0.65843      1.3169      1.3169     0.65843     0.13169];
            FilterCoef.a = [ 1      1.2817      1.2105     0.55047     0.15411    0.017082];
            return;
        end
        if ( NBandwidth <= 0.64)
            FilterCoef.b = [ 0.14028      0.7014      1.4028      1.4028      0.7014     0.14028];
            FilterCoef.a = [ 1      1.3807      1.3035     0.61332     0.17199     0.01947];
            return;
        end
        if ( NBandwidth <= 0.65)
            FilterCoef.b = [ 0.14932      0.7466      1.4932      1.4932      0.7466     0.14932];
            FilterCoef.a = [ 1      1.4797      1.4037     0.68086     0.19188     0.02213];
            return;
        end
        if ( NBandwidth <= 0.66)
            FilterCoef.b = [ 0.15882     0.79411      1.5882      1.5882     0.79411     0.15882];
            FilterCoef.a = [ 1      1.5788       1.511     0.75347     0.21395    0.025092];
            return;
        end
        if ( NBandwidth <= 0.67)
            FilterCoef.b = [ 0.16881     0.84403      1.6881      1.6881     0.84403     0.16881];
            FilterCoef.a = [ 1      1.6779      1.6256     0.83154     0.23836    0.028392];
            return;
        end
        if ( NBandwidth <= 0.68)
            FilterCoef.b = [ 0.1793     0.89649       1.793       1.793     0.89649      0.1793];
            FilterCoef.a = [ 1      1.7772      1.7475     0.91547      0.2653    0.032066];
            return;
        end
        if ( NBandwidth <= 0.69)
            FilterCoef.b = [ 0.19032     0.95158      1.9032      1.9032     0.95158     0.19032];
            FilterCoef.a = [ 1      1.8765      1.8768      1.0057     0.29498    0.036157];
            return;
        end
        if ( NBandwidth <= 0.7)
            FilterCoef.b = [ 0.20189      1.0094      2.0189      2.0189      1.0094     0.20189];
            FilterCoef.a = [ 1      1.9759      2.0135      1.1026     0.32762    0.040709];
            return;
        end
        if ( NBandwidth <= 0.71)
            FilterCoef.b = [ 0.21403      1.0702      2.1403      2.1403      1.0702     0.21403];
            FilterCoef.a = [ 1      2.0754      2.1577      1.2067     0.36346    0.045773];
            return;
        end
        if ( NBandwidth <= 0.72)
            FilterCoef.b = [ 0.22678      1.1339      2.2678      2.2678      1.1339     0.22678];
            FilterCoef.a = [ 1       2.175      2.3095      1.3184     0.40277    0.051402];
            return;
        end
        if ( NBandwidth <= 0.73)
            FilterCoef.b = [ 0.24016      1.2008      2.4016      2.4016      1.2008     0.24016];
            FilterCoef.a = [ 1      2.2747      2.4689      1.4381     0.44583    0.057658];
            return;
        end
        if ( NBandwidth <= 0.74)
            FilterCoef.b = [ 0.2542       1.271       2.542       2.542       1.271      0.2542];
            FilterCoef.a = [ 1      2.3745       2.636      1.5664     0.49294    0.064605];
            return;
        end
        if ( NBandwidth <= 0.75)
            FilterCoef.b = [ 0.26894      1.3447      2.6894      2.6894      1.3447     0.26894];
            FilterCoef.a = [ 1      2.4744       2.811      1.7038     0.54443    0.072316];
            return;
        end
        if ( NBandwidth <= 0.76)
            FilterCoef.b = [ 0.28439       1.422      2.8439      2.8439       1.422     0.28439];
            FilterCoef.a = [ 1      2.5744      2.9939      1.8507     0.60067    0.080871];
            return;
        end
        if ( NBandwidth <= 0.77)
            FilterCoef.b = [ 0.30061       1.503      3.0061      3.0061       1.503     0.30061];
            FilterCoef.a = [ 1      2.6745      3.1847      2.0078     0.66202    0.090358];
            return;
        end
        if ( NBandwidth <= 0.78)
            FilterCoef.b = [ 0.31761      1.5881      3.1761      3.1761      1.5881     0.31761];
            FilterCoef.a = [ 1      2.7747      3.3836      2.1755     0.72892     0.10087];
            return;
        end
        if ( NBandwidth <= 0.79)
            FilterCoef.b = [ 0.33545      1.6773      3.3545      3.3545      1.6773     0.33545];
            FilterCoef.a = [ 1       2.875      3.5907      2.3544     0.80179     0.11253];
            return;
        end
        if ( NBandwidth <= 0.8)
            FilterCoef.b = [ 0.35416      1.7708      3.5416      3.5416      1.7708     0.35416];
            FilterCoef.a = [ 1      2.9754       3.806      2.5453     0.88113     0.12543];
            return;
        end
        if ( NBandwidth <= 0.81)
            FilterCoef.b = [ 0.37379       1.869      3.7379      3.7379       1.869     0.37379];
            FilterCoef.a = [ 1      3.0759      4.0297      2.7485     0.96744     0.13972];
            return;
        end
        if ( NBandwidth <= 0.82)
            FilterCoef.b = [ 0.39438      1.9719      3.9438      3.9438      1.9719     0.39438];
            FilterCoef.a = [ 1      3.1765      4.2618      2.9649      1.0613     0.15553];
            return;
        end
        if ( NBandwidth <= 0.83)
            FilterCoef.b = [ 0.41597      2.0799      4.1597      4.1597      2.0799     0.41597];
            FilterCoef.a = [ 1      3.2772      4.5025      3.1951      1.1633     0.17303];
            return;
        end
        if ( NBandwidth <= 0.84)
            FilterCoef.b = [ 0.43862      2.1931      4.3862      4.3862      2.1931     0.43862];
            FilterCoef.a = [ 1       3.378      4.7518      3.4397       1.274     0.19239];
            return;
        end
        if ( NBandwidth <= 0.85)
            FilterCoef.b = [ 0.46238      2.3119      4.6238      4.6238      2.3119     0.46238];
            FilterCoef.a = [ 1      3.4789      5.0098      3.6995      1.3942      0.2138];
            return;
        end
        if ( NBandwidth <= 0.86)
            FilterCoef.b = [ 0.48731      2.4366      4.8731      4.8731      2.4366     0.48731];
            FilterCoef.a = [ 1      3.5799      5.2767      3.9753      1.5246     0.23747];
            return;
        end
        if ( NBandwidth <= 0.87)
            FilterCoef.b = [ 0.51347      2.5673      5.1347      5.1347      2.5673     0.51347];
            FilterCoef.a = [ 1      3.6809      5.5526      4.2678       1.666     0.26365];
            return;
        end
        if ( NBandwidth <= 0.88)
            FilterCoef.b = [ 0.54091      2.7046      5.4091      5.4091      2.7046     0.54091];
            FilterCoef.a = [ 1      3.7821      5.8375      4.5777      1.8193     0.29258];
            return;
        end
        if ( NBandwidth <= 0.89)
            FilterCoef.b = [ 0.56971      2.8486      5.6971      5.6971      2.8486     0.56971];
            FilterCoef.a = [ 1      3.8833      6.1315      4.9061      1.9853     0.32457];
            return;
        end
        if ( NBandwidth <= 0.9)
            FilterCoef.b = [ 0.59994      2.9997      5.9994      5.9994      2.9997     0.59994];
            FilterCoef.a = [ 1      3.9845      6.4349      5.2536      2.1651     0.35993];
            return;
        end
        if ( NBandwidth <= 0.91)
            FilterCoef.b = [ 0.63167      3.1584      6.3167      6.3167      3.1584     0.63167];
            FilterCoef.a = [ 1      4.0859      6.7476      5.6213      2.3598     0.39901];
            return;
        end
        if ( NBandwidth <= 0.92)
            FilterCoef.b = [ 0.66499      3.3249      6.6499      6.6499      3.3249     0.66499];
            FilterCoef.a = [ 1      4.1873      7.0697        6.01      2.5704     0.44221];
            return;
        end
        if ( NBandwidth <= 0.93)
            FilterCoef.b = [ 0.69997      3.4999      6.9997      6.9997      3.4999     0.69997];
            FilterCoef.a = [ 1      4.2888      7.4015      6.4207      2.7983     0.48996];
            return;
        end
        if ( NBandwidth <= 0.94)
            FilterCoef.b = [ 0.73672      3.6836      7.3672      7.3672      3.6836     0.73672];
            FilterCoef.a = [ 1      4.3903      7.7429      6.8543      3.0447     0.54275];
            return;
        end
        if ( NBandwidth <= 0.95)
            FilterCoef.b = [ 0.77532      3.8766      7.7532      7.7532      3.8766     0.77532];
            FilterCoef.a = [ 1      4.4918      8.0941      7.3121       3.311     0.60112];
            return;
        end
        if ( NBandwidth <= 0.96)
            FilterCoef.b = [ 0.81588      4.0794      8.1588      8.1588      4.0794     0.81588];
            FilterCoef.a = [ 1      4.5934      8.4551      7.7949      3.5989     0.66565];
            return;
        end
        if ( NBandwidth <= 0.97)
            FilterCoef.b = [ 0.8585      4.2925       8.585       8.585      4.2925      0.8585];
            FilterCoef.a = [ 1       4.695      8.8261       8.304      3.9099     0.73703];
            return;
        end
        if ( NBandwidth <= 0.98)
            FilterCoef.b = [ 0.90331      4.5166      9.0331      9.0331      4.5166     0.90331];
            FilterCoef.a = [ 1      4.7967      9.2072      8.8404      4.2458     0.81598];
            return;
        end
        if ( NBandwidth <= 0.99)
            FilterCoef.b = [ 0.95044      4.7522      9.5044      9.5044      4.7522     0.95044];
            FilterCoef.a = [ 1      4.8983      9.5985      9.4053      4.6085     0.90333];
            return;
        end
    end
    
    if ( FilterType == 1 )
        
        if ( NBandwidth <= 0.02)
            FilterCoef.b = [ 6.8675e-06  3.4338e-05  6.8675e-05  6.8675e-05  3.4338e-05  6.8675e-06];
            FilterCoef.a = [ 1     -4.2598       7.289      -6.261      2.6992    -0.46713];
            return;
        end
        if ( NBandwidth <= 0.03)
            FilterCoef.b = [ 4.3408e-05  0.00021704  0.00043408  0.00043408  0.00021704  4.3408e-05];
            FilterCoef.a = [ 1     -3.9086      6.1716     -4.9169      1.9751    -0.31985];
            return;
        end
        if ( NBandwidth <= 0.04)
            FilterCoef.b = [ 0.00015275  0.00076375   0.0015275   0.0015275  0.00076375  0.00015275];
            FilterCoef.a = [ 1     -3.5715      5.1972     -3.8441      1.4428    -0.21949];
            return;
        end
        if ( NBandwidth <= 0.05)
            FilterCoef.b = [ 0.0003906    0.001953    0.003906    0.003906    0.001953   0.0003906];
            FilterCoef.a = [ 1      -3.249      4.3531     -2.9933      1.0527    -0.15106];
            return;
        end
        if ( NBandwidth <= 0.06)
            FilterCoef.b = [ 0.00081726   0.0040863   0.0081726   0.0081726   0.0040863  0.00081726];
            FilterCoef.a = [ 1     -2.9414      3.6265     -2.3223     0.76772    -0.10433];
            return;
        end
        if ( NBandwidth <= 0.07)
            FilterCoef.b = [ 0.0014906   0.0074532    0.014906    0.014906   0.0074532   0.0014906];
            FilterCoef.a = [ 1     -2.6487      3.0048     -1.7961     0.56002   -0.072361];
            return;
        end
        if ( NBandwidth <= 0.08)
            FilterCoef.b = [ 0.0024614    0.012307    0.024614    0.024614    0.012307   0.0024614];
            FilterCoef.a = [ 1     -2.3707      2.4764     -1.3854     0.40888   -0.050427];
            return;
        end
        if ( NBandwidth <= 0.09)
            FilterCoef.b = [ 0.0037701    0.018851    0.037701    0.037701    0.018851   0.0037701];
            FilterCoef.a = [ 1      -2.107      2.0303     -1.0663     0.29899   -0.035326];
            return;
        end
        if ( NBandwidth <= 0.1)
            FilterCoef.b = [ 0.0054465    0.027233    0.054465    0.054465    0.027233   0.0054465];
            FilterCoef.a = [ 1     -1.8571      1.6567    -0.81952      0.2191   -0.024887];
            return;
        end
        if ( NBandwidth <= 0.11)
            FilterCoef.b = [ 0.0075094    0.037547    0.075094    0.075094    0.037547   0.0075094];
            FilterCoef.a = [ 1     -1.6203      1.3465    -0.62919       0.161   -0.017637];
            return;
        end
        if ( NBandwidth <= 0.12)
            FilterCoef.b = [ 0.0099675    0.049837    0.099675    0.099675    0.049837   0.0099675];
            FilterCoef.a = [ 1     -1.3962      1.0917    -0.48268     0.11872   -0.012576];
            return;
        end
        if ( NBandwidth <= 0.13)
            FilterCoef.b = [ 0.012821    0.064105     0.12821     0.12821    0.064105    0.012821];
            FilterCoef.a = [ 1      -1.184     0.88518    -0.36985    0.087916  -0.0090213];
            return;
        end
        if ( NBandwidth <= 0.14)
            FilterCoef.b = [ 0.016063    0.080314     0.16063     0.16063    0.080314    0.016063];
            FilterCoef.a = [ 1      -0.983     0.72068    -0.28265    0.065483  -0.0065072];
            return;
        end
        if ( NBandwidth <= 0.15)
            FilterCoef.b = [ 0.01968    0.098402      0.1968      0.1968    0.098402     0.01968];
            FilterCoef.a = [ 1    -0.79267     0.59263    -0.21467    0.049189  -0.0047128];
            return;
        end
        if ( NBandwidth <= 0.16)
            FilterCoef.b = [ 0.023657     0.11828     0.23657     0.23657     0.11828    0.023657];
            FilterCoef.a = [ 1    -0.61233     0.49618    -0.16086    0.037448  -0.0034157];
            return;
        end
        if ( NBandwidth <= 0.17)
            FilterCoef.b = [ 0.027971     0.13986     0.27971     0.27971     0.13986    0.027971];
            FilterCoef.a = [ 1    -0.44138     0.42706    -0.11727    0.029136  -0.0024598];
            return;
        end
        if ( NBandwidth <= 0.18)
            FilterCoef.b = [ 0.032602     0.16301     0.32602     0.32602     0.16301    0.032602];
            FilterCoef.a = [ 1    -0.27924     0.38156   -0.080783    0.023467  -0.0017347];
            return;
        end
        if ( NBandwidth <= 0.19)
            FilterCoef.b = [ 0.037525     0.18763     0.37525     0.37525     0.18763    0.037525];
            FilterCoef.a = [ 1    -0.12536     0.35645   -0.049011    0.019892  -0.0011605];
            return;
        end
        if ( NBandwidth <= 0.2)
            FilterCoef.b = [ 0.042717     0.21358     0.42717     0.42717     0.21358    0.042717];
            FilterCoef.a = [ 1    0.020779     0.34891     -0.0201     0.01803  -0.0006787];
            return;
        end
        if ( NBandwidth <= 0.21)
            FilterCoef.b = [ 0.048152     0.24076     0.48152     0.48152     0.24076    0.048152];
            FilterCoef.a = [ 1     0.15967     0.35647   0.0073584    0.017622 -0.00024564];
            return;
        end
        if ( NBandwidth <= 0.22)
            FilterCoef.b = [ 0.053808     0.26904     0.53808     0.53808     0.26904    0.053808];
            FilterCoef.a = [ 1     0.29176     0.37699    0.034428     0.01849  0.00017203];
            return;
        end
        if ( NBandwidth <= 0.23)
            FilterCoef.b = [ 0.05966      0.2983      0.5966      0.5966      0.2983     0.05966];
            FilterCoef.a = [ 1     0.41748     0.40863    0.061895    0.020513  0.00060013];
            return;
        end
        if ( NBandwidth <= 0.24)
            FilterCoef.b = [ 0.065687     0.32843     0.65687     0.65687     0.32843    0.065687];
            FilterCoef.a = [ 1     0.53723     0.44975    0.090331    0.023608    0.001059];
            return;
        end
        if ( NBandwidth <= 0.25)
            FilterCoef.b = [ 0.071867     0.35934     0.71867     0.71867     0.35934    0.071867];
            FilterCoef.a = [ 1     0.65139     0.49896     0.12014    0.027717   0.0015649];
            return;
        end
        if ( NBandwidth <= 0.26)
            FilterCoef.b = [ 0.078181     0.39091     0.78181     0.78181     0.39091    0.078181];
            FilterCoef.a = [ 1     0.76029     0.55501     0.15158    0.032797   0.0021308];
            return;
        end
        if ( NBandwidth <= 0.27)
            FilterCoef.b = [ 0.08461     0.42305      0.8461      0.8461     0.42305     0.08461];
            FilterCoef.a = [ 1     0.86426     0.61685     0.18483    0.038818   0.0027672];
            return;
        end
        if ( NBandwidth <= 0.28)
            FilterCoef.b = [ 0.091136     0.45568     0.91136     0.91136     0.45568    0.091136];
            FilterCoef.a = [ 1      0.9636     0.68355     0.21997     0.04575   0.0034824];
            return;
        end
        if ( NBandwidth <= 0.29)
            FilterCoef.b = [ 0.097743     0.48871     0.97743     0.97743     0.48871    0.097743];
            FilterCoef.a = [ 1      1.0586      0.7543     0.25703    0.053569   0.0042832];
            return;
        end
        if ( NBandwidth <= 0.3)
            FilterCoef.b = [ 0.10442     0.52208      1.0442      1.0442     0.52208     0.10442];
            FilterCoef.a = [ 1      1.1495      0.8284       0.296    0.062251   0.0051748];
            return;
        end
        if ( NBandwidth <= 0.31)
            FilterCoef.b = [ 0.11114      0.5557      1.1114      1.1114      0.5557     0.11114];
            FilterCoef.a = [ 1      1.2365     0.90523     0.33681    0.071771   0.0061611];
            return;
        end
        if ( NBandwidth <= 0.32)
            FilterCoef.b = [ 0.1179     0.58952       1.179       1.179     0.58952      0.1179];
            FilterCoef.a = [ 1      1.3199     0.98427      0.3794    0.082103    0.007245];
            return;
        end
        if ( NBandwidth <= 0.33)
            FilterCoef.b = [ 0.1247     0.62348       1.247       1.247     0.62348      0.1247];
            FilterCoef.a = [ 1      1.3999      1.0651     0.42367     0.09322   0.0084285];
            return;
        end
        if ( NBandwidth <= 0.34)
            FilterCoef.b = [ 0.1315     0.65752       1.315       1.315     0.65752      0.1315];
            FilterCoef.a = [ 1      1.4767      1.1472     0.46951     0.10509   0.0097125];
            return;
        end
        if ( NBandwidth <= 0.35)
            FilterCoef.b = [ 0.13832      0.6916      1.3832      1.3832      0.6916     0.13832];
            FilterCoef.a = [ 1      1.5504      1.2303     0.51682     0.11769    0.011098];
            return;
        end
        if ( NBandwidth <= 0.36)
            FilterCoef.b = [ 0.14513     0.72567      1.4513      1.4513     0.72567     0.14513];
            FilterCoef.a = [ 1      1.6212      1.3141     0.56548     0.13099    0.012583];
            return;
        end
        if ( NBandwidth <= 0.37)
            FilterCoef.b = [ 0.15194      0.7597      1.5194      1.5194      0.7597     0.15194];
            FilterCoef.a = [ 1      1.6893      1.3983     0.61538     0.14495    0.014169];
            return;
        end
        if ( NBandwidth <= 0.38)
            FilterCoef.b = [ 0.15873     0.79364      1.5873      1.5873     0.79364     0.15873];
            FilterCoef.a = [ 1      1.7548      1.4827     0.66639     0.15954    0.015853];
            return;
        end
        if ( NBandwidth <= 0.39)
            FilterCoef.b = [ 0.16549     0.82746      1.6549      1.6549     0.82746     0.16549];
            FilterCoef.a = [ 1      1.8179      1.5671     0.71841     0.17473    0.017635];
            return;
        end
        if ( NBandwidth <= 0.4)
            FilterCoef.b = [ 0.17223     0.86114      1.7223      1.7223     0.86114     0.17223];
            FilterCoef.a = [ 1      1.8787      1.6513     0.77133     0.19048    0.019511];
            return;
        end
        if ( NBandwidth <= 0.41)
            FilterCoef.b = [ 0.17893     0.89465      1.7893      1.7893     0.89465     0.17893];
            FilterCoef.a = [ 1      1.9373      1.7352     0.82505     0.20678     0.02148];
            return;
        end
        if ( NBandwidth <= 0.42)
            FilterCoef.b = [ 0.18559     0.92797      1.8559      1.8559     0.92797     0.18559];
            FilterCoef.a = [ 1      1.9938      1.8186     0.87945     0.22357    0.023538];
            return;
        end
        if ( NBandwidth <= 0.43)
            FilterCoef.b = [ 0.19221     0.96107      1.9221      1.9221     0.96107     0.19221];
            FilterCoef.a = [ 1      2.0483      1.9015     0.93446     0.24083    0.025684];
            return;
        end
        if ( NBandwidth <= 0.44)
            FilterCoef.b = [ 0.19879     0.99393      1.9879      1.9879     0.99393     0.19879];
            FilterCoef.a = [ 1       2.101      1.9838     0.98998     0.25854    0.027915];
            return;
        end
        if ( NBandwidth <= 0.45)
            FilterCoef.b = [ 0.20531      1.0265      2.0531      2.0531      1.0265     0.20531];
            FilterCoef.a = [ 1      2.1518      2.0653      1.0459     0.27665    0.030226];
            return;
        end
        if ( NBandwidth <= 0.46)
            FilterCoef.b = [ 0.21178      1.0589      2.1178      2.1178      1.0589     0.21178];
            FilterCoef.a = [ 1       2.201       2.146      1.1022     0.29514    0.032616];
            return;
        end
        if ( NBandwidth <= 0.47)
            FilterCoef.b = [ 0.2182       1.091       2.182       2.182       1.091      0.2182];
            FilterCoef.a = [ 1      2.2486      2.2258      1.1588     0.31399    0.035081];
            return;
        end
        if ( NBandwidth <= 0.48)
            FilterCoef.b = [ 0.22455      1.1228      2.2455      2.2455      1.1228     0.22455];
            FilterCoef.a = [ 1      2.2946      2.3048      1.2156     0.33315    0.037617];
            return;
        end
        if ( NBandwidth <= 0.49)
            FilterCoef.b = [ 0.23085      1.1543      2.3085      2.3085      1.1543     0.23085];
            FilterCoef.a = [ 1      2.3391      2.3828      1.2725     0.35262    0.040222];
            return;
        end
        if ( NBandwidth <= 0.5)
            FilterCoef.b = [ 0.23709      1.1854      2.3709      2.3709      1.1854     0.23709];
            FilterCoef.a = [ 1      2.3822      2.4599      1.3295     0.37235    0.042892];
            return;
        end
        if ( NBandwidth <= 0.51)
            FilterCoef.b = [ 0.24326      1.2163      2.4326      2.4326      1.2163     0.24326];
            FilterCoef.a = [ 1       2.424       2.536      1.3865     0.39234    0.045624];
            return;
        end
        if ( NBandwidth <= 0.52)
            FilterCoef.b = [ 0.24938      1.2469      2.4938      2.4938      1.2469     0.24938];
            FilterCoef.a = [ 1      2.4645       2.611      1.4435     0.41254    0.048416];
            return;
        end
        if ( NBandwidth <= 0.53)
            FilterCoef.b = [ 0.25542      1.2771      2.5542      2.5542      1.2771     0.25542];
            FilterCoef.a = [ 1      2.5038      2.6851      1.5004     0.43295    0.051262];
            return;
        end
        if ( NBandwidth <= 0.54)
            FilterCoef.b = [ 0.26141       1.307      2.6141      2.6141       1.307     0.26141];
            FilterCoef.a = [ 1      2.5419      2.7581      1.5573     0.45354    0.054162];
            return;
        end
        if ( NBandwidth <= 0.55)
            FilterCoef.b = [ 0.26732      1.3366      2.6732      2.6732      1.3366     0.26732];
            FilterCoef.a = [ 1      2.5789      2.8301      1.6139     0.47429    0.057111];
            return;
        end
        if ( NBandwidth <= 0.56)
            FilterCoef.b = [ 0.27317      1.3659      2.7317      2.7317      1.3659     0.27317];
            FilterCoef.a = [ 1      2.6148       2.901      1.6704     0.49517    0.060106];
            return;
        end
        if ( NBandwidth <= 0.57)
            FilterCoef.b = [ 0.27896      1.3948      2.7896      2.7896      1.3948     0.27896];
            FilterCoef.a = [ 1      2.6497      2.9709      1.7267     0.51618    0.063146];
            return;
        end
        if ( NBandwidth <= 0.58)
            FilterCoef.b = [ 0.28467      1.4234      2.8467      2.8467      1.4234     0.28467];
            FilterCoef.a = [ 1      2.6836      3.0397      1.7827      0.5373    0.066226];
            return;
        end
        if ( NBandwidth <= 0.59)
            FilterCoef.b = [ 0.29033      1.4516      2.9033      2.9033      1.4516     0.29033];
            FilterCoef.a = [ 1      2.7166      3.1075      1.8385      0.5585    0.069344];
            return;
        end
        if ( NBandwidth <= 0.6)
            FilterCoef.b = [ 0.29591      1.4796      2.9591      2.9591      1.4796     0.29591];
            FilterCoef.a = [ 1      2.7486      3.1743       1.894     0.57978    0.072498];
            return;
        end
        if ( NBandwidth <= 0.61)
            FilterCoef.b = [ 0.30143      1.5071      3.0143      3.0143      1.5071     0.30143];
            FilterCoef.a = [ 1      2.7798        3.24      1.9491     0.60111    0.075685];
            return;
        end
        if ( NBandwidth <= 0.62)
            FilterCoef.b = [ 0.30688      1.5344      3.0688      3.0688      1.5344     0.30688];
            FilterCoef.a = [ 1      2.8102      3.3048      2.0039     0.62249    0.078903];
            return;
        end
        if ( NBandwidth <= 0.63)
            FilterCoef.b = [ 0.31227      1.5613      3.1227      3.1227      1.5613     0.31227];
            FilterCoef.a = [ 1      2.8397      3.3685      2.0583      0.6439    0.082148];
            return;
        end
        if ( NBandwidth <= 0.64)
            FilterCoef.b = [ 0.31759      1.5879      3.1759      3.1759      1.5879     0.31759];
            FilterCoef.a = [ 1      2.8685      3.4313      2.1124     0.66532     0.08542];
            return;
        end
        if ( NBandwidth <= 0.65)
            FilterCoef.b = [ 0.32285      1.6142      3.2285      3.2285      1.6142     0.32285];
            FilterCoef.a = [ 1      2.8965       3.493      2.1661     0.68676    0.088715];
            return;
        end
        if ( NBandwidth <= 0.66)
            FilterCoef.b = [ 0.32804      1.6402      3.2804      3.2804      1.6402     0.32804];
            FilterCoef.a = [ 1      2.9238      3.5538      2.2193     0.70819    0.092031];
            return;
        end
        if ( NBandwidth <= 0.67)
            FilterCoef.b = [ 0.33317      1.6658      3.3317      3.3317      1.6658     0.33317];
            FilterCoef.a = [ 1      2.9504      3.6137      2.2722     0.72961    0.095367];
            return;
        end
        if ( NBandwidth <= 0.68)
            FilterCoef.b = [ 0.33823      1.6911      3.3823      3.3823      1.6911     0.33823];
            FilterCoef.a = [ 1      2.9764      3.6726      2.3246       0.751    0.098721];
            return;
        end
        if ( NBandwidth <= 0.69)
            FilterCoef.b = [ 0.34323      1.7162      3.4323      3.4323      1.7162     0.34323];
            FilterCoef.a = [ 1      3.0017      3.7306      2.3767     0.77236     0.10209];
            return;
        end
        if ( NBandwidth <= 0.7)
            FilterCoef.b = [ 0.34817      1.7409      3.4817      3.4817      1.7409     0.34817];
            FilterCoef.a = [ 1      3.0264      3.7876      2.4282     0.79368     0.10547];
            return;
        end
        if ( NBandwidth <= 0.71)
            FilterCoef.b = [ 0.35305      1.7652      3.5305      3.5305      1.7652     0.35305];
            FilterCoef.a = [ 1      3.0505      3.8438      2.4794     0.81496     0.10887];
            return;
        end
        if ( NBandwidth <= 0.72)
            FilterCoef.b = [ 0.35786      1.7893      3.5786      3.5786      1.7893     0.35786];
            FilterCoef.a = [ 1      3.0741      3.8991        2.53     0.83618     0.11227];
            return;
        end
        if ( NBandwidth <= 0.73)
            FilterCoef.b = [ 0.36262      1.8131      3.6262      3.6262      1.8131     0.36262];
            FilterCoef.a = [ 1       3.097      3.9536      2.5802     0.85733     0.11569];
            return;
        end
        if ( NBandwidth <= 0.74)
            FilterCoef.b = [ 0.36732      1.8366      3.6732      3.6732      1.8366     0.36732];
            FilterCoef.a = [ 1      3.1195      4.0071        2.63     0.87842     0.11911];
            return;
        end
        if ( NBandwidth <= 0.75)
            FilterCoef.b = [ 0.37196      1.8598      3.7196      3.7196      1.8598     0.37196];
            FilterCoef.a = [ 1      3.1414      4.0599      2.6793     0.89943     0.12254];
            return;
        end
        if ( NBandwidth <= 0.76)
            FilterCoef.b = [ 0.37653      1.8827      3.7653      3.7653      1.8827     0.37653];
            FilterCoef.a = [ 1      3.1628      4.1118      2.7281     0.92036     0.12597];
            return;
        end
        if ( NBandwidth <= 0.77)
            FilterCoef.b = [ 0.38106      1.9053      3.8106      3.8106      1.9053     0.38106];
            FilterCoef.a = [ 1      3.1838      4.1629      2.7765     0.94121      0.1294];
            return;
        end
        if ( NBandwidth <= 0.78)
            FilterCoef.b = [ 0.38552      1.9276      3.8552      3.8552      1.9276     0.38552];
            FilterCoef.a = [ 1      3.2043      4.2132      2.8244     0.96196     0.13284];
            return;
        end
        if ( NBandwidth <= 0.79)
            FilterCoef.b = [ 0.38993      1.9497      3.8993      3.8993      1.9497     0.38993];
            FilterCoef.a = [ 1      3.2243      4.2628      2.8719     0.98262     0.13628];
            return;
        end
        if ( NBandwidth <= 0.8)
            FilterCoef.b = [ 0.39429      1.9714      3.9429      3.9429      1.9714     0.39429];
            FilterCoef.a = [ 1      3.2439      4.3116      2.9189      1.0032     0.13972];
            return;
        end
        if ( NBandwidth <= 0.81)
            FilterCoef.b = [ 0.39859      1.9929      3.9859      3.9859      1.9929     0.39859];
            FilterCoef.a = [ 1       3.263      4.3596      2.9654      1.0236     0.14315];
            return;
        end
        if ( NBandwidth <= 0.82)
            FilterCoef.b = [ 0.40284      2.0142      4.0284      4.0284      2.0142     0.40284];
            FilterCoef.a = [ 1      3.2818      4.4069      3.0114       1.044     0.14659];
            return;
        end
        if ( NBandwidth <= 0.83)
            FilterCoef.b = [ 0.40703      2.0351      4.0703      4.0703      2.0351     0.40703];
            FilterCoef.a = [ 1      3.3002      4.4535       3.057      1.0643     0.15002];
            return;
        end
        if ( NBandwidth <= 0.84)
            FilterCoef.b = [ 0.41117      2.0559      4.1117      4.1117      2.0559     0.41117];
            FilterCoef.a = [ 1      3.3181      4.4994      3.1021      1.0844     0.15344];
            return;
        end
        if ( NBandwidth <= 0.85)
            FilterCoef.b = [ 0.41526      2.0763      4.1526      4.1526      2.0763     0.41526];
            FilterCoef.a = [ 1      3.3358      4.5446      3.1468      1.1044     0.15687];
            return;
        end
        if ( NBandwidth <= 0.86)
            FilterCoef.b = [ 0.4193      2.0965       4.193       4.193      2.0965      0.4193];
            FilterCoef.a = [ 1       3.353      4.5891       3.191      1.1243     0.16028];
            return;
        end
        if ( NBandwidth <= 0.87)
            FilterCoef.b = [ 0.42329      2.1165      4.2329      4.2329      2.1165     0.42329];
            FilterCoef.a = [ 1      3.3699      4.6329      3.2348      1.1441     0.16369];
            return;
        end
        if ( NBandwidth <= 0.88)
            FilterCoef.b = [ 0.42723      2.1362      4.2723      4.2723      2.1362     0.42723];
            FilterCoef.a = [ 1      3.3864      4.6761      3.2781      1.1638     0.16709];
            return;
        end
        if ( NBandwidth <= 0.89)
            FilterCoef.b = [ 0.43113      2.1556      4.3113      4.3113      2.1556     0.43113];
            FilterCoef.a = [ 1      3.4027      4.7187      3.3209      1.1833     0.17048];
            return;
        end
        if ( NBandwidth <= 0.9)
            FilterCoef.b = [ 0.43497      2.1749      4.3497      4.3497      2.1749     0.43497];
            FilterCoef.a = [ 1      3.4186      4.7606      3.3633      1.2027     0.17387];
            return;
        end
        if ( NBandwidth <= 0.91)
            FilterCoef.b = [ 0.43877      2.1939      4.3877      4.3877      2.1939     0.43877];
            FilterCoef.a = [ 1      3.4342      4.8019      3.4053       1.222     0.17724];
            return;
        end
        if ( NBandwidth <= 0.92)
            FilterCoef.b = [ 0.44252      2.2126      4.4252      4.4252      2.2126     0.44252];
            FilterCoef.a = [ 1      3.4495      4.8426      3.4468      1.2412     0.18061];
            return;
        end
        if ( NBandwidth <= 0.93)
            FilterCoef.b = [ 0.44623      2.2311      4.4623      4.4623      2.2311     0.44623];
            FilterCoef.a = [ 1      3.4645      4.8827       3.488      1.2602     0.18396];
            return;
        end
        if ( NBandwidth <= 0.94)
            FilterCoef.b = [ 0.44989      2.2495      4.4989      4.4989      2.2495     0.44989];
            FilterCoef.a = [ 1      3.4792      4.9222      3.5286      1.2791     0.18731];
            return;
        end
        if ( NBandwidth <= 0.95)
            FilterCoef.b = [ 0.45351      2.2675      4.5351      4.5351      2.2675     0.45351];
            FilterCoef.a = [ 1      3.4936      4.9612      3.5689      1.2979     0.19064];
            return;
        end
        if ( NBandwidth <= 0.96)
            FilterCoef.b = [ 0.45708      2.2854      4.5708      4.5708      2.2854     0.45708];
            FilterCoef.a = [ 1      3.5078      4.9996      3.6087      1.3166     0.19396];
            return;
        end
        if ( NBandwidth <= 0.97)
            FilterCoef.b = [ 0.46061      2.3031      4.6061      4.6061      2.3031     0.46061];
            FilterCoef.a = [ 1      3.5217      5.0374      3.6481      1.3351     0.19726];
            return;
        end
        if ( NBandwidth <= 0.98)
            FilterCoef.b = [ 0.4641      2.3205       4.641       4.641      2.3205      0.4641];
            FilterCoef.a = [ 1      3.5353      5.0748      3.6871      1.3535     0.20056];
            return;
        end
        if ( NBandwidth <= 0.99)
            FilterCoef.b = [ 0.46755      2.3377      4.6755      4.6755      2.3377     0.46755];
            FilterCoef.a = [ 1      3.5487      5.1115      3.7257      1.3718     0.20384];
            return;
        end
    end
else    
    if ( FilterType == 1 )       
        Fs = 100*1e9;                           % Sampling Frequency
        BW = NBandwidth * Fs * 10;
        [b,a] = besself(5,BW);          % Bessel analog filter design
        [b1,a1] = bilinear(b, a,Fs);
        FilterCoef.b = b1;
        FilterCoef.a = a1;   
    end
    
    if ( FilterType == 0 )
        [FilterCoef.b,FilterCoef.a]= butter(FilterTapNum,  NBandwidth, 'low');
    end
end
    
%     if ( FilterType == 1 )
%         FilterCoef.b,FilterCoef.a]= butter(FilterTapNum,  NBandwidth, 'low');
%     end

%     h1=dfilt.df2(FilterCoef.b,FilterCoef.a);
%     fvtool(h1)

end
