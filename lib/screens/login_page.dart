// login_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'magi_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isSignUp = false;
  late AnimationController _controller;

  bool isLoading = false;
  bool isLoggedIn = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();

  bool showEmailError = false;
  bool showPasswordError = false;
  bool showNameError = false;
  bool showConfirmPasswordError = false;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  void toggleSignUpMode() {
    if (isSignUp) {
      _controller.reverse().then((_) {
        setState(() {
          isSignUp = false;
        });
      });
    } else {
      setState(() {
        isSignUp = true;
      });
      _controller.forward();
    }
  }

  void signUpModeComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void validateForm() {
    setState(() {
      showEmailError = emailController.text.isEmpty;
      showPasswordError = passwordController.text.isEmpty;
      if (isSignUp) {
        showNameError = nameController.text.isEmpty;
        showConfirmPasswordError =
            confirmPasswordController.text != passwordController.text;
      }
    });

    if (!showEmailError &&
        !showPasswordError &&
        (!isSignUp || !showNameError)) {
      // Check for hardcoded credentials
      if (emailController.text == 'magiadmin@gmail.com' &&
          passwordController.text == 'password123') {
        setState(() {
          isLoading = true;
        });

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
            isLoggedIn = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MagiHomePage()),
            );
          });
        });
      } else {
        // Show error if credentials are incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect email or password.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 600.0;
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    if (isLoading) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).colorScheme.primary
          : null, // Use primary color in light mode
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AnimationLimiter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 375),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onPrimary,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset(
                              'assets/magi_logo.png',
                              width: 175.0,
                              height: 175.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'MAGI Ministries',
                          style: GoogleFonts.montserrat(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Empowering Families, One Step at a Time',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 40.0),

                        // AnimatedSize for Name field and validation error
                        AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: isSignUp
                              ? Column(
                                  children: [
                                    _buildTextField(
                                      controller: nameController,
                                      hintText: 'Name',
                                      icon: Icons.person,
                                      obscureText: false,
                                      errorVisible: showNameError,
                                      errorMessage: 'Name is required.',
                                      focusNode: nameFocusNode,
                                      onSubmitted: (_) => validateForm(),
                                      onChanged: (value) {
                                        setState(() {
                                          showNameError = value.isEmpty;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),

                        _buildTextField(
                          controller: emailController,
                          hintText: 'Email',
                          icon: Icons.email,
                          obscureText: false,
                          errorVisible: showEmailError,
                          errorMessage: 'Email is required.',
                          focusNode: emailFocusNode,
                          onSubmitted: (_) => validateForm(),
                          onChanged: (value) {
                            setState(() {
                              showEmailError = value.isEmpty;
                            });
                          },
                        ),

                        _buildTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          icon: Icons.lock,
                          obscureText: !isPasswordVisible,
                          trailingIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: isLightMode
                                  ? Colors.grey
                                  : Theme.of(context)
                                      .iconTheme
                                      .color, // Set grey in light mode
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                          errorVisible: showPasswordError,
                          errorMessage: 'Password is required.',
                          focusNode: passwordFocusNode,
                          onSubmitted: (_) => validateForm(),
                          onChanged: (value) {
                            setState(() {
                              showPasswordError = value.isEmpty;
                            });
                          },
                        ),

                        // Confirm Password field with visibility toggle (for sign up)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: isSignUp
                              ? _buildTextField(
                                  controller: confirmPasswordController,
                                  hintText: 'Confirm Password',
                                  icon: Icons.lock_outline,
                                  obscureText: !isConfirmPasswordVisible,
                                  trailingIcon: IconButton(
                                    icon: Icon(
                                      isConfirmPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: isLightMode
                                          ? Colors.grey
                                          : Theme.of(context)
                                              .iconTheme
                                              .color, // Set grey in light mode
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isConfirmPasswordVisible =
                                            !isConfirmPasswordVisible;
                                      });
                                    },
                                  ),
                                  errorVisible: showConfirmPasswordError,
                                  errorMessage: 'Passwords do not match.',
                                  focusNode: confirmPasswordFocusNode,
                                  onSubmitted: (_) => validateForm(),
                                  onChanged: (value) {
                                    setState(() {
                                      showConfirmPasswordError =
                                          value != passwordController.text;
                                    });
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: validateForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLightMode
                                  ? Colors.grey[800]
                                  : null, // Set to grey[800] in light mode, default in dark
                              foregroundColor: Colors.white, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              isSignUp ? 'Sign Up' : 'Sign In',
                              style: GoogleFonts.montserrat(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Add "Forgot Password?" link here, above the "Sign Up" text
                        const SizedBox(height: 16.0),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // Handle forgot password functionality here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Forgot Password functionality coming soon!'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.roboto(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => signUpModeComingSoon(context),
                            child: Text(
                              isSignUp
                                  ? 'Already have an account? Sign In'
                                  : "Don't have an account? Sign Up",
                              style: GoogleFonts.roboto(
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        // Divider with "Or login with" text
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "Or login with",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        // Social login options with Google, Facebook, and phone
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            _buildSocialAvatar(
                                FontAwesomeIcons.google, "Google"),
                            const Spacer(),
                            _buildSocialAvatar(
                                FontAwesomeIcons.facebookF, "Facebook"),
                            const Spacer(),
                            _buildSocialAvatar(FontAwesomeIcons.phone, "Phone"),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
    Widget? trailingIcon,
    required bool errorVisible,
    required String errorMessage,
    required Function(String) onChanged,
    required FocusNode focusNode,
    required Function(String) onSubmitted,
  }) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none, // Remove border if needed
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide:
                    BorderSide.none, // Customize if you want a different style
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              hintText: hintText,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              prefixIcon: Icon(
                icon,
                color: isLightMode
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color,
              ),
              suffixIcon: trailingIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: isLightMode
                            ? Colors.grey
                            : Theme.of(context).iconTheme.color,
                      ),
                      child: trailingIcon,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: errorVisible
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSocialAvatar(IconData icon, String platform) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$platform sign-in is coming soon!'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                isHovered = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovered = false;
              });
            },
            child: CircleAvatar(
              radius: 26.0,
              backgroundColor: isHovered
                  ? Theme.of(context).highlightColor
                  : Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 26.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).colorScheme.primary
          : null,
      body: Column(
        children: [
          const SizedBox(height: 200.0),
          Text(
            "Signing In...",
            style: GoogleFonts.montserrat(
              fontSize: 36.0,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 100.0),
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Theme.of(context).colorScheme.onPrimary,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }
}

// login simulation below

// import 'dart:async'; // Import this for Timer
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'magi_home_page.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   LoginPageState createState() => LoginPageState();
// }
//
// class LoginPageState extends State<LoginPage>
//     with SingleTickerProviderStateMixin {
//   bool isSignUp = false;
//   late AnimationController _controller;
//
//   bool isLoading = false;
//   bool isLoggedIn = false;
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//   TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//
//   final FocusNode emailFocusNode = FocusNode();
//   final FocusNode passwordFocusNode = FocusNode();
//   final FocusNode confirmPasswordFocusNode = FocusNode();
//   final FocusNode nameFocusNode = FocusNode();
//
//   bool showEmailError = false;
//   bool showPasswordError = false;
//   bool showNameError = false;
//   bool showConfirmPasswordError = false;
//
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     // Trigger the simulated login animation after a small delay
//     Future.delayed(const Duration(seconds: 1), () {
//       simulateLogin();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     nameController.dispose();
//     emailFocusNode.dispose();
//     passwordFocusNode.dispose();
//     confirmPasswordFocusNode.dispose();
//     nameFocusNode.dispose();
//     super.dispose();
//   }
//
//   // Function to simulate typing email and password and pressing the Sign In button
//   void simulateLogin() {
//     // Simulate typing the email
//     String email = 'magiadmin@gmail.com';
//     String password = 'password123';
//     int emailIndex = 0;
//     int passwordIndex = 0;
//
//     // Typewriter effect for email
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (emailIndex < email.length) {
//         setState(() {
//           emailController.text = emailController.text + email[emailIndex];
//           emailIndex++;
//         });
//       } else {
//         timer.cancel(); // Stop the email timer
//         showEmailError = false; // Reset email error state
//
//         // Start typing the password after email is done
//         Timer.periodic(const Duration(milliseconds: 100), (passwordTimer) {
//           if (passwordIndex < password.length) {
//             setState(() {
//               passwordController.text = passwordController.text + password[passwordIndex];
//               passwordIndex++;
//             });
//           } else {
//             passwordTimer.cancel(); // Stop the password timer
//             showPasswordError = false; // Reset password error state
//
//             // Simulate button press after both fields are typed
//             Timer(const Duration(seconds: 1), () {
//               validateForm();
//             });
//           }
//         });
//       }
//     });
//   }
//
//
//   void toggleSignUpMode() {
//     if (isSignUp) {
//       _controller.reverse().then((_) {
//         setState(() {
//           isSignUp = false;
//         });
//       });
//     } else {
//       setState(() {
//         isSignUp = true;
//       });
//       _controller.forward();
//     }
//   }
//
//   void signUpModeComingSoon(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Sign up functionality coming soon!'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   void validateForm() {
//     setState(() {
//       showEmailError = emailController.text.isEmpty;
//       showPasswordError = passwordController.text.isEmpty;
//       if (isSignUp) {
//         showNameError = nameController.text.isEmpty;
//         showConfirmPasswordError =
//             confirmPasswordController.text != passwordController.text;
//       }
//     });
//
//     if (!showEmailError &&
//         !showPasswordError &&
//         (!isSignUp || !showNameError)) {
//       // Check for hardcoded credentials
//       if (emailController.text == 'magiadmin@gmail.com' &&
//           passwordController.text == 'password123') {
//         setState(() {
//           isLoading = true;
//         });
//
//         Future.delayed(const Duration(seconds: 3), () {
//           setState(() {
//             isLoading = false;
//             isLoggedIn = true;
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => const MagiHomePage()),
//             );
//           });
//         });
//       } else {
//         // Show error if credentials are incorrect
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Incorrect email or password.'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double maxWidth = 600.0;
//     final bool isLightMode = Theme.of(context).brightness == Brightness.light;
//
//     if (isLoading) {
//       return _buildLoadingScreen();
//     }
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//           ? Theme.of(context).colorScheme.primary
//           : null, // Use primary color in light mode
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: maxWidth),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: AnimationLimiter(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: AnimationConfiguration.toStaggeredList(
//                       duration: const Duration(milliseconds: 375),
//                       childAnimationBuilder: (widget) => SlideAnimation(
//                         verticalOffset: 50.0,
//                         child: FadeInAnimation(child: widget),
//                       ),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: ColorFiltered(
//                             colorFilter: ColorFilter.mode(
//                               Theme.of(context).colorScheme.onPrimary,
//                               BlendMode.srcIn,
//                             ),
//                             child: Image.asset(
//                               'assets/magi_logo.png',
//                               width: 175.0,
//                               height: 175.0,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           'MAGI Ministries',
//                           style: GoogleFonts.montserrat(
//                             fontSize: 32.0,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.5,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         Text(
//                           'Empowering Families, One Step at a Time',
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.roboto(
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.w400,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 40.0),
//
//                         // Email field
//                         _buildTextField(
//                           controller: emailController,
//                           hintText: 'Email',
//                           icon: Icons.email,
//                           obscureText: false,
//                           errorVisible: showEmailError,
//                           errorMessage: 'Email is required.',
//                           focusNode: emailFocusNode,
//                           onSubmitted: (_) => validateForm(),
//                           onChanged: (value) {
//                             setState(() {
//                               showEmailError = value.isEmpty;
//                             });
//                           },
//                         ),
//
//                         // Password field
//                         _buildTextField(
//                           controller: passwordController,
//                           hintText: 'Password',
//                           icon: Icons.lock,
//                           obscureText: !isPasswordVisible,
//                           trailingIcon: IconButton(
//                             icon: Icon(
//                               isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: isLightMode
//                                   ? Colors.grey
//                                   : Theme.of(context).iconTheme.color,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 isPasswordVisible = !isPasswordVisible;
//                               });
//                             },
//                           ),
//                           errorVisible: showPasswordError,
//                           errorMessage: 'Password is required.',
//                           focusNode: passwordFocusNode,
//                           onSubmitted: (_) => validateForm(),
//                           onChanged: (value) {
//                             setState(() {
//                               showPasswordError = value.isEmpty;
//                             });
//                           },
//                         ),
//
//                         const SizedBox(height: 16.0),
//                         SizedBox(
//                           width: 300,
//                           height: 50,
//                           child: ElevatedButton(
//                             onPressed: validateForm,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: isLightMode
//                                   ? Colors.grey[800]
//                                   : null,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40.0),
//                               ),
//                               elevation: 5,
//                             ),
//                             child: Text(
//                               'Sign In',
//                               style: GoogleFonts.montserrat(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     required bool obscureText,
//     Widget? trailingIcon,
//     required bool errorVisible,
//     required String errorMessage,
//     required Function(String) onChanged,
//     required FocusNode focusNode,
//     required Function(String) onSubmitted,
//   }) {
//     final bool isLightMode = Theme.of(context).brightness == Brightness.light;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: const EdgeInsets.only(bottom: 8),
//           child: TextField(
//             controller: controller,
//             obscureText: obscureText,
//             focusNode: focusNode,
//             onChanged: onChanged,
//             onSubmitted: onSubmitted,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40.0),
//                 borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primary,
//                   width: 2.0,
//                 ),
//               ),
//               filled: true,
//               fillColor: Theme.of(context).inputDecorationTheme.fillColor,
//               hintText: hintText,
//               hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
//               prefixIcon: Icon(
//                 icon,
//                 color: isLightMode
//                     ? Colors.grey
//                     : Theme.of(context).iconTheme.color,
//               ),
//               suffixIcon: trailingIcon != null
//                   ? IconTheme(
//                 data: IconThemeData(
//                   color: isLightMode
//                       ? Colors.grey
//                       : Theme.of(context).iconTheme.color,
//                 ),
//                 child: trailingIcon,
//               )
//                   : null,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 16.0,
//               ),
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: errorVisible
//               ? Padding(
//             padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
//             child: Text(
//               errorMessage,
//               style: TextStyle(
//                 color: Colors.redAccent,
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingScreen() {
//     return Scaffold(
//       backgroundColor: Theme.of(context).brightness == Brightness.light
//           ? Theme.of(context).colorScheme.primary
//           : null,
//       body: Column(
//         children: [
//           const SizedBox(height: 200.0),
//           Text(
//             "Signing In...",
//             style: GoogleFonts.montserrat(
//               fontSize: 36.0,
//               fontWeight: FontWeight.w700,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//           ),
//           const SizedBox(height: 100.0),
//           Center(
//             child: LoadingAnimationWidget.staggeredDotsWave(
//               color: Theme.of(context).colorScheme.onPrimary,
//               size: 100,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
