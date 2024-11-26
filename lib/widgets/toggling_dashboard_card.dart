// toggling_dashboard_card.dart

import 'package:flutter/material.dart';

class TogglingDashboardCard extends StatefulWidget {
  final int totalFamilies;
  final int activeFamilies;
  final int inactiveFamilies;
  final String? errorMessage;

  const TogglingDashboardCard({
    super.key,
    required this.totalFamilies,
    required this.activeFamilies,
    required this.inactiveFamilies,
    this.errorMessage,
  });

  @override
  TogglingDashboardCardState createState() => TogglingDashboardCardState();
}

class TogglingDashboardCardState extends State<TogglingDashboardCard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late int _displayedValue;
  late String _displayedTitle;
  late AnimationController _controller;
  late Animation<int> _animation;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _displayedValue = widget.totalFamilies;
    _displayedTitle = 'Total Families'; // Initial title

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: _displayedValue).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();

    // Remove the Theme.of(context) call from initState()
    // _color = Theme.of(context).colorScheme.primary; // Remove this line
  }

  // Add didChangeDependencies method
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize _color here
    _color = Theme.of(context).colorScheme.primary;
  }

  void _toggleValue() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % 3;
      _controller.reset(); // Reset animation for new value

      switch (_currentIndex) {
        case 0:
          _displayedValue = widget.totalFamilies;
          _displayedTitle = 'Total Families';
          _color = Theme.of(context).colorScheme.primary;
          break;
        case 1:
          _displayedValue = widget.activeFamilies;
          _displayedTitle = 'Active Families';
          _color = Theme.of(context).colorScheme.secondary;
          break;
        case 2:
          _displayedValue = widget.inactiveFamilies;
          _displayedTitle = 'Inactive Families';
          _color = Theme.of(context).colorScheme.error;
          break;
      }

      _animation = IntTween(begin: 0, end: _displayedValue).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      )..addListener(() {
        setState(() {});
      });

      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjusted minimum and maximum sizes
        const double minBoxSize = 50;
        const double maxBoxSize = 150;

        double boxSize = constraints.maxWidth * 0.5;
        boxSize = boxSize.clamp(minBoxSize, maxBoxSize);

        double fontSize = boxSize * 0.4;
        const double minFontSize = 24;
        const double maxFontSize = 64;
        fontSize = fontSize.clamp(minFontSize, maxFontSize);

        const double borderRadius = 16;

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300), // Adjust as needed
          child: InkWell(
            onTap: widget.errorMessage == null
                ? _toggleValue
                : null, // Disable tapping if there's an error
            borderRadius: BorderRadius.circular(borderRadius),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              // Remove hardcoded color
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min, // Makes the Column wrap its content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error Message or Title
                    if (widget.errorMessage != null) ...[
                      Text(
                        "Oops! We couldn't load the dashboard right now. Please try again later.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ] else ...[
                      Text(
                        _displayedTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      // Animated Count
                      Center(
                        child: Container(
                          width: boxSize,
                          height: boxSize,
                          decoration: BoxDecoration(
                            color: _color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(borderRadius),
                            border: Border.all(
                              color: _color,
                              width: 2.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _animation.value.toString(),
                            style: TextStyle(
                              fontSize: fontSize,
                              color: _color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 20,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tap to toggle',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
