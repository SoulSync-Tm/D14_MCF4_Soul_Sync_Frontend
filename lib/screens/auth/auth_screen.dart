import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      ref.read(authProvider.notifier).clearError();
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    
    bool success;
    
    if (_isLoginMode) {
      success = await ref.read(authProvider.notifier).login(email, password);
    } else {
      success = await ref.read(authProvider.notifier).register(name, email, password);
    }
    
    if (success) {
      if (_isLoginMode) {
        // Login successful, navigate to home
        if (mounted) {
          context.go('/home');
        }
      } else {
        // Registration successful, switch to login
        setState(() {
          _isLoginMode = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please log in.'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        }
      }
    } else {
      // Error is handled by the provider and will show in UI
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Show error snackbar if there's an error
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(authProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.backgroundColor,
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Title
                    Text(
                      'SoulSync',
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connect your emotions to music',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Auth Form Container
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: AppTheme.glassDecoration.copyWith(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Mode Toggle
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _isLoginMode ? null : _toggleMode(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: _isLoginMode 
                                          ? AppTheme.primaryColor 
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      'Login',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => !_isLoginMode ? null : _toggleMode(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: !_isLoginMode 
                                          ? AppTheme.primaryColor 
                                          : Colors.transparent,
                                    ),
                                    child: Text(
                                      'Register',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Name Field (Register only)
                          if (!_isLoginMode)
                            Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.white30),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.white30),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.primaryColor),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.white30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.primaryColor),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (!_isLoginMode && value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authState.isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      _isLoginMode ? 'Login' : 'Register',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}