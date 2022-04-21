 <p align="center">
      <b>sharest</b>
  </p>

<p align="center">
    <a href="https://teamlimashareit.s3.amazonaws.com/Screen+Shot+2022-04-21+at+2.00.10+PM.png"><img src="https://teamlimashareit.s3.amazonaws.com/Screen+Shot+2022-04-21+at+2.00.10+PM.png" width="25%" alt = "sharest Login Screen in Swift"/></a>
</p>

**This project has been developed with Swift 5, deployment target as IOS 15.0 and built using Xcode 13.1**

## About

Purpose: Give away items you no longer need to those in your community. Users can upload photos and descriptions of items they want to give away and other user can take them.

Authors: Team Lima
- Faisal Jaffri
- Cole Hutson @cohutso
- Micah Trent
- Nicholas Goertemiller @ngoert
- Prajwal Rereddy 
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

The apps file system is broken up into the MVC pattern and all files relating to a letter of the pattern in their respective folder:
- Model
  - Cotains classes that define the data model. The information that is stored in these classes is identical to the data being stored on the CSX server,    with the exception of insights whose data is sourced from other classes.
- View
  - Contains any storyboard files that are being used. The only file here we have directly edited is main.storyboard.
- Controller
  - Contains every single view controller. We have tried to keep filenames here relating as closely as possible to the function of their respective views.

We have employed a great many views in the creation of this project what follows is a list of those views:

- Login
- Register
- Forgot Password
- HomePage
  - Side Bar Navigation Menu 
- Profile 
- Add Items 
- QR Code 
- My Items

In the following sections we will explain the various features of the app and how we employed them in bringing the app to life.

### Login Page

When a user is logging into the app they are asked to enter their email address and their password. This information is verified (authenticated) using the Firebase SDK by Google. Firebase is very nice for verifying information, but we wanted to related users to other pieces of data in the CSX server.
We accomplished this by having Firebase generate a user id (uuid) and sending that along with the users other information to the CSX server. **Firebase is only used for authentication** 

### Registration Page

Should a user not have an account they can easily sign up for one from the registration page. The information they provide will be used to set up their account for authentication and for posting and asking for items. The only information the user is asked to provide is their email, their full name and a password (which we don't store). This information is stored on the CSX server and is mostly used on the Profile Page

### Forgot Password?

If a user has forgotten their password they can easily recover their account by clicking on "forgot password" On the homepage

### Home Page

The Home Page is where the bulk of the functionality happens. Here users can ask for or pass on items posted by other users. If a user pass or asks for an item, this interaction is captured and stored for later use as an insight. 

We desgined the homepage to mimick the popular dating app Tinder. The user has only two options for every item, they can either pass or ask for the item. They must do this to see other items. The interactions are manifested in the form of buttons for the user to press. If a user asks for the item they are prompted by the app to send an email to the user who posted the item.

### Profile Page

On the profile page the user can view information about themselves in the form of insights. They can upload a photo (which is unfortunately not used anywhere else in the app), see their name, and also insights.

NOTE: The insights came at a late stage in the apps development and as such there is only one, which tells the user how many people have skipped on their items, and how many have asked for their items.

### Add Items

The add items page allows users to add items to give away. On this page they are prompted to upload a photo for the item as well as give it a name and a description. These fields are not optional and are enforced by the app. All of this information is stored on the CSX server, except for the photo which is stored in AWS S3 buckets.

### QR Code

Every user has their own unique QR code, which indentifies their username and email address. When another user scans the bar code it signals
a php file on the CSX server that contains the details about the scanned user.

### My Items

In this page the user can view all of the items they have posted. Clicking on an item on this page will display more detailed information about them.






