
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'carosoul_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _buildPlayPauseButton();

    // Initialize the video player with an asset video
    _controller = VideoPlayerController.asset('assets/homepage_video.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI once the video is initialized
      });
  }
  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              // Container(
              //   height: 175,
              //   width: MediaQuery.of(context).size.width/1,
              //   child: CarosoulSliderPage(),
              // ),
              SizedBox(height: 17,),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width/1,
                child: Image.asset("assets/s1.jpg",fit: BoxFit.cover,),
              ),
              SizedBox(height: 20,),
              Align(alignment: Alignment.bottomLeft, child: Text("How it Works: A Quick Guide",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),

              Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                  children: [
                    Container(
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/s2.jpg",fit: BoxFit.fill,),
                    ),
                    Text("Lock",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Present your booking confirmation and leave your bags securely with us.",style: TextStyle(fontSize: 12,),),
                    )
                  ],
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 4,
                child: Column(
                  children: [
                    Container(
                      height: 160,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/s3.jpg",fit: BoxFit.cover,),
                    ),
                    Text("Enjoy",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Explore freely, and when ready, retrieve your belongings without any hassle.",style: TextStyle(fontSize: 12,),),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                      _buildPlayPauseButton(),
                    ],
                  ),
                )
                    : CircularProgressIndicator(), // Show loading spinner until video is ready
              ),

              SizedBox(height: 20,),
              Align(alignment: Alignment.centerLeft,  child: Text("Why Choose Us?",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),)),
              Text("\nSecurity Guaranteed: ""Your bags are safe with us!" "We ensure a 100% secure environment for your luggage, featuring comprehensive coverage and advanced surveillance systems. Enjoy peace of mind while you explore!"
              "\n\nOne Size Fits All: Whether it's a suitcase or a backpack, our flat rate covers all. No hidden fees, no size restrictions!"
              "\n\nAll-Day Access: Secure your luggage once and access it anytime throughout the day. Your belongings are safe and accessible whenever you need them."
              "\n\nHassle-Free Booking: Experience our streamlined booking process! Easy steps, quick confirmation, and unbeatable prices all in one platform."
              "\n\n24/7 Customer Support: Our dedicated team is available around the clock to assist you. Got questions? Our chatbot and customer service are ready to help anytime!"),


            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPlayPauseButton() {
    return GestureDetector(
        onTap: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        }
    );
  }
}
