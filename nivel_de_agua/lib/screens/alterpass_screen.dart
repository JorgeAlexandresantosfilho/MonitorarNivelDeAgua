// esqueceu_senha_screen.dart
import 'package:flutter/material.dart';

class EsqueceuSenhaScreen extends StatefulWidget {
  const EsqueceuSenhaScreen({super.key});

  @override
  State<EsqueceuSenhaScreen> createState() => _EsqueceuSenhaScreenState();
}

class _EsqueceuSenhaScreenState extends State<EsqueceuSenhaScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _recuperarSenha() {
    if (_formKey.currentState!.validate()) {
      {
        // Aqui simularia envio de email
        showDialog(
          context: context,
          builder:
              (_) => const AlertDialog(
                title: Text('Recuperação de Senha'),
                content: Text(
                  'Se o e-mail estiver correto, você receberá instruções.',
                ),
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar Senha")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Informe seu e-mail para recuperar a senha:"),
              const SizedBox(height: 24),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  if (!value.contains('@') ||
                      !value.contains('.') ||
                      value.length < 5) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _recuperarSenha,
                child: const Text("Recuperar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
