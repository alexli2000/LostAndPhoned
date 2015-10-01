# LostAndPhoned
Call the Genesys supplied hotline number and find your iPhone's location

This was the iPhone side of the Genesys Hackathon Project. The goal is to call a phone number, inpuut the same username and password used for the device, and determine the location of it. The location is up to the minute.

We did this by sending a push notification to the device, performing a background location fetch, and sending that back to the Parse server. Meanwhile, we were finitely looping a Genesyis HTTP GET method to search for any new updates in the location. We would then relay the location to the user.

We also wanted to add the ability for the user to add friends and if they want, they can ask them to help locate their phone. This would send a push to the friends' phones and if they open it, bring them to a map screen with directions to the lost phone. At least this would make it different than the already more convenient Find My iPhone already offered by Apple.
