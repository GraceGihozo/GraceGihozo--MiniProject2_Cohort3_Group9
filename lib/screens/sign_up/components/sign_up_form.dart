import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soni_store_app/components/custom_surfix_icon.dart';
import 'package:soni_store_app/resources/auth_methods.dart';
import 'package:soni_store_app/screens/sign_in/sign_in_screen.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../utils/constatns.dart';
import '../../../utils/size_config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool remember = false;
  final List<String> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error!);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AuthMethods()
          .registerUser(
        email: emailController.text,
        password: passwordController.text,
        username: emailController.text.trim(),
      )
          .then((result) {
        if (result == 'success') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
              (route) => false);
          const GetSnackBar(
            message: "Registration is successful 🎉",
            backgroundColor: Color.fromARGB(255, 120, 255, 125),
          );
        }
        GetSnackBar(message: result.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: DefaultButton(
              txtColor: Colors.white,
              text: "Continue",
              press: register,
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(12),
      ),
      onSaved: (newValue) => confirmPasswordController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty &&
            passwordController.text == confirmPasswordController.text) {
          removeError(error: kMatchPassError);
        }
        confirmPasswordController.text = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((passwordController.text != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 16,
        ),
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.pinkAccent,
            width: 1.0,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(12),
      ),
      onSaved: (newValue) => passwordController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        passwordController.text = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        contentPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.pinkAccent,
            width: 1.0,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(12),
      ),
      onSaved: (newValue) => emailController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        contentPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            color: Colors.pinkAccent,
            width: 1.0,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
