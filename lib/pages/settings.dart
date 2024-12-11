import 'package:flutter/material.dart';
import 'package:flutter_stripe_tutorial/partner_profile/partner_login.dart';
import 'package:url_launcher/url_launcher.dart';

import '../charging_booking/charging_booking_req.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",style: TextStyle(color: Color(0xFF07514A),fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xFFAAEDDF),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Card(
              elevation: 4,
              shadowColor: Color(0xFF6DEDE2),
              child: ExpansionTile(
                title: Text("Service"),
                subtitle: Text("Get our best services"),
                leading: Icon(Icons.home_repair_service,color: Color(0xFF07514A),),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1,
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Secure Luggage Storage: Safe and monitored storage locations with surveillance systems to keep customers' belongings secure."),
                          Text("Key Storage for Airbnb Hosts and Guests: We now offer key storage services, allowing Airbnb hosts to securely store their keys and guests to pick them up with ease at our partner locations"),
                          Text("Online Booking Platform: A user-friendly website and mobile platform that allows customers to book luggage storage in advance with just a few clicks."),
                          Text("QR Code Booking at Partner Locations: Customers can scan a QR code at any partner store to quickly and easily book storage services."),
                          Text("Flexible Storage Options: Storage solutions for all types of luggage, regardless of size or shape, from small backpacks to large suitcases."),
                          Text("All-Day Access: Customers can access their luggage any time during business hours, allowing for flexibility in retrieval."),
                          Text("Real-Time Notifications: Instant confirmation of bookings, reminders about pick-up times, and updates about any changes via SMS or email."),
                          Text("Unbeatable Pricing: Transparent, flat-rate pricing with no hidden fees, ensuring a cost-effective solution for all travellers."),
                          Text("24/7 Customer Support:: A dedicated chatbot and support team available around the clock to handle customer inquiries and resolve issues."),
                          Text("Multiple Storage Locations: A growing network of partner stores and locations across Australia to make storage convenient and accessible wherever customers are."),
                          Text("Insurance Coverage: Optional insurance for additional peace of mind, ensuring that high-value items are protected during storage."),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 4,
              shadowColor: Color(0xFF6DEDE2),
              child: ExpansionTile(
                title: Text("Support"),
                subtitle: Text("Get our 24/7 customer support"),
                leading: Icon(Icons.contact_support,color: Color(0xFF07514A),),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1,
                    color: Colors.white70,
                    child: Column(
                      children: [
                        TextButton(onPressed: () {
                          setState(() {
                            launchUrl(Uri.parse('mailto:admin@urloker.com'));
                          });
                        }, child:  Text("Contact Us: admin@urloker.com"),),

                        Text("We aim to respond to all inquiries within 24 hours."),
                      ],
                    ),

                  )
                ],
              ),
            ),

            Card(
              elevation: 4,
              shadowColor: Color(0xFF6DEDE2),
              child: ExpansionTile(
                title: Text("FAQ"),
                subtitle: Text("we are here to answer you"),
                leading: Icon(Icons.question_mark,color: Color(0xFF07514A),),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1,
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("How does the Urloker luggage storage system work?\n\n"
                              "UrLoker provides collection and delivery services. Click on a location or book a van in the same way that you would book a doctor's appointment through the website. Book a flight by telephone, specifying the location, date and time. As for the dropping out, you will have to put your bag in a locker and as for pick up, the staff will take it and keep it safely."),
                          Text("What things can I store?\n"
                              "\n-Luggage: franchises of suitcases, big bags duffle"
                              "\n-Personal items: Women's purses, Computer Case"
                              "\n-Bulky Items: Sporting equipment, Child params"),
                          Text("Are there size limits?\n\n"
                              "We welcome items of all sizes! However, for extra-large or bulky items like surfboards, skis, or bicycles, we kindly ask for prior approval to ensure our partners can accommodate your needs. Don’t worry—we’ll handle the coordination and keep you informed."),
                          Text("Do larger bags cost more?\n\n"
                            "No. We won't charge you more for your bigger luggeages. So, enjoy the same rates, exclusively with Urloker."),
                          Text("Is hourly luggage storage available at Urloker?\n\n"
                              "We offer a flat 24-hour rate, ensuring you get the same great price whether you store your items for just a few hours or the entire day."),
                          Text("Can I book luggage storage for the whole day with a single booking?\n\n"
                              "Yes, you can easily book luggage storage for the entire day with just one booking, ensuring a hassle-free experience."),
                          Text("Looking for luggage lockers nearby?\n\n"
                              "We partner with trusted businesses that provide secure storage areas for your belongings, offering the same safety and convenience as traditional lockers—without the hassle of availability or size constraints."),
                          Text("Need to change or cancel your booking?\n\n"
                            "We understand that plans can change! Easily modify or cancel your booking right from the details page in our app. Adjust dates, drop-off and pick-up times, or the number of bags with just a few taps."),
                          Text("what kind of service Urloker Luggage Storage provide?\n\n"
                            "Urloker Luggage Storage provides secure and monitored luggage storage solutions with flexible options for all bag sizes. They also offer key storage services for Airbnb hosts and guests, with easy online and QR code booking at partner locations. Additionally, Urloker provides 24/7 customer support, real-time notifications, and optional insurance for added peace of mind.")
                        ],
                      ),
                    ),

                  )
                ],
              ),
            ),

            Card(
              elevation: 4,
              shadowColor: Color(0xFF6DEDE2),
              child: ExpansionTile(
                title: Text("Privacy Policy"),
                subtitle: Text("Read privacy policy"),
                leading: Icon(Icons.privacy_tip,color: Color(0xFF07514A),),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1,
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Privacy Policy for Urloker\n\n"
                          "Privacy Notice and Consent\nThis privacy notice explains how your information is collected and used by Urloker.com. At Urloker.com, we take your privacy seriously and request that you read this policy carefully, as it outlines important information on:The personal data we collect from you,How we use your data, and"
                          "Who we may share your data with.Who We Are Urloker.com (we or us acts as a data controller under the General Data Protection Regulation (GDPR) 2018. This means we are responsible for, and control the processing of, your personal data. The person responsible for managing your personal information at Urloker.com is reachable at support@urloker.com. What Information Do We Collect? Personal Information Provided by You We collect the following personal information when you create an account or make a booking on our website or through our apps: Your name Country of origin Email address Phone numbers Additionally, we may collect personal data when you contact us, provide feedback, complete customer surveys, or participate in any competitions. Our website also uses cookies (see the Use of Cookies section below) and collects IP addresses, which uniquely identify your device on the internet.We collect this information to provide you with the best possible service. Your contact details are required to send transaction confirmations and to inform you of any important updates. Your name and address help our service points verify your identity when you drop off or collect your belongings."
                                   "Personal data" "is" "defined in Article 4(1) of the GDPR as any information relating to an identified or identifiable natural person. Personal Information About Others"
                                  "If you provide us with information on behalf of someone else, you confirm that the individual has authorized you to"

                                 " Consent to the processing of their personal data on their behalf,Receive any data protection notices on their behalf, and Consent tothe transfer of their personal data abroad if necessary. Sensitive Personal Information"
                                  "We generally do not request sensitive personal information from you. If we ever need such information, it will be requested for a specific reason, such as to assist with an account issue due to illness. We will explain why we need this information and how it will be used. We will only collect sensitive personal information with your explicit consent.Children We do not knowingly collect personal data from children under the age of 16. If you believe that we may have collected information about a child under 16, please contact us at support@urloker.com. We will ask for proof of your relationship to the child before considering any requests to access or delete their data.Payment InformationWe do not collect or store your payment information. This is handled by our third-party payment processor, Stripe. Stripe only retains the data necessary to fulfill legal obligations, with any additional data stored securely with your consent. Please review Stripe's privacy policy for further details.How Do We Collect Information?We collect information directly from you via our website and mobile applications. We may also monitor and record communications with you, such as emails, for quality assurance, training, fraud prevention, or legal compliance.Use of CookiesCookies are small text files placed on your device when you use our website. We use cookies to analyze visitor behavior and improve your user experience. These cookies do not identify you personally. You can set your browser to reject cookies, but some website features may not function as a result. For more details, refer to our Cookie Policy How Will We Use Your Information?"
                                  "We collect information for several reasons, including:To enter into and fulfill contracts with you, To manage your account,"
                                  "To contact you regarding your service or any necessary changes,To comply with legal obligations,"
                                  "To improve our services and website content."
                                  "If we intend to use your information for any other purpose, we will notify you and seek your consent if required."

                                  "Marketing We may contact you with information about our products, services, or special offers that might interest you. You can opt out of marketing communications at any time by following the instructions in the ""Your Rights" "section belowWho Might We Share Your Information With?"
                                  "We may share your personal data with:Service provides under contract with us,Our payment processor, Stripe,Law enforcement or government agencies when required by law,Business partners for marketing purposes.Keeping Your Data SecureWe take the security of your data seriously, using both technical and organizational measures to protect it. However, please be aware that the internet is not entirely secure, and we cannot guarantee the security of data transmitted online.Your RightsYou have several rights regarding your personal data, including the right to access, correct, or delete your information. You may also ask us to stop contacting you for marketing purposes. For more details on how to exercise these rights, please contact us atsupport@urloker.com.How to Contact UsIf you have any questions about this privacy policy or the information we hold about you, please contact us atsupport@urloker.com.Changes to This PolicyWe may update this privacy policy from time to time. Please review this policy periodically to stay informed of any changes.",

                                        ),
                    ),
                  )
                ],
              ),
            ),


            //======Charge Booking=================//
            Card(
              elevation: 4,
              shadowColor: Color(0xFF6DEDE2),
              child: ListTile(
                onTap: () {
                  setState(() {
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Delete Successfully...")));
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ChargingPoint(),));
                  });
                },
                title: Text("Charge Booking"),
               // subtitle: Text("charge booking"),
                leading: Icon(Icons.charging_station,color: Color(0xFF07514A),),
              ),
            ),

            //======account deletion=================//
            Card(
              elevation: 4,
              shadowColor: Color(0xFF6DEDE2),
              child: ListTile(
                onTap: () {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account Delete Successfully...")));
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => PartnerLoginPage(),));
                  });
                },
                title: Text("Delete Account"),
                subtitle: Text("user account deletion"),
                leading: Icon(Icons.delete_forever,color: Color(0xFF520712),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
