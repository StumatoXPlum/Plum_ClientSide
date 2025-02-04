// class MoneyBarGraph extends StatefulWidget {
//  const MoneyBarGraph({
//    super.key,
//    required this.graphVm,
//    required this.width,
//    required this.height,
//    this.onBarTap,
//  });


//  final MoneyBarGraphVm graphVm;
//  final void Function(int, bool)? onBarTap;
//  final double width;


//  /// Height of the Bar Graph, Widget is not guaranteed to take this exact height due to
//  /// some added decorations
//  final double height;


//  @override
//  State<MoneyBarGraph> createState() => _MoneyBarGraphState();
// }


// class _MoneyBarGraphState extends State<MoneyBarGraph> {
//  final double _barWidth = 28;
//  final double _barLabelHeight = 36;
//  final double _averageLineHeight = 16;
//  final double _barTooltipHeight = 22;
//  final _visibilityDetectorKey = UniqueKey();


//  late int _selectedIndex;
//  bool _shouldAnimateFast = false;
//  bool _shouldAnimate = true;
//  Timer? animationDelayTimer;
//  Timer? animationTimer;


//  int delayDuration = 200, animationDuration = 500;


//  @override
//  void initState() {
//    super.initState();
//    _selectedIndex = widget.graphVm.selectedBarIndex;
//    widget.onBarTap?.call(_selectedIndex, false);
//  }


//  void _alocateTimer() {
//    WidgetsBinding.instance.addPostFrameCallback((_) {
//      animationTimer = Timer(Duration(milliseconds: animationDuration), () {
//        setState(() {
//          _shouldAnimateFast = true;
//        });
//      });
//    });
//  }


//  @override
//  void dispose() {
//    animationDelayTimer?.cancel();
//    animationTimer?.cancel();
//    super.dispose();
//  }


//  @override
//  void didUpdateWidget(covariant MoneyBarGraph oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.graphVm != oldWidget.graphVm) {
//      _selectedIndex = widget.graphVm.selectedBarIndex;
//      widget.onBarTap?.call(_selectedIndex, false);
//    }
//  }


//  void _handleBarTap(int index) {
//    final touchedIndexYValue = widget.graphVm.dataPoints[index].yValue;
//    if (index != _selectedIndex && touchedIndexYValue > 0) {
//      setState(() {
//        _selectedIndex = index;
//      });
//      widget.onBarTap?.call(index, true);
//    }
//  }


//  @override
//  Widget build(BuildContext context) {
//    final maxYValue = widget.graphVm.maxYAxisValue;
//    final averageValue = widget.graphVm.averageValue;
//    final numberOfBars = widget.graphVm.numberOfBars;


