import 'package:artsbyzee/bloc/cubit.dart';
import 'package:artsbyzee/bloc/states.dart';
import 'package:artsbyzee/modules/auth/login.dart';
import 'package:artsbyzee/modules/screens/productsScreen.dart';
import 'package:artsbyzee/modules/screens/searchScreen.dart';
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
          body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        goTo(context, const SearchScreen());
                      },
                      icon: Icon(
                        Icons.search,
                        color: pink,
                        size: 30,
                      )),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "images/ZeeIcon.png",
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: pink,
                              borderRadius: BorderRadius.circular(25)),
                          height: 110,
                          child: GestureDetector(
                            onTap: () {
                              goTo(context, const ProductsScreen());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("See All Products\n",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        color: Colors.white)),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(25)),
                          height: 80,
                          child: GestureDetector(
                            onTap: () {
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Log Out",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white)),
                                Icon(
                                  Icons.navigate_before,
                                  color: Colors.white,
                                  size: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: AdWidget(ad: myBanner),
                  ),
                ],
              )));
    });
  }
}
