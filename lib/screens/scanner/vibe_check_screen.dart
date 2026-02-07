import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../core/theme.dart';

class VibeCheckScreen extends StatefulWidget {
  const VibeCheckScreen({super.key});

  @override
  State<VibeCheckScreen> createState() => _VibeCheckScreenState();
}

class _VibeCheckScreenState extends State<VibeCheckScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() => _isListening = true);
    _pulseController.repeat();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.mic, color: Colors.white),
            SizedBox(width: 8),
            Text('Listening...'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 10),
      ),
    );
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _pulseController.stop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    // Simulate successful emotion detection and navigate
    Future.delayed(const Duration(milliseconds: 500), () {
      context.go('/home'); // Navigate to home or playlist screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Vibe Check',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: AppTheme.primaryColor.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Layer 1: Camera Preview Simulation
          _CameraPreviewSimulation(),
          
          // Layer 2: UI Overlay
          Column(
            children: [
              const SizedBox(height: 40),
              
              // Top Instruction Glass Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.glassDecoration.copyWith(
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.face_retouching_natural,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Align your face & speak naturally',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Center: Face alignment area (empty)
              const Expanded(child: SizedBox()),
              
              // Bottom Controls
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Waveform Visualization
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return WaveformWidget(
                          isActive: _isListening,
                          animationValue: _waveController.value,
                        );
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Mic Button
                    GestureDetector(
                      onLongPress: _startListening,
                      onLongPressUp: _stopListening,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.4),
                                  blurRadius: _isListening ? 20 + (_pulseController.value * 10) : 15,
                                  spreadRadius: _isListening ? 5 + (_pulseController.value * 5) : 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.mic_rounded,
                              color: Colors.white,
                              size: _isListening ? 32 + (_pulseController.value * 4) : 32,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      _isListening ? 'Release to analyze' : 'Hold to record vibe',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CameraPreviewSimulation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A0A0A),
            const Color(0xFF1A1A1A),
            AppTheme.primaryColor.withOpacity(0.1),
            const Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Cyberpunk grid overlay
          CustomPaint(
            painter: _CyberGridPainter(),
            size: Size.infinite,
          ),
          
          // Camera preview placeholder
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Camera Preview',
                style: TextStyle(
                  color: AppTheme.primaryColor.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveformWidget extends StatelessWidget {
  final bool isActive;
  final double animationValue;

  const WaveformWidget({
    super.key,
    required this.isActive,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(10, (index) {
          final random = math.Random(index + animationValue.hashCode);
          final baseHeight = isActive 
              ? 15 + (random.nextDouble() * 30)
              : 5 + (random.nextDouble() * 10);
          final animatedHeight = baseHeight + (math.sin(animationValue * 2 * math.pi + index) * 10);
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 4,
            height: animatedHeight.abs(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: isActive
                    ? [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.6),
                        Colors.white.withOpacity(0.8),
                      ]
                    : [
                        Colors.white30,
                        Colors.white10,
                      ],
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.1)
      ..strokeWidth = 0.5;

    const gridSize = 50.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}