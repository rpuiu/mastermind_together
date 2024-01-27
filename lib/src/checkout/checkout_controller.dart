import 'package:get/get.dart';
import 'package:mastermind_together/src/services/stripe/stripe_service.dart';
import 'package:mastermind_together/src/services/supa/auth_service.dart';
import 'package:mastermind_together/src/util/url_launcher.dart';

class CheckoutController extends GetxController {
  final StripeService stripeService = Get.find<StripeService>();
  final AuthService authService = Get.find<AuthService>();
  RxBool isLoading = false.obs;
  bool isInitiated = false;
  // http://localhost:8203/checkout?priceId=price_1OYucUHPkeaXjgQcVbNepMBd

  Future<void> initiateCheckout({required String priceId, required String successURL}) async {
    if (!isInitiated) {
      print("Initiate Checkout called");
      try {
        isLoading.value = true;

        // Construct the data required for the Stripe checkout
        var cancelURL = "https://yourdomain.com/cancel";

        final data = {
          "priceId": priceId,
          "mode": "subscription",
          "successUrl": successURL,
          "cancelUrl": cancelURL,
          "userId": authService.getUser()!.id,
          "userEmail": authService.getUser()!.email,
        };

        // Call the StripeService to initiate the checkout
        String checkoutUrl = await stripeService.checkout(data);

        await launchURL(checkoutUrl);
        isInitiated = true;
      } catch (e) {
        Get.snackbar('Error', 'Checkout failed: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
