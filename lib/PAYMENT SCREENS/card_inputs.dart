import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../COMPONENTS/reuseable_card_input.dart';
import '../PROVIDERS/atm_idetails.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

class AtmCardScreen extends StatefulWidget {
  @override
  _AtmCardScreenState createState() => _AtmCardScreenState();
}

class _AtmCardScreenState extends State<AtmCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();

  void _handlePaymentInitialization(CardProvider provider) async {
    PayWithPayStack().now(
      context: context,
      //  secretKey: 'pk_test_de51f82ca89566c04d71f6a105489279109f882a',
      secretKey: 'sk_test_51c1d0389dc99942929baeed8e28f79c72fc5206',
      customerEmail: "adamobonyilo@gmail.com",
      reference: DateTime.now().millisecondsSinceEpoch.toString(),
      currency: 'NGN',
      amount: 1000, // Amount in kobo (100 NGN)
      metaData: {
        'custom_fields': [
          {
            'display_name': 'Card Name',
            'variable_name': 'card_name',
            'value': provider.cardNameController.text,
          }
        ]
      },
      callbackUrl: '',
      transactionCompleted: () {
        if (kDebugMode) {
          print('Payment successful');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful')),
        );
        // Handle successful payment
      },
      transactionNotCompleted: () {
        if (kDebugMode) {
          print('Payment not completed');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment not completed')),
        );
        // Handle payment not completed
      },
    );
  }

  // void _checkpayment() {
  // try {
  // PayStackManager(context: context)

  // } catch (error) {
  // if (kDebugMode) {
  // print("payment error ==$error");
  // }
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Payment data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<CardProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AtmcardTextFormField(
                    hintText: 'Enter card name',
                    controller: provider.cardNameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Card Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AtmcardTextFormField(
                    hintText: 'Card Number',
                    controller: _cardNumberController,
                    isCardNumberField: true,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expiry Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            AtmcardTextFormField(
                              hintText: 'MM/YY',
                              controller: provider.expiryDateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter expiry date';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CVV/CVC',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            AtmcardTextFormField(
                              hintText: 'Enter CVV/CVC',
                              controller: provider.cvvController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter CVV/CVC';
                                } else if (value.length != 3) {
                                  return 'CVV/CVC must be 3 digits';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 52.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _handlePaymentInitialization(provider),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
