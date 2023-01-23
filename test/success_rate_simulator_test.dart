import 'package:caniroll/success_rate_simulator.dart';
import 'package:test/test.dart';

void main() {
  group("calculation with target 16 for 5 dices", () {
    test(
      "d4",
      () async {
        final calculator = SuccessRateCalculator();
        var s = await calculator
            .runSuccessRateCalculationAndSimulation([4, 4, 4, 4, 4], 16, 0);
        s.forEach((element) {
          var typedElement = element as Map<String, double>;
          switch (typedElement.entries.first.key) {
            case "successRate":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.1181640625);
              break;
            case "4":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.42919921875);
              break;
            case "6":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.5636393229166666);
              break;
            case "8":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.663330078125);
              break;
            case "10":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.72998046875);
              break;
            case "12":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.7749837239583334);
              break;
            case "20":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.864990234375);
              break;
          }
        });
      },
    );
    test(
      "d6",
      () async {
        final calculator = SuccessRateCalculator();
        var s = await calculator
            .runSuccessRateCalculationAndSimulation([6, 6, 6, 6, 6], 16, 0);
        s.forEach((element) {
          var typedElement = element as Map<String, double>;
          switch (typedElement.entries.first.key) {
            case "successRate":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.6948302469135802);
              break;
            case "4":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.8674447016460906);
              break;
            case "6":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9035279492455418);
              break;
            case "8":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9264081790123457);
              break;
            case "10":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9410365226337448);
              break;
            case "12":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9508637688614541);
              break;
            case "20":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9705182613168725);
              break;
          }
        });
      },
    );
    test(
      "d12",
      () async {
        final calculator = SuccessRateCalculator();
        var s = await calculator.runSuccessRateCalculationAndSimulation(
            [12, 12, 12, 12, 12], 16, 0);
        s.forEach((element) {
          var typedElement = element as Map<String, double>;
          switch (typedElement.entries.first.key) {
            case "successRate":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9879316165123457);
              break;
            case "4":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.995435675475823);
              break;
            case "6":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9967039341135117);
              break;
            case "8":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9974892698688271);
              break;
            case "10":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9979886027520576);
              break;
            case "12":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9983238356267147);
              break;
            case "20":
              var succesRate = typedElement.entries.first.value;
              expect(succesRate, 0.9989943013760288);
              break;
          }
        });
      },
    );
  });
}
