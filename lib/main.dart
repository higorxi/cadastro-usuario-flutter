import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Usuário',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  bool _ocultarSenha = true;
  bool _ocultarConfirmacao = true;

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  String? _obrigatorio(String? v, String campo) =>
      (v == null || v.trim().isEmpty) ? 'Informe $campo' : null;

  void _cadastrar() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      messenger.showSnackBar(const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
      ));
    } else {
      messenger.showSnackBar(const SnackBar(
        content: Text('Corrija os campos inválidos.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Nome completo', border: OutlineInputBorder()),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                validator: (v) => _obrigatorio(v, 'o nome completo'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'E-mail', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final erro = _obrigatorio(v, 'o e-mail');
                  if (erro != null) return erro;
                  if (!v!.contains('@')) return 'O e-mail deve conter @';
                  if (!_emailRegex.hasMatch(v.trim())) return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'CPF (somente números)',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (v) {
                  final erro = _obrigatorio(v, 'o CPF');
                  if (erro != null) return erro;
                  return v!.length == 11 ? null : 'O CPF deve ter 11 dígitos';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Telefone (somente números)',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (v) {
                  final erro = _obrigatorio(v, 'o telefone');
                  if (erro != null) return erro;
                  return v!.length >= 10 ? null : 'Telefone com DDD (10 ou 11 dígitos)';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: _ocultarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_ocultarSenha
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                  ),
                ),
                validator: (v) {
                  final erro = _obrigatorio(v, 'a senha');
                  if (erro != null) return erro;
                  return v!.length >= 6 ? null : 'Mínimo de 6 caracteres';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: _ocultarConfirmacao,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_ocultarConfirmacao
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => _ocultarConfirmacao = !_ocultarConfirmacao),
                  ),
                ),
                validator: (v) {
                  final erro = _obrigatorio(v, 'a confirmação da senha');
                  if (erro != null) return erro;
                  return v == _senhaController.text
                      ? null
                      : 'As senhas não coincidem';
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cadastrar,
                  child: const Text('CADASTRAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
