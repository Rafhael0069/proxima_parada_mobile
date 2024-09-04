import 'package:flutter/material.dart';

class UserStatusButton extends StatelessWidget {
  final bool isDriver;
  final bool isRequestBeDriveOpen;
  final bool isRequestDenied;
  final VoidCallback onRequestBeDrive;

  const UserStatusButton({
    super.key,
    required this.isDriver,
    required this.isRequestBeDriveOpen,
    required this.isRequestDenied,
    required this.onRequestBeDrive,
  });

  @override
  Widget build(BuildContext context) {
    if (isDriver) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(45),
          backgroundColor: Colors.green,
        ),
        onPressed: () {
          // Ação para quando o usuário é um motorista
        },
        child: const Text(
          'Você é um motorista',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    } else if (isRequestBeDriveOpen) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(45),
          backgroundColor: isRequestDenied ? Colors.red : Colors.yellow,
        ),
        onPressed: () {
          // Ação para quando a solicitação foi negada ou está aguardando
        },
        child: Text(
          isRequestDenied ? 'Solicitação negada' : 'Aguardando avaliação',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(45),
        ),
        onPressed: onRequestBeDrive,
        child: const Text(
          'Quero oferecer caronas',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }
}
