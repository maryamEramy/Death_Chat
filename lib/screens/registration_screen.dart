import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool errorOccurred = false, showSpinner = false;

  bool obscureText = true;
  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        // Wrap the Padding with SingleChildScrollView
        child: SingleChildScrollView( // <--- اضافه کردن SingleChildScrollView
          // Optionally add padding here if you want space around the scrollable content
          // padding: EdgeInsets.symmetric(horizontal: 24.0), // می توانید پدینگ را اینجا قرار دهید یا در Padding قبلی نگه دارید

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // برای اینکه محتوا حتی وقتی اسکرول دارد، در مرکز باشد،
              // ارتفاع Column باید حداقل به اندازه ارتفاع صفحه باشد.
              // می توان از MainAxisSize.min استفاده کرد و سپس Column را داخل Center قرار داد.
              // یا با SizedBox ارتفاع را تنظیم کرد.
              // در اینجا، برای فرم‌ها معمولا بهترین کار این است که به جای MainAxisAlignment.center در Column داخلی،
              // از یک فضای خالی در ابتدا یا انتهای Column استفاده کنیم تا فرم در وسط قرار گیرد.
              // اما فعلاً به همین صورت اصلی نگه می داریم و اگر باز هم مشکل بود، راه حل های دیگر را امتحان می کنیم.
              mainAxisAlignment: MainAxisAlignment.center, // این ممکن است با SingleChildScrollView رفتار متفاوتی داشته باشد
              mainAxisSize: MainAxisSize.min, // <--- این را اضافه کنید تا Column فقط به اندازه محتوایش فضا بگیرد

              children: <Widget>[
                // اگر می خواهید لوگو همیشه در بالا ثابت باشد و فقط بقیه اسکرول بخورند،
                // باید یک Column والد دیگر ایجاد کنید و لوگو را بالای SingleChildScrollView قرار دهید.
                // اما اگر کل صفحه باید اسکرول بخورد، این ساختار فعلی درست است.
                // در اینجا، Flexible باعث می شود لوگو سعی کند فضای خودش را کنترل کند.
                // اما در یک SingleChildScrollView، Flexible تاثیر کمتری دارد.
                // بهتر است از یک SizedBox ساده برای کنترل ارتفاع استفاده کنید یا نسبت تصویر را کنترل کنید.
                SizedBox(height: 100), // <--- ارتفاع ثابت برای لوگو
                Image.asset('images/logo.png'), // <--- خود Image.asset
                // اگر می خواهید Hero Transition داشته باشید و لوگو جمع و جور شود، می توانید Hero را اطراف Image.asset بگذارید.
                // Hero(
                //   tag: 'logo',
                //   child: SizedBox(
                //     height: 100, // ارتفاع ثابت برای لوگو
                //     child: Image.asset('images/logo.png'),
                //   ),
                // ),

                DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 45.0,
                    color: Colors.white,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [TypewriterAnimatedText('Register....')],
                  ),
                ),
                SizedBox(height: 48.0), // <--- فاصله مناسب بعد از متن انیمیشنی

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your name',
                          labelText: 'Name',
                        ),
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (name) {
                          return name != null && name.isNotEmpty
                              ? null
                              : 'Please enter your name';
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) {
                          return email != null && EmailValidator.validate(email)
                              ? null
                              : 'Please enter a valid email';
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password',
                          labelText: 'password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              togglePasswordVisibility();
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white, // <--- رنگ آیکون را تنظیم کنید
                            ),
                          ),
                        ),
                        controller: _passwordController,
                        obscureText: obscureText,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) {
                          return password != null && password.length > 5
                              ? null
                              : 'The password should be at of 6 character at least.';
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Visibility(
                  visible: errorOccurred,
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
                SizedBox(height: 24.0),
                RoundedButton(
                  title: 'Register',
                  color: Colors.orangeAccent[200]!,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        setState(() {
                          errorOccurred = false;
                          showSpinner = true;
                        });
                        await AuthService()
                            .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                          senderName: _nameController.text, // <--- از displayName استفاده کنید
                        )
                            .then((Value) {
                          if (mounted) { // <--- اضافه کردن mounted check
                            Navigator.pop(context); // ممکن است در صفحه welcome_screen باشید
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        });
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                          errorOccurred = true;
                          // مطمئن شوید که e.toString() دارای ] است قبل از split
                          errorMessage = e.toString().contains(']') ? e.toString().split('] ')[1] : e.toString();
                        });
                      }
                    }
                    print('*********************************************************${_nameController.text}'); // .text را اضافه کنید
                  },
                ),
                // برای ایجاد فضای اضافی در پایین صفحه هنگام اسکرول، به خصوص وقتی کیبورد باز است
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ?
                MediaQuery.of(context).viewInsets.bottom + 20 :
                20), // فضای اضافی برای جلوگیری از پوشانده شدن دکمه توسط کیبورد
              ],
            ),
          ),
        ),
      ),
    );
  }
}