//    return VisibilityDetector(
//      key: _visibilityDetectorKey,
//      onVisibilityChanged: (!_shouldAnimate)
//          ? null
//          : (info) {
//              if (info.visibleFraction > 0.75) {
//                _alocateTimer();
//                setState(() {
//                  _shouldAnimate = false;
//                });
//              }
//            },
//      child: SizedBox(
//        width: widget.width,
//        height: widget.height + _barTooltipHeight,
//        child: Stack(
//          alignment: Alignment.bottomCenter,
//          children: [
//            Positioned(
//              top: _barTooltipHeight,
//              bottom: 0,
//              left: 0,
//              right: 0,
//              child: _GraphGrid(numberOfBars, _barLabelHeight),
//            ),
//            SizedBox(
//              width: widget.width,
//              height: widget.height,
//              child: BarChart(
//                swapAnimationCurve: Curves.easeInOutCubic,
//                swapAnimationDuration:
//                    _shouldAnimateFast ? const Duration(milliseconds: 150) : Duration(milliseconds: animationDuration),
//                BarChartData(
//                  barGroups: MoneyBarGraphUtils.getBarGroupData(
//                    dataPoints: widget.graphVm.dataPoints,
//                    barWidth: _barWidth,
//                    selectedIndex: _selectedIndex,
//                    zeroHeight: _shouldAnimate,
//                  ),
//                  borderData: FlBorderData(show: false),
//                  alignment: BarChartAlignment.spaceAround,
//                  gridData: const FlGridData(show: false),
//                  maxY: maxYValue,
//                  titlesData: MoneyBarGraphUtils.getTitlesData(
//                    titleWidgetGetter: (index) => DebounceGestureDetector(
//                      onTap: () => _handleBarTap(index),
//                      child: _BarLabel(
//                        label: widget.graphVm.dataPoints[index].xLabel,
//                        subLabel: widget.graphVm.dataPoints[index].xSubLabel,
//                      ),
//                    ),
//                    barLabelHeight: _barLabelHeight,
//                  ),
//                  barTouchData: BarTouchData(
//                    handleBuiltInTouches: false,
//                    touchCallback: (touchEvent, touchResponse) {
//                      if (touchEvent is FlTapUpEvent) {
//                        final touchedIndex = touchResponse?.spot?.touchedBarGroupIndex;
//                        if (touchedIndex == null) return;
//                        _handleBarTap(touchedIndex);
//                      }
//                    },
//                    touchTooltipData: BarTouchTooltipData(
//                      getTooltipItem: (group, groupIndex, rod, rodIndex) => null,
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            if (averageValue != null) ...[
//              Positioned(
//                bottom: getAverageLinePosition(maxYValue: maxYValue, averageValue: averageValue),
//                left: 0,
//                right: 0,
//                height: _averageLineHeight,
//                child: _AverageLine(averageLabel: widget.graphVm.averageLabel, numberOfBars: numberOfBars),
//              ),
//            ],
//            Positioned(
//              bottom: _barLabelHeight,
//              left: 0,
//              right: 0,
//              top: 0,
//              child: _BarTooltips(
//                numberOfBars: numberOfBars,
//                dataPoints: widget.graphVm.dataPoints,
//                barGraphHeight: widget.height,
//                barLabelHeight: _barLabelHeight,
//                maxYValue: maxYValue,
//                selectedIndex: _selectedIndex,
//                tooltipHeight: _barTooltipHeight,
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }


//  double getAverageLinePosition({required double maxYValue, required double averageValue}) {
//    final multiplier = (widget.height - _barLabelHeight) / maxYValue;
//    final _halfAverageLineHeight = _averageLineHeight / 2;
//    return _barLabelHeight + (multiplier * averageValue) - _halfAverageLineHeight;
//  }
// }


// class _GraphGrid extends StatelessWidget {
//  const _GraphGrid(this.numberOfBars, this.barLabelHeight);


//  final int numberOfBars;
//  final double strokeWidth = 0.4;
//  final double dashSize = 2.5;
//  final double dashSpace = 1.5;
//  final double barLabelHeight;


//  @override
//  Widget build(BuildContext context) {
//    final numberOfGrids = numberOfBars + 1;


