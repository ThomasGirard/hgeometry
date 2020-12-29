module Algorithms.Geometry.ClosestPair.ClosestPairSpec where

import qualified Algorithms.Geometry.ClosestPair.DivideAndConquer as DivideAndConquer
import qualified Algorithms.Geometry.ClosestPair.Naive            as Naive
import           Control.Lens
import           Data.Ext
import           Data.Geometry.Point
import           Data.LSeq                                        (LSeq)
import qualified Data.LSeq                                        as LSeq
import           Data.Ratio
import           Data.Util
import           Test.Hspec
import           Test.Hspec.QuickCheck
import           Test.QuickCheck
import           Test.QuickCheck.Instances                        ()

spec :: Spec
spec = do
    describe "ClosestPairSpec Algorithms" $ do
      modifyMaxSuccess (const 1000) $
        it "Naive and DivideAnd Conquer report same closest pair distance (quickcheck)" $
          property $ \pts ->
            (squaredEuclideanDist' $ Naive.closestPair pts)
            ==
            (squaredEuclideanDist' $ DivideAndConquer.closestPair pts)
      it "Naive and DivideAnd Conquer report same closest pair distance (manual)" $ do
        let myPts = toLSeq myTest in
          (squaredEuclideanDist' $ Naive.closestPair myPts)
          `shouldBe`
          (squaredEuclideanDist' $ DivideAndConquer.closestPair myPts)
      it "Naive and DivideAnd Conquer report same closest pair distance (manual)" $ do
        let myPts = toLSeq myTest2 in
          (squaredEuclideanDist' $ Naive.closestPair myPts)
          `shouldBe`
          (squaredEuclideanDist' $ DivideAndConquer.closestPair myPts)


squaredEuclideanDist'                         :: Two (Point 2 Rational :+ ()) -> Rational
squaredEuclideanDist' (Two (p :+ _) (q :+ _)) = squaredEuclideanDist p q


-- LSeq {toSeq = fromList [Point2 [(-33759522867779) % 7496802324005,10839434579010 % 8710408063243] :+ (),Point2 [27010230067287 % 7207136323822,(-3164483769031) % 742671498890] :+ (),Point2 [16411948329569 % 7616584565141,12511394381428 % 2834373835667] :+ (),Point2 [(-327606334581) % 728344280722,(-33692910597997) % 8003329261050] :+ (),Point2 [(-15920889254819) % 4416206444274,31639684978225 % 4753346825613] :+ ()]}


toLSeq :: [a] -> LSeq 2 a
toLSeq = LSeq.promise . LSeq.fromList

myTest :: [Point 2 Rational :+ ()]
myTest = map ext
  [Point2 (146640303144371 % 4224053853937) (101854287495663 % 611897639578),Point2 (40638737917185 % 6880564569878) (266207821342347 % 5620065708622),Point2 ((-22768678067038) % 4099605651011) (63425313194697 % 3004649322800),Point2 ((-79043128684637) % 1637661769455) ((-295977300701107) % 9093457570027),Point2 ((-73583019410059) % 7397585905521) ((-132085857579544) % 3023721689783),Point2 (110730624564935 % 3206669900528) ((-134126355694632) % 1030756818019),Point2 (375473877556369 % 5688548958491) ((-61990694642620) % 8334329062977),Point2 (113637651255443 % 7393857491411) (60345369766453 % 1970866530039),Point2 (18099493254552 % 6747283329067) ((-104898261130768) % 6685232742229),Point2 ((-99452695817779) % 9671436420976) ((-15569270478765) % 353842993324),Point2 ((-307985949779841) % 8267832155219) ((-104994723690859) % 937448083071),Point2 (5298565527551 % 9166217911857) (361269627209233 % 6403545389662),Point2 ((-53286482779806) % 163082999159) (32112688900059 % 718598733692),Point2 ((-107690491383153) % 5350356516874) ((-335465470420443) % 9259993302154),Point2 ((-1431112842609) % 2908633300498) ((-6394060822783) % 6674992423),Point2 ((-297096490651238) % 8936478049895) (88152403947309 % 6679373739130),Point2 ((-69377170752544) % 423340544261) (85249651585993 % 1566182413847),Point2 ((-76831240905987) % 7713729889276) ((-161201413608815) % 3632380150759),Point2 (120510849091594 % 469904179619) ((-172736649495640) % 5333925170989),Point2 ((-188872871543069) % 1898068101049) (355493261879401 % 7036186201752),Point2 ((-255393995322931) % 1103177446757) (265927198927640 % 3105872402029),Point2 ((-69257424852911) % 283924670424) (157163114450212 % 6947926872911),Point2 (160793284019169 % 4243291855883) (136543247038343 % 663996934927),Point2 (349183720690751 % 69082861367) (27899563589967 % 984451034746),Point2 ((-6729975907016) % 287613226363) ((-132751704193606) % 884101426259),Point2 (158419738815649 % 1684813345364) ((-232301201438133) % 2251322747338),Point2 (53058623626229 % 834280423049) (11416530634139 % 5498459429949),Point2 (153130827172836 % 3179759716621) ((-247386168772091) % 6720178879120),Point2 ((-255140791023605) % 6181407399187) ((-58852369239783) % 1447725941071),Point2 ((-35688634701875) % 8985183678917) (162916031022373 % 4757510120717)]

myTest2 :: [Point 2 Rational :+ ()]
myTest2 = map ext
  [Point2 ((-2555111138435) % 100027268932) ((-271175971761687) % 5081146259110),Point2 (1781958633602 % 39939572833) ((-116991969549001) % 2614315191157),Point2 ((-130701984198115) % 6612076673726) (331480844750559 % 9766688418920),Point2 ((-121665203959948) % 3628013257911) ((-32220891164149) % 522064529033),Point2 (90142245535798 % 1934046022179) (91849365053150 % 1243347722881),Point2 ((-164185423220053) % 2910780474624) (4623095518922 % 785764886359),Point2 ((-222618485129882) % 3486067615099) (4778498854865 % 75272719696),Point2 ((-239390385571094) % 9447723050679) (40539676867031 % 3029162103796),Point2 (57763131983123 % 1659983326828) ((-355447456291568) % 5352764830669),Point2 (5695063823573 % 128092802513) ((-135759200080849) % 2979399569052),Point2 ((-222836059147799) % 3672137437414) ((-1635175212578) % 40862246625),Point2 ((-224397875494982) % 3986550960831) ((-126518295234538) % 1784682239245),Point2 (829173958114 % 93717176813) ((-12580871143973) % 1273516881927),Point2 (169208186568973 % 2547279095841) ((-145750319295481) % 2495567977261),Point2 (704172725308604 % 9930636018373) (45794032625543 % 6506042317703),Point2 ((-37520399760754) % 827366203837) (9061878861179 % 256188986295),Point2 (54630994338031 % 1680994711444) ((-56701240376115) % 883794504401),Point2 ((-93038540337175) % 1239552052067) ((-60558318640799) % 1754992825326),Point2 (23837285622840 % 1115012729917) ((-217014573589286) % 4875790931567),Point2 ((-57587590377953) % 1906520789998) ((-197163212470384) % 2561874370307),Point2 ((-198677176349691) % 2909372953936) ((-314434806105272) % 5034064601051),Point2 ((-353108056246703) % 4395312285235) ((-202504815402311) % 3178249509972),Point2 (28094411486300 % 2008690619899) ((-299655388972634) % 9958874201489),Point2 (17921002834502 % 2498911716507) ((-4159533583640) % 89330115019),Point2 (441838399451172 % 8218466458427) ((-182083479967061) % 3446413493991),Point2 ((-82148513887873) % 1253139042566) ((-566764794412062) % 7474790784181),Point2 ((-55352883692446) % 5507601826363) (73158331016735 % 1875678329203),Point2 (202455870434189 % 7991429262866) (88981780856864 % 2355054046967),Point2 ((-17764489888611) % 251838643634) (4155503495380 % 316807155847),Point2 (25546825943728 % 6969319292655) (233719092202975 % 3230491422682),Point2 ((-173690844379053) % 2781125193529) ((-149543505644087) % 2645904782908),Point2 ((-141103701067779) % 2293809089443) ((-137592805429760) % 2798482041843),Point2 (666281954417417 % 9063883425401) (340427799264427 % 4509465545850),Point2 (52035542053521 % 818505437003) (18306644561951 % 6103366809032),Point2 (98419900567559 % 2813152371375) ((-42631872603311) % 549416032820),Point2 ((-441123519744251) % 5708372166613) ((-298470204969789) % 9133097213954),Point2 (10265650577342 % 2761782954773) ((-349175225167905) % 9012704570432),Point2 (105074251063945 % 1938661822333) ((-129498233844658) % 1679049774879),Point2 (479109173120836 % 8353334321025) (5100576283797 % 96072829279),Point2 (80914420813769 % 2876601494659) (190543603285423 % 3500073562274),Point2 (60735259486067 % 756332773578) (297448906099073 % 7422960510005),Point2 ((-49186286087800) % 6105278783773) (106394520476116 % 3039545372575),Point2 (525956873725333 % 8056120821427) ((-27081852829578) % 1495428811963),Point2 ((-397201207439) % 9030132149) (7342050471040 % 719209089203),Point2 ((-491416818354107) % 6211701331741) (20761131078437 % 6326122143326),Point2 (7334342668081 % 111164168162) (138937929434119 % 6657987524319),Point2 (257590699859927 % 8244613805752) ((-67381531298844) % 1328265320029),Point2 ((-57605601543123) % 997026497995) ((-244329495764549) % 3942777917965),Point2 (31559311656186 % 3154914131825) ((-79930260419014) % 2303822050259),Point2 ((-194342575100823) % 9761953632497) ((-103016162485590) % 2427913529489),Point2 (38957743915070 % 755414039609) ((-109794604944987) % 1762094717080),Point2 (72589439691987 % 4132342599718) (559131806764632 % 7181327574401),Point2 ((-4890567174978) % 2539008781051) ((-14731920051443) % 2378383332564),Point2 ((-4370130551227) % 1058082657152) (198739701395299 % 2565686121868),Point2 (185340436335157 % 6251869684036) ((-14353018601261) % 1125972081604),Point2 (4171288790339 % 302973152279) ((-132400436309005) % 1630425564689),Point2 (30819176355646 % 8180568631401) (104159092133961 % 3462922904140),Point2 ((-384439222962893) % 6302137479921) (50235019825613 % 2882045848439),Point2 ((-5664910688441) % 1033882309729) ((-119953142312545) % 5037995420947),Point2 (58405408826671 % 1010204299645) (416491493323834 % 7859181827347),Point2 ((-130989339632299) % 2062413981097) ((-518963521471729) % 9490436063290),Point2 (19616115197567 % 290095640873) ((-30296501000705) % 1068650974806),Point2 (497723773632392 % 8797511756605) (484251118551575 % 9452820868018),Point2 (9584252710269 % 1334898536059) ((-122348728320159) % 2377464771871),Point2 ((-88470265603281) % 1426031147519) ((-98309275096185) % 4856157384959),Point2 (612370805770943 % 9516070602379) (65106412550576 % 929282527579),Point2 (287058430501417 % 7713241023363) (225736902251675 % 8575494805533),Point2 ((-515285935597607) % 9072171377079) ((-187253217526531) % 2996530984966),Point2 ((-88741458959502) % 6333468328597) (7711300577701 % 9442184376420),Point2 (71823625388220 % 1256943286753) (211467894699900 % 3952412568913),Point2 (32039116412758 % 1647512151213) (19378244190 % 8870957251),Point2 (643202296379587 % 8096173133361) (94683912149117 % 6841634064532),Point2 ((-66057821275708) % 3110689313251) (440075718948149 % 8985005508977),Point2 ((-74126575442345) % 1408599249079) (129257033953135 % 2816706904751),Point2 (97658037673577 % 5200664088053) (193098835241449 % 6259352960758),Point2 ((-113881797739803) % 9241074428620) (321203048602332 % 6150219596777)]


-- ans2p = Point2 (479109173120836 % 8353334321025) (5100576283797 % 96072829279)
-- ans2q = Point2 (71823625388220 % 1256943286753) (211467894699900 % 3952412568913)

-- small = map ext [ans2p, ans2q
--                 , Point2 (58405408826671 % 1010204299645) (416491493323834 % 7859181827347)
--                 ]

test3 = filter (\p -> p^.core.xCoord > 32) myTest2

-- test4 = filter (\p -> p^.core.xCoord > 52
--                    && p^.core.yCoord > 32
--                ) myTest2

test4 = filter (\p -> p^.core.xCoord > 52
                   && p^.core.yCoord > 44
                   && p^.core.yCoord < 61
               ) myTest2
