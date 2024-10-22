import 'package:image_picker/image_picker.dart';
import '../../firebase/storage_service.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import '../../firebase/database_service.dart';
import '../../widgets/alerts.dart';
import '../authentication/update_password.dart';
import 'widgets/home_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  UserModel? userModel;
  User? user;
  bool isPasswordLinked = false;

  @override
  /// This method is called when the widget is inserted into the tree.
  ///
  /// Here we check if the user is logged in and if yes, we fetch the user's
  /// providers and details.
  void initState() {
    super.initState();
    user = _authService.user;
    if (user != null) {
      getProviders();
      getUserDetails();
    }
  }

  /// This method checks if the user is logged in using the password provider.
  ///
  /// If the user is not logged in with the password provider, it navigates to the
  /// password update page after 2 seconds.
  ///
  /// If the user is logged in with the password provider, it sets the
  /// `isPasswordLinked` variable to true.
  Future<void> getProviders() async {
    List<String> providers = [];
    for (int i = 0; i < user!.providerData.length; i++) {
      providers.add(user!.providerData[i].providerId.toString());
    }
    if (providers.isEmpty || !providers.contains('password')) {
      Future.delayed(const Duration(seconds: 2), () {
        _navigateToPasswordUpdate(true);
      });
    } else {
      isPasswordLinked = true;
    }
  }

  /// This method fetches the user details from the database using the user's UID.
  ///
  /// If the user details are fetched successfully, it sets the `userModel` to the
  /// fetched user details and calls `setState` to update the widgets.
  ///
  /// If there is an error in fetching the user details, it prints the error
  /// message in the debug console.
  Future<void> getUserDetails() async {
    try {
      userModel = await _databaseService.getCurrentUserDetails(user);
      setState(() {});
    } catch (e) {
      debugPrint("Error:$e");
    }
  }

  /// Navigates to the UpdatePassword page.
  ///
  /// This method pushes a new route to the navigation stack, leading to the
  /// UpdatePassword page. The `isRequired` parameter determines whether the
  /// password update is mandatory, and it is passed to the `UpdatePassword`
  /// widget to configure its behavior accordingly.
  void _navigateToPasswordUpdate(bool isRequired) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdatePassword(
                  isRequiredUpdate: isRequired,
                )));
  }

  /// Allows the user to pick an image from the gallery and upload it to the
  /// Firebase Storage bucket.
  ///
  /// If the image is picked successfully, it uploads the image to the Storage
  /// bucket with the user's UID as the file name, and then updates the user's
  /// profile picture URL in the Firestore database. It then calls [getUserDetails]
  /// to fetch the updated user details and update the UI. If there is an error
  /// during the upload or update process, it shows an alert dialog with the
  /// error message. If the user does not pick an image, it shows a snackbar with
  /// a message indicating that no image was selected.
  Future<void> pickImageAndUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        String uploadedUrl =
            await _storageService.uploadFile(userModel!.uid, image.path);
        await _databaseService.updateProfilePicUrl(userModel!.uid, uploadedUrl);
        getUserDetails();
        alertWidget(
            title: 'Updated Successfully', text: 'Profile Picture Updated');
      } catch (e) {
        alertWidget(title: 'Failed to Updated', text: e.toString());
      }
    } else {
      showSnackBar('No image selected.');
    }
  }

  /// Shows a snackbar with the given [text].
  ///
  /// The snackbar is shown using the [ScaffoldMessenger] of the current
  /// [BuildContext].
  ///
  /// Parameters:
  /// - `text`: The text to show in the snackbar.
  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  /// Builds the home page widget.
  ///
  /// This widget shows the user's profile details in a scrollable column. The
  /// profile details include the user's name, email ID, unique ID and created
  /// on date. If the user is not signed in with the password provider, it shows
  /// a button to link the password provider. If the user is signed in with the
  /// password provider, it shows a button to update the password. It also shows
  /// a button to update the profile picture. Finally, it shows a logout button.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  ///
  /// Returns:
  /// A `SafeArea` widget with a `Container` child that contains the profile
  /// details and the buttons.
  Widget build(BuildContext context) {
    double scHeight = MediaQuery.sizeOf(context).height;
    double scWidth = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: scHeight,
        width: scWidth,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text('Profile Details', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 20),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  userModel?.photoUrl ?? "https://shorturl.at/ylzOc",
                ),
                radius: 50,
              ),
              const SizedBox(height: 20),
              TitleValueRow(title: 'Name', value: userModel?.name ?? "-"),
              TitleValueRow(title: 'Email Id', value: userModel?.email ?? "-"),
              TitleValueRow(title: 'Unique Id', value: userModel?.uid ?? "-"),
              TitleValueRow(
                  title: 'Created On',
                  value: convertDateTime(userModel?.createdAt)),
              const SizedBox(
                height: 20,
              ),
              if (!isPasswordLinked)
                ElevatedButton.icon(
                    onPressed: () {
                      _navigateToPasswordUpdate(true);
                    },
                    icon: const Icon(Icons.password),
                    label: const Text('Link password')),
              if (!isPasswordLinked)
                const SizedBox(
                  height: 20,
                ),
              homeButtons(scWidth,
                  text: 'Update Profile Picture',
                  iconData: Icons.image, onPressed: () {
                pickImageAndUpload();
              }),
              const SizedBox(
                height: 20,
              ),
              if (isPasswordLinked)
                homeButtons(scWidth,
                    text: 'Update Password',
                    iconData: Icons.password, onPressed: () {
                  _navigateToPasswordUpdate(false);
                }),
              if (isPasswordLinked)
                const SizedBox(
                  height: 20,
                ),
              homeButtons(
                scWidth,
                text: 'Logout',
                iconData: Icons.logout,
                onPressed: () {
                  _authService.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
