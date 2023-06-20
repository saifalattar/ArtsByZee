import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/login.dart';
import 'package:artsbyzee/modules/screens/productsScreen.dart';
import 'package:artsbyzee/modules/screens/searchScreen.dart';
import 'package:artsbyzee/modules/screens/tutorialsScreen.dart';
import 'package:artsbyzee/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZEECubit, ZEEStates>(builder: (context, state) {
      var cubit = ZEECubit.Get(context);
      BannerAd myBanner = BannerAd(
        adUnitId: "ca-app-pub-4148562032274702/3787875265",
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print("Ad is ok!!!");
          },
          onAdFailedToLoad: (ad, error) {
            print("Failureeeeee");
          },
        ),
      );
      myBanner.load();
      return Scaffold(
          backgroundColor: babyBlue,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "images/ZeeIcon.png",
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(pink),
                          ),
                          onPressed: () {
                            goTo(context, const ProductsScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text("\nProducts")
                              ],
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(pink),
                          ),
                          onPressed: () {
                            goTo(context, const SearchScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text("\nSearch")
                              ],
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(pink),
                          ),
                          onPressed: () {
                            goTo(context, const TutorialsPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.ondemand_video_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text("\nTutorials")
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                        ),
                        onPressed: () {
                          cubit.signOut().then((value) {
                            InterstitialAd? ad;

                            InterstitialAd.load(
                                adUnitId:
                                    "ca-app-pub-4148562032274702/7310055987",
                                adLoadCallback: InterstitialAdLoadCallback(
                                    onAdLoaded: (ad) {},
                                    onAdFailedToLoad: (err) {}),
                                request: const AdRequest());
                            goTo(context, const LogIn());
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              Text("\nLog Out")
                            ],
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                width: double.maxFinite,
                height: 50,
                child: AdWidget(ad: myBanner),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Developed by : ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                    Image.asset(
                      "images/iyp grey.png",
                      width: 40,
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
}
