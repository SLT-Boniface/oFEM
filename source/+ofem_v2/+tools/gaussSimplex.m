function [w,l] = gaussSimplex(dim,order)
    %GAUSSSIMPLEX returns quadrature weights and points for supplied dim
    %and order
    %
    % TODO: Copy high precision values
    % TODO: Work on dim = 2
    % TODO: Work on dim = 1
    % TODO: up orders
    switch dim
        case 1
            switch order
                case 1
                    w = 2;
                    l = 1/2;
                case 2
                    w = [1,1];
                    l = [(-sqrt(1/3)+1)/2,(sqrt(1/3)+1)/2];
                case 3
                    w = [5/9,8/9,5/9];
                    l = [(-sqrt(3/5)+1)/2,1/2,(sqrt(3/5)+1)/2];
                case 4
                    w = [(18-sqrt(30))/36,(18+sqrt(30))/36,(18+sqrt(30))/36,(18-sqrt(30))/36];
                    a = sqrt(3/7+2/7*sqrt(6/5));
                    b = sqrt(3/7-2/7*sqrt(6/5));
                    l = [(-a+1)/2,(-b+1)/2,(b+1)/2,(a+1)/2];
            end
        case 2
            switch order
                case 1
                    w = 1;
                    l = [1/3;1/3];
                case 2
                    w = dup21(1/3);
                    l = perm21(1/6)';
                case 3
                    w1 = .28114980244097964825351432270207695;
                    w2 = .05218353089235368507981901063125638;
                    a = .16288285039589191090016180418490635;
                    b = .47791988356756370000000000000000000;
                    l = [perm21(a);perm21(b)]';
                    w = [dup21(w1),dup21(w2)];
                case 4
                    w1 = .22338158967801146569500700843312280;
                    w2 = .10995174365532186763832632490021053;
                    a = .44594849091596488631832925388305199;
                    b = .09157621350977074345957146340220151;
                    l = [perm21(a),perm21(b)]';
                    w = [dup21(w1),dup21(w2)];
            end
            w = w(:)/2;
        case 3
            switch order
                case 1
                    w = 1;
                    l = perm4()';
                case 2
                    w=[1;1;1;1]/4;
                    a = (5-sqrt(5))/20;
                    l = perm31(a)';
                case 3
                    w1 = .13852796651186214232361769837564129;
                    w2 = .11147203348813785767638230162435871;
                    a = .32805469671142664733580581998119743;
                    b = .10695227393293068277170204157061650;
                    l = [perm31(a);
                        perm31(b)]';
                    w = [repelem(w1,1,4),repelem(w2,1,4)];
                case 4
                    w1 = -0.01315555556;
                    b = 0.07142857143;
                    w2 = 0.007622222222;
                    c = 0.10059642383;
                    w3 = 0.024888888889;
                    l = [perm4();
                         perm31(b);
                         perm22(c)]';
                     w = [w1,repelem(w2,1,4),repelem(w3,1,6)];
                case 5
                    w1 = 0.0302836781;
                    w2 = 0.00602678571;
                    w3 = 0.01164524909;
                    w4 = 0.01094914156;
                    a = 1/4;
                    b = [0,1/3];
                    c = [8/11,1/11];
                    d = [0.06655015357, 0.43344984643];
                    l = [a,a,a;
                         b([2,2,2]);
                         b([1,2,2]);
                         b([2,1,2]);
                         b([2,2,1]);
                         c([2,2,2]);
                         c([1,2,2]);
                         c([2,1,2]);
                         c([2,2,1]);
                         d([1,1,2]);
                         d([1,2,2]);
                         d([2,2,1]);
                         d([1,2,1]);
                         d([2,1,2]);
                         d([2,1,1])]';
                     w = [w1,repelem(w2,1,4),repelem(w3,1,4),repelem(w4,1,6)];
                % From here on the quadrature is taken from phg
                % lsec.cc.ac.cn/phg
                case 6
                    w1 = .03992275025816749209969062755747998;
                    w2 = .01007721105532064294801323744593686;
                    w3 = .05535718154365472209515327785372602;
                    w4 = 27/560;
                    a = .21460287125915202928883921938628499;
                    b = .04067395853461135311557944895641006;
                    c = .32233789014227551034399447076249213;
                    d = [.06366100187501752529923552760572698,...
                        .60300566479164914136743113906093969];
                    l = [perm31(a);
                         perm31(b);
                         perm31(c);
                         perm211(d)]';
                     w = [repelem(w1,1,4),repelem(w2,1,4),repelem(w3,1,4),repelem(w4,1,12)];
                case 7
                    w1 = .09548528946413084886057843611722638;
                    w2 = .04232958120996702907628617079854674;
                    w3 = .03189692783285757993427482408294246;
                    w4 = .03720713072833462136961556119148112;
                    w5 = .00811077082990334156610343349109654;
                    a = .31570114977820279942342999959331149;
                    b = .05048982259839636876305382298656247;
                    c = [.18883383102600104773643110385458576,...
                         .57517163758700002348324157702230752];
                    d = [.02126547254148324598883610149981994,...
                         .81083024109854856111810537984823239];
                    l = [perm4();
                         perm31(a);
                         perm22(b);
                         perm211(c);
                         perm211(d)]';
                    w = [w1,repelem(w2,1,4),repelem(w3,1,6),repelem(w4,1,12),repelem(w5,1,12)];
                case 8
                    w1 = .00639714777990232132145142033517302;
                    w2 = .04019044802096617248816115847981783;
                    w3 = .02430797550477032117486910877192260;
                    w4 = .05485889241369744046692412399039144;
                    w5 = .03571961223409918246495096899661762;
                    w6 = .00718319069785253940945110521980376;
                    w7 = .01637218194531911754093813975611913;
                    a = .03967542307038990126507132953938949;
                    b = .31448780069809631378416056269714830;
                    c = .10198669306270330000000000000000000;
                    d = .18420369694919151227594641734890918;
                    e = .06343628775453989240514123870189827;
                    f = [.02169016206772800480266248262493018,...
                        .71993192203946593588943495335273478];
                    g = [.20448008063679571424133557487274534,...
                        .58057719012880922417539817139062041];
                    l = [perm31(a);
                        perm31(b);
                        perm31(c);
                        perm31(d);
                        perm22(e);
                        perm211(f);
                        perm211(g)]';
                    w = [dup31(w1),dup31(w2),dup31(w3),dup31(w4),dup22(w5),dup211(w6),dup211(w7)];
                case 9
                    w1 = .05489853459364812686895885032391298;
                    w2 = .00421825735654367356185795185819147;
                    w3 = .02348412311384798927791501022996111;
                    w4 = .00421283454980389148648831814037819;
                    w5 = .02994712640542812769203037546126163;
                    w6 = .03695441750679136335292416138761121;
                    w7 = .00817349224171051348425319650294732;
                    w8 = .00987978656102278957913113314297149;
                    w9 = .02160718741919244401497646690335203;
                    a = .03785502061999503609086515586175707;
                    b = .16954439965012220000000000000000000;
                    c = .05484140424416689000000000000000000;
                    d = .32229717190921058836777748445908171;
                    e = .10961777508972033704050355954365052;
                    f = [.45915766038590539763886410168178216,...
                        .08004485927247373376034330857923567];
                    g = [.03296694775357210169727386483414899,...
                        .71879584022434055051132299796383374];
                    h = [.18174359672117481549870278661377760,...
                        .60023700739524674102301240348069459];
                    l = [perm4;
                        perm31(a);
                        perm31(b);
                        perm31(c);
                        perm31(d);
                        perm22(e);
                        perm211(f);
                        perm211(g);
                        perm211(h)]';
                    w = [w1,dup31(w2),dup31(w3),dup31(w4),dup31(w5),dup22(w6),...
                        dup211(w7),dup211(w8),dup211(w9)];
            end
            w = w(:)/6;
    end
