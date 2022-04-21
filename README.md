 <p align="center">
      <b>sharest</b>
  </p>

<p align="center">
    <a href="https://teamlimashareit.s3.amazonaws.com/Screen+Shot+2022-04-21+at+2.00.10+PM.png"><img src="https://teamlimashareit.s3.amazonaws.com/Screen+Shot+2022-04-21+at+2.00.10+PM.png" width="25%" alt = "sharest Login Screen in Swift"/></a>
</p>

**This project has been developed with Swift 5, deployment target as IOS 15.0 and built using Xcode 13.1**

## About

sharest- The IOS app is a combined effort of Team Lima studying Mobile development class under Dr. Mayfield at Oklahoma State University. The purpose of the app is to share your items with the students/people living around you. User can upload photos of items from their IOS device and exchange email with other users if they want any item. 

The app is integrated with Firebase for authentication and uses Cocoapods. It also uses AWS S3 bucket to upload Images and Maria DB to store user information.

## Installation and configuration

First, you need to clone this repository, in order to fetch the code

```
$ git clone https://github.com/ngoert/TeamLima.git
```

In order to compile your code, you need to install the dependencies first. We use Cocoapods in our project so you need to install it.  

```
$ sudo gem install cocoapods
```

If you're not familiar with Cocoapods, <a href="https://guides.cocoapods.org/using/getting-started.html">checkout their website</a>, to see how you can install it.

Once cocoapods is installed successfully, go to the project root folder and run below commands

```
$ cd TeamLima
$ cd sharest
$ pod install
```
Once the pods were installed successfully, open <b>sharest.xcworkspace</b> with Xcode and run the project.


Everything should be working fine. Build the project by pressing command+B, to make sure all libraries are updated.


## Documentation

The interface of the app can be found in main.storyboard. The project structure is divided in MVC pattern, so you will find all the class used in the project in MODEL folder,
all the UIViewControllers in Controller folder and main.storyboard in VIEW folder. The app consist of following screen :

```
Login
Register
Forgot Password
HomePage
SideMenu Bar with [Profile, Add Items, QR Code, My Items, Logout]
```
Authentication

```
The Authentication is done using Firebase SDK, Authentication takes two steps:
Registeration - User go to the register page and enter details
Login - Once registered, user is redirected to Login Page, where user login to procees to Home Page.
In the backened whenver a user is registered a UUID is generated which acts a Primary Key for that user, and that user id is associated with user for the entire process.
Once logged in, user can logout by clicking on logout.
```
Homepage and Functionality
```
Homepage displays all the images which are uploaded by different user on the app.
The homepage contains a UIImageview with two buttons ASK & PASS.
PASS - The user can click on the PASS button if they dont like the current item and next item will get populated in the UI
ASK - If user likes the item, they can press the ASK button and send email to owner.
```
Profile & Insight
```
It contains a section where user can upload its user profile.
Also,
It contains a pie chart whihc shows Insights about user activities:
Number of Pass -  Number of times a user has skipped a particular item.
Number of Ask  - Number of times a user has sent email to different users.
```
Add Items
```
Add Items contains a UiImagePickerDelegate which helps user to select images from gallery. Once image is selected, user gives title, description and press
upload button to push images to AWS S3 bucket. This image than automatically get broadcasted in every different user Homepage.
```
QR Code
```
Every user has its own unique Bar code, whihc tells its username and email ID. Once user scans the bar code, It gets landed to a PHP page hosted in the CSX
server which tells details about the user.
```
My Items
```
This section contains all the images uploaded by that particular user.
```
Interaction with Maria DB hosted on CSX server
```
The CSX server is the heart of our user data and insights information. All data except for photos[1] is stored in the server and all information is passed to the server using php. 

[1]Photos are stored in AWS.
```