//    return Stack(
//      children: [
//        Positioned(
//          left: 0,
//          right: 0,
//          bottom: barLabelHeight,
//          height: 1,
//          child: Container(color: PopColors.popBlack_500_10),
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: List.generate(
//            numberOfGrids,
//            (index) => DottedLine(
//              color: PopColors.popBlack_500_50,
//              direction: DottedLineDirection.vertical,
//              strokeWidth: strokeWidth,
//              dashSpace: dashSpace,
//              dashSize: dashSize,
//            ),
//          ),
//        ),
//      ],
//    );
//  }
// }


// class _BarLabel extends StatelessWidget {
//  const _BarLabel({
//    required this.label,
//    required this.subLabel,
//  });


//  final String? label;
//  final String? subLabel;


//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: [
//        const SizedBox(height: 9),
//        CustomRichText(
//          text: label,
//          textStyle: LightHeadings.b10.popBlack_500_50,
//        ),
//        const SizedBox(height: 2),
//        CustomRichText(
//          text: subLabel,
//          textStyle: LightHeadings.b8.popBlack_500.getTabularFiguresFontFeatures(),
//        ),
//      ],
//    );
//  }
// }


// /// The average represents average for n-1 bars
// class _AverageLine extends StatelessWidget {
//  const _AverageLine({this.averageLabel, required this.numberOfBars});


//  final String? averageLabel;
//  final strokeWidth = 0.4;
//  final borderRadius = 50.0;
//  final borderWidth = 0.5;
//  final fontSize = 9.0;
//  final int numberOfBars;
//  final int numberOfBarsToExclude = 1;


//  @override
//  Widget build(BuildContext context) {
//    if (numberOfBars <= 1) return const SizedBox.shrink();


//    return Row(
//      mainAxisSize: MainAxisSize.max,
//      children: [
//        Expanded(
//          flex: numberOfBars - numberOfBarsToExclude,
//          child: Stack(
//            alignment: Alignment.center,
//            children: [
//              DottedLine(
//                color: PopColors.popPakGreen_600,
//                direction: DottedLineDirection.horizontal,
//                strokeWidth: strokeWidth,
//                dashSpace: 1,
//                dashSize: 1,
//              ),
//              if (averageLabel != null) ...[
//                Container(
//                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                  decoration: BoxDecoration(
//                    color: PopColors.popWhite,
//                    borderRadius: BorderRadius.circular(borderRadius),
//                    border: Border.all(
//                      color: PopColors.popPakGreen_600,
//                      width: borderWidth,
//                    ),
//                  ),
//                  child: CustomRichText(
//                    text: averageLabel,
//                    textStyle:
//                        LightHeadings.b10.popPakGreen_600.copyWith(fontSize: fontSize).getTabularFiguresFontFeatures(),
//                  ),
//                ),
//              ],
//            ],
//          ),
//        ),
//        Expanded(flex: numberOfBarsToExclude, child: const SizedBox.shrink()),
//      ],
//    );
//  }
// }


// class _BarTooltips extends StatelessWidget {
//  const _BarTooltips({
//    required this.numberOfBars,
//    required this.dataPoints,
//    required this.barGraphHeight,
//    required this.barLabelHeight,
//    required this.maxYValue,
//    required this.selectedIndex,
//    required this.tooltipHeight,
//  });


//  final int numberOfBars;
//  final List<MoneyBarGraphDataPointVm> dataPoints;
//  final double barGraphHeight;
//  final double barLabelHeight;
//  final double maxYValue;
//  final int selectedIndex;
//  final double tooltipHeight;


//  @override
//  Widget build(BuildContext context) {
//    if (numberOfBars == 0) return const SizedBox.shrink();


//    return Row(
//      children: List.generate(numberOfBars, (index) {
//        final data = dataPoints.getOrNull(index);


//        return Expanded(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: [
//              (selectedIndex == index)
//                  ? Stack(
//                      children: [
//                        Positioned.fill(
//                          child: CredAsset(
//                            url: Assets.svg.icMoneyDownTooltip,
//                            type: AssetType.svg,
//                            storageType: AssetStorageType.asset,
//                            fit: BoxFit.fill,
//                            showDefaultPlaceholder: false,
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 14),
//                          child: FittedBox(
//                            fit: BoxFit.scaleDown,
//                            child: CustomRichText(
//                              text: data?.yLabel,
//                              textStyle: LightHeadings.b10.popBlack_500.getTabularFiguresFontFeatures(),
//                            ),
//                          ),
//                        ),
//                      ],
//                    )
//                  : const SizedBox.shrink(),
//              const SizedBox(height: 8),
//              SizedBox(
//                height: getBarHeight(maxYValue: maxYValue, barValue: data?.yValue ?? 0),
//              ),
//            ],
//          ),
//        );
//      }),
//    );
//  }


//  double getBarHeight({required double maxYValue, required double barValue}) {
//    final multiplier = (barGraphHeight - barLabelHeight) / maxYValue;
//    return multiplier * barValue;
//  }
// }