end

function a = perm21(b)
    a = [b(1),b(1),1-2*b(1)];
    a = unique(perms(a),'rows');
    a = a(:,1:2);
end

function a = dup21(b)
    a = repelem(b,1,3);
end

function a = perm111(b)
    a = [b(1),b(2),1-b(1)-b(2)];
    a = unique(perms(a),'rows');
    a = a(:,1:2);
end

function a = dup111(b)
    a = repelem(b,1,6);
end
    
function a = perm211(b)
    a = [b(1),b(1),b(2),1-2*b(1)-b(2)];
    a = unique(perms(a),'rows');
    a = a(:,1:3);
end

function a = perm22(b)
    a = [b,b,.5-b,.5-b];
    a = unique(perms(a),'rows');
    a = a(:,1:3);
end

function a = perm31(b)
    a = [b,b,b,1-3*b];
    a = unique(perms(a),'rows');
    a = a(:,1:3);
end

function a = perm4()
    a = [1/4,1/4,1/4];
end

function a = perm1111(b)
    a = [b(1),b(2),b(3),1-b(1)-b(2)-b(3)];
    a = unique(perms(a),'rows');
    a = a(:,1:3);
end

function a = dup31(b)
    a = repelem(b,1,4);
end

function a = dup22(b)
    a = repelem(b,1,6);
end

function a = dup211(b)
    a = repelem(b,1,12);
end

function a = dup1111(b)
    a = repelem(b,1,24);
end